//
//  SALogInViewController.m
//  SportsApp
//
//  Created by Laura Corssac on 26/04/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "SALogInViewController.h"
#import <CloudKit/CloudKit.h>
#import "SAPerson.h"
#import <CommonCrypto/CommonDigest.h>
#import "SAUser.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "SAGenderSelectionViewController.h"
#import "SAAskTheUserToCustomizeProfileViewController.h"
#import "SAPersonConnector.h"


@interface SALogInViewController ()
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *appLogo;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (nonatomic) SAPerson *user;
@property (weak, nonatomic) IBOutlet UIView *myView;

@property (weak, nonatomic) IBOutlet UIButton *btnLogIn;

@property NSString *email;
@property NSString *password;


@end

@implementation SALogInViewController

-(void) loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{
    
}



- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"id,name,email,picture" forKey:@"fields"];
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         if (!error) {
             
             CKContainer *container = [CKContainer defaultContainer];
             CKDatabase *publicDatabase = [container publicCloudDatabase];
             
             
             CKRecord *personRecord = [[CKRecord alloc]initWithRecordType:@"SAPerson"];
             CKRecord *identityRecord = [[CKRecord alloc]initWithRecordType:@"SAIdentity"];
             
             
             NSString *userFacebookID = [[FBSDKAccessToken currentAccessToken] userID];
             NSString *userName = [result valueForKey:@"name"];
             NSString *userEmail =[result valueForKey:@"email"];
             
             
             personRecord[@"name"] = userName;
             personRecord[@"email"] = userEmail;
             personRecord[@"facebookId"] = userFacebookID;
             
             NSPredicate *predicate = [NSPredicate predicateWithFormat:@"email = %@", userEmail];
             CKQuery *query = [[CKQuery alloc] initWithRecordType:@"SAPerson" predicate:predicate];
             
             
             identityRecord[@"adapter"] = @"Facebook";
             identityRecord[@"hash"] = userFacebookID;
             
             //check if user already exists in our database
             [publicDatabase performQuery:query inZoneWithID:nil completionHandler:^(NSArray *results1, NSError *error) {
                 if (!error){
                     //if there are no user with that email, create one
                     if ([results1 count] == 0)
                     {
                         [publicDatabase saveRecord:personRecord completionHandler:^(CKRecord *personRecordCreatedFromDB, NSError *error){
                             if (!error){
                                 CKReference *ref = [[CKReference alloc]initWithRecordID:personRecordCreatedFromDB.recordID action:CKReferenceActionNone];
                                 identityRecord[@"userId"] = ref;
                                 
                                 //person created, creates person identity with Facebook
                                 [publicDatabase saveRecord:identityRecord completionHandler:^(CKRecord *artworkRecord, NSError *error){
                                     if (!error){
                                         NSLog(@"Record Identity created. New person in the app.");
                                     NSData *photo = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:[[[result objectForKey:@"picture"]objectForKey:@"data"]objectForKey:@"url"]]];
                                     self.user = [SAPersonConnector getPersonFromRecord:personRecordCreatedFromDB andPicture:photo];
                                     
                                     [SAUser saveToUserDefaults:self.user];
                                     
                                     //saves user login info in userdefaults
                                     NSDictionary *dicLoginInfo = @{
                                                                    @"username" : self.user.name,
                                                                    @"password" : _passwordField.text,
                                                                    @"facebookId" : userFacebookID
                                                                    };
                                     [[NSUserDefaults standardUserDefaults] setObject:dicLoginInfo forKey:@"loginInfo"];
                                     //sets current user
                                     SAUser *obj = [SAUser new];
                                     [obj setCurrentPerson:self.user];
                                         
                                     //do sign up things
                                     [self goToGenderSelection];
                                    }
                                 }];
                            }
                             
                         }];
                     }
                     //if person already exists with that email
                     else{
                         
                         id value = [[results1 firstObject] objectForKey:@"recordID"];
                         value = [results1 firstObject][@"recordID"];
                         
                         NSPredicate *useridPredicate = [NSPredicate predicateWithFormat:@"userId = %@", value];
                         CKQuery *useridQuery = [[CKQuery alloc] initWithRecordType:@"SAIdentity" predicate:useridPredicate];
                         
                         
                         //check if identity is Facebook
                         [publicDatabase performQuery:useridQuery inZoneWithID:nil completionHandler:^(NSArray *results2, NSError *error){
                             if (!error){
                                 
                                 int isPersonSignedUpWithFacebook=0;
                                 
                                 for (CKRecord *record in results2) {
                                     NSString *adapter = record[@"adapter"];
                                     if ( [adapter isEqualToString:@"Facebook"]) {
                                         
                                         isPersonSignedUpWithFacebook=1;
                                     }
                                 }
                                 //if person's identity is not with facebook, create one
                                 if (!isPersonSignedUpWithFacebook)
                                 {
                                     [publicDatabase saveRecord:identityRecord completionHandler:^(CKRecord *artworkRecord, NSError *error){
                                         if (error) {
                                             NSLog(@"Record Identity not created. Error: %@", error.description);
                                         }
                                         else
                                             NSLog(@"Record Identity created. New person using facebook.");
                                         NSData *photo = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:[[[result objectForKey:@"picture"]objectForKey:@"data"]objectForKey:@"url"]]];
                                         self.user = [SAPersonConnector getPersonFromRecord:[results2 firstObject] andPicture:photo];
                                         
                                         [SAUser saveToUserDefaults:self.user];
                                         
                                         //saves user login info in userdefaults
                                         NSDictionary *dicLoginInfo = @{
                                                                        @"username" : self.user.name,
                                                                        @"password" : _passwordField.text,
                                                                        @"facebookId" : userFacebookID
                                                                        };
                                         [[NSUserDefaults standardUserDefaults] setObject:dicLoginInfo forKey:@"loginInfo"];
                                         //sets current user
                                         SAUser *obj = [SAUser new];
                                         [obj setCurrentPerson:self.user];
                                         
                                         [self goToGenderSelection];
                                     }];
                                 }
                                 
                                 //person has signed with Facebook already
                                 else{
                                     NSData *photo = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:[[[result objectForKey:@"picture"]objectForKey:@"data"]objectForKey:@"url"]]];
                                     
                                     self.user = [SAPersonConnector getPersonFromRecord:[results1 firstObject] andPicture:photo];
                                     
                                     [SAUser saveToUserDefaults:self.user];
                                     
                                     //saves user login info in userdefaults
                                     NSArray *keys = @[@"username", @"password", @"facebookId"];
                                     NSArray *values = @[self.user.name, _passwordField.text, userFacebookID];
                                     NSDictionary *dicLoginInfo = [[NSDictionary alloc]initWithObjects:values forKeys:keys];
                                     [[NSUserDefaults standardUserDefaults] setObject:dicLoginInfo forKey:@"loginInfo"];
                                     //sets current user
                                     SAUser *obj = [SAUser new];
                                     [obj setCurrentPerson:self.user];
                                     
                                     
                                     //check if user's profile is set
                                     if (!self.user.gender || [self.user.interests count]==0 || !self.user.telephone) {
                                         //user hasn't fully customized his profile
                                         //go to view where user is asked if user wants to modify profile
                                         [self goToProfileCustomizationDecision];
                                     }else{
                                         [self goToFeed];
                                     }
                                 }
                             }
                         }];
                     }
                 }
             }];
         }
     }];
}



- (IBAction)logingButtonPressed:(UIButton *)sender {
    
    
    _password = [[NSString alloc] initWithString:  _passwordField.text];
    _email = [[NSString alloc] initWithString:  _emailField.text];
    
    
    CKContainer *container = [CKContainer defaultContainer];
    CKDatabase *publicDatabase = [container publicCloudDatabase];
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"email = %@", _email];
    CKQuery *query = [[CKQuery alloc] initWithRecordType:@"SAPerson" predicate:predicate];
    
    
    
    [publicDatabase performQuery:query inZoneWithID:nil completionHandler:^(NSArray *results1, NSError *error) {
        if (error) {
            NSLog(@"error: %@",error.localizedDescription);
        }
        else {
            
            if (results1.count == 0)
            {
                 dispatch_async(dispatch_get_main_queue(), ^(void){
                _infoLabel.text = @"Wrong Username!";
                 });
            }
            
            else
            {
                
                id value = [[results1 firstObject] objectForKey:@"recordID"];
                value = [results1 firstObject][@"recordID"];
                
                NSPredicate *useridPredicate = [NSPredicate predicateWithFormat:@"userId = %@", value];
                CKQuery *useridQuery = [[CKQuery alloc] initWithRecordType:@"SAIdentity" predicate:useridPredicate];
                
                
                [publicDatabase performQuery:useridQuery inZoneWithID:nil completionHandler:^(NSArray *results, NSError *error){
                    if (error) {
                        NSLog(@"error: %@",error.localizedDescription);
                    }
                    
                    else
                    {
                        NSString *adapter = [results firstObject][@"hash"];
                        
                        //NSString *adapterHash = [self sha1:adapter];
                        NSString *passwordHash = [self sha1:_password];
                        
                        
                        if ([adapter isEqualToString: passwordHash]){
                            NSLog(@"You are logged in");
                            SAPerson *person = [SAPersonConnector getPersonFromRecord:[results1 firstObject] andPicture:nil];
                            
                            
                            /////ESSE METODO EH SATANICO --------------------------------------------------
                            
                            [SAUser saveToUserDefaults:person];
                            
                            
                            //saves user login info in userdefaults
                            NSDictionary *dicLoginInfo = @{
                                                           @"username" : person.name,
                                                           @"password" : _password
                                                           };
                            [[NSUserDefaults standardUserDefaults] setObject:dicLoginInfo forKey:@"loginInfo"];
                            
                            //sets current user
                            SAUser *obj = [SAUser new];
                            [obj setCurrentPerson:person];
                            
                            
                            [self goToFeed];
                            //[self performSegueWithIdentifier:@"finishLoginSegue" sender:self];
                        }
                        else{
                             dispatch_async(dispatch_get_main_queue(), ^(void){
                            
                            _infoLabel.text = @"Wrong Password!";
                                 _emailField.text = @"";
                                 _passwordField.text = @"";
                             });
                        }
                    }
                    
                    
                }];
                
            }}}];
}


- (NSString *)sha1:(NSString *)password
{
    NSData *data = [password dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.passwordField.delegate = self;
    self.emailField.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    _btnLogIn.backgroundColor = [UIColor colorWithRed:50 green:226 blue:196 alpha:1];
    
    self.appLogo.layer.cornerRadius = self.appLogo.frame.size.height /2;
    self.appLogo.layer.masksToBounds = YES;
    self.appLogo.layer.borderWidth = 0;
    
    [self changeJoinUsButton];
    [self changeUserTextField];
    [self changePwdTextField];

    
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    // Optional: Place the button in the center of your view.
    loginButton.center = _myView.center;
    [self.view addSubview:loginButton];
    loginButton.readPermissions =
    @[@"public_profile", @"email", @"user_friends"];
    
    loginButton.delegate = self;
    
}


- (void) changeJoinUsButton{
    _btnLogIn.layer.cornerRadius = 7;
}

- (void) changeUserTextField{
    UITextField *textField = _emailField;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:
                              CGRectMake(1, 1, _emailField.frame.size.width-2, _emailField.frame.size.height-1) byRoundingCorners: UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(7.0, 7.0)];
    
    [self changeTextFieldBorderWithField:textField andMaskPath:maskPath];
}

- (void) changePwdTextField{
    UITextField *textField = _passwordField;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:
                              CGRectMake(1, 0, textField.frame.size.width-2, textField.frame.size.height-1) byRoundingCorners: UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(7.0, 7.0)];
    
    [self changeTextFieldBorderWithField:textField andMaskPath:maskPath];
}

- (void) changeTextFieldBorderWithField: (UITextField *)textField andMaskPath:(UIBezierPath *)maskPath{
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = textField.bounds;
    maskLayer.path = maskPath.CGPath;
    maskLayer.lineWidth = 1.0;
    maskLayer.strokeColor = [UIColor colorWithRed:50.0f/255.0f green:226.0f/255.0f blue:196.0f/255.0f alpha:1.0f].CGColor;
    maskLayer.fillColor = [UIColor clearColor].CGColor;
    
    [textField.layer addSublayer:maskLayer];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     if ([segue.identifier isEqualToString: @"finishLoginSegue"]) {
         UITabBarController *destView = segue.destinationViewController;
     
     }
 }

- (void)goToFeed{
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *destination = [main instantiateViewControllerWithIdentifier:@"view2"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
       [self presentViewController:destination animated:YES completion:^{
           
       }];
    });
}

- (void)goToGenderSelection{
    UIStoryboard *secondary = [UIStoryboard storyboardWithName:@"Secondary" bundle:nil];
    SAGenderSelectionViewController *genderSelection = [secondary instantiateViewControllerWithIdentifier:@"genderSelectionView"];
    
    genderSelection.user = self.user;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:genderSelection animated:YES completion:^{
            
        }];
    });
}
- (void)goToProfileCustomizationDecision{
    UIStoryboard *secondary = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SAAskTheUserToCustomizeProfileViewController *wantToCustomize = [secondary instantiateViewControllerWithIdentifier:@"wantToCustomize"];
    
    wantToCustomize.user = self.user;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:wantToCustomize animated:YES completion:^{
            
        }];
    });
}


#pragma keyboard dismissing methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)dismissKeyboard{
    [self.emailField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

@end
