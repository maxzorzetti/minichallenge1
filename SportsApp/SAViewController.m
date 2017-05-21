//
//  ViewController.m
//  SportsApp
//
//  Created by Bruno Scheltzke on 18/04/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "SAViewController.h"
//#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

#import <CommonCrypto/CommonDigest.h>
//#import <FBSDKLoginKit/FBSDKLoginKit.h>
//#import <UNIRest.h>
//#import "FBSDKLoginButton.h"
//#import "FBLoginView.h"
#import "SAPerson.h"
#import "SAUser.h"
#import "SAPersonConnector.h"
#import "SAFirstProfileViewController.h"
#import "SAAskPhoneViewController.h"
#import "SAGenderSelectionViewController.h"
#import "SAAskTheUserToCustomizeProfileViewController.h"

@interface SAViewController ()

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@property CKRecord *personRecord;
@property (weak, nonatomic) IBOutlet UILabel *myLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;

@property (weak, nonatomic) IBOutlet UIView *myView;

@property (weak, nonatomic) IBOutlet UIButton *btnJoinUs;


@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UIImageView *appLogo;


@property (weak, nonatomic) IBOutlet UITextField *lastNameField;

@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (nonatomic) SAPerson *user;

@property NSString *firstName;
@property NSString *lastName;
@property NSString *fullName;
@property NSString *password;
@property NSString *email;
@property int userCommingBack;

@property (nonatomic) CLLocationManager *locationManager;


@end

@implementation SAViewController

- (IBAction)joinUsButtonPressed:(UIButton *)sender {
    
    
    _email = [NSString stringWithFormat:@"%@", _emailField.text];
    _password = [NSString stringWithFormat:@"%@", _passwordField.text];
    
    if ([_email isEqual:@""] || [_password  isEqual:@""])
    {
        _emailField.text =@"";
        _passwordField.text=@"";
        //_infoLabel.text = @"Please, enter your email and password";
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Warning"
                                                                       message:@"Please, fill all the gaps!"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
        
        
        [self changeUserTextField:[UIColor redColor]];
        [self changePwdTextField:[UIColor redColor]];
    }
    else{
    
    CKContainer *container = [CKContainer defaultContainer];
    CKDatabase *publicDatabase = [container publicCloudDatabase];
    
    CKRecord *personRecord = [[CKRecord alloc]initWithRecordType:@"SAPerson"];
    
    
    personRecord[@"email"] = _email;
 
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"email = %@", _email];
    CKQuery *query = [[CKQuery alloc] initWithRecordType:@"SAPerson" predicate:predicate];
    
    
    
    [publicDatabase performQuery:query inZoneWithID:nil completionHandler:^(NSArray *results1, NSError *error) {
        if (error) {
            NSLog(@"error: %@",error.localizedDescription);
        }
        else {
            
            if ([results1 count] == 0) //nao tem registro com aquele nome
            {
                
                
                CKRecord *identityRecord = [[CKRecord alloc]initWithRecordType:@"SAIdentity"];
                
                identityRecord[@"hash"] = [self sha1:_password];
                identityRecord[@"adapter"] = @"AppLogin";
                
                
                [publicDatabase saveRecord:personRecord completionHandler:^(CKRecord *newPersonRecord, NSError *error){
                    if (!error){
                        CKReference *ref = [[CKReference alloc]initWithRecordID:newPersonRecord.recordID action:CKReferenceActionNone];
                        identityRecord[@"userId"] = ref;
                        
                        //create identity
                        [publicDatabase saveRecord:identityRecord completionHandler:^(CKRecord *identityRecord, NSError *error){
                            if (!error){
                                
                                //NSData *photo = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:[[[result objectForKey:@"picture"]objectForKey:@"data"]objectForKey:@"url"]]];
                                self.user = [SAPersonConnector getPersonFromRecord:newPersonRecord andPicture:nil];
                                
                                [self goToGenderSelection];
                            }
                        }];
                    }
                    
                }];

                
            }
            
            else{
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    //Run UI Updates
                    //_firstLabel.text= @"This email already signed up.";
                    //_myLabel.text = @"Please, choose another";
                    _passwordField.text = @"";
                    _emailField.text = @"";
                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Warning"
                                                                                   message:@"This email already registered. Please, chose another!"
                                                                            preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                          handler:^(UIAlertAction * action) {}];
                    
                    [alert addAction:defaultAction];
                    [self presentViewController:alert animated:YES completion:nil];
                    

                    [self changeUserTextField:[UIColor redColor]];
                    [self changePwdTextField:[UIColor redColor]];
                
                
                
                });
              
            }
            
    
}
    }];
}
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(SAViewController *)sender{
    
    
    if ([segue.identifier isEqualToString: @"logInSegue2"]) {
        
        SAFirstProfileViewController *destView = segue.destinationViewController;
        destView.password= sender.password;
        destView.email= sender.email;
    }

    if ([segue.identifier isEqualToString: @"askPhoneSegue"]) {
        
        SAAskPhoneViewController *destView = segue.destinationViewController;
        destView.personRecord= sender.personRecord;
        
    }
    
    if ([segue.identifier isEqualToString: @"askGenderSegue"]) {
        SAGenderSelectionViewController *destView = segue.destinationViewController;
        self.user.email = self.email;
        
        destView.password= sender.password;
        destView.user = self.user;
        
    }
}




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
            
             [publicDatabase performQuery:query inZoneWithID:nil completionHandler:^(NSArray *results1, NSError *error) {
                 if (!error) {
                     
                     //if there is no person with that email signed in app
                     if ([results1 count] == 0)
                     {
                         
                         //create person
                         [publicDatabase saveRecord:personRecord completionHandler:^(CKRecord *newPersonRecord, NSError *error){
                             if (!error){
                                 CKReference *ref = [[CKReference alloc]initWithRecordID:newPersonRecord.recordID action:CKReferenceActionNone];
                                 identityRecord[@"userId"] = ref;
                                 
                                 //create identity
                                 [publicDatabase saveRecord:identityRecord completionHandler:^(CKRecord *identityRecord, NSError *error){
                                     if (!error){
                                         
                                         NSData *photo = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:[[[result objectForKey:@"picture"]objectForKey:@"data"]objectForKey:@"url"]]];
                                         self.user = [SAPersonConnector getPersonFromRecord:newPersonRecord andPicture:photo];
                                         
                                         [self goToGenderSelection];
                                     }
                                 }];
                             }
                             
                         }];
                     }
                     
                     //if there is a person already signed with that email
                     else{
                         id value = [results1 firstObject][@"recordID"];
                         
                         NSPredicate *useridPredicate = [NSPredicate predicateWithFormat:@"userId = %@", value];
                         CKQuery *useridQuery = [[CKQuery alloc] initWithRecordType:@"SAIdentity" predicate:useridPredicate];
                         
                         //check if user was signed with Facebook
                         [publicDatabase performQuery:useridQuery inZoneWithID:nil completionHandler:^(NSArray *results2, NSError *error){
                             if (!error){
                             
                                 NSLog(@"userId already exists");
                                 
                                 int flag=0;
                                 
                                 for (CKRecord *record in results2) {
                                     NSString *adapter = record[@"adapter"];
                                     if ( [adapter isEqualToString:@"Facebook"]) {
                                         
                                         flag=1;
                                         
                                     }
                                 }
                                 
                                 //user signed in using app
                                 if (!flag)
                                 {
                                     //then create another identity for Facebook login
                                     [publicDatabase saveRecord:identityRecord completionHandler:^(CKRecord *artworkRecord, NSError *error){
                                         if (!error){
                                         NSData *photo = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:[[[result objectForKey:@"picture"]objectForKey:@"data"]objectForKey:@"url"]]];
                                         self.user = [SAPersonConnector getPersonFromRecord:[results2 firstObject] andPicture:photo];
                                         
                                         //send person to next view
                                             [self goToGenderSelection];
                                    }}];
                                 }
                                 
                                 //user already signed in using Facebook
                                 else{
                                     NSData *photo = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:[[[result objectForKey:@"picture"]objectForKey:@"data"]objectForKey:@"url"]]];
                                     
                                     self.user = [SAPersonConnector getPersonFromRecord:[results1 firstObject] andPicture:photo];
                                     
                                    _personRecord = personRecord;
                                     
                                     [SAUser saveToUserDefaults:self.user];
                                     NSArray *keys = @[@"username", @"password", @"facebookId"];
                                     NSArray *values = @[self.user.name, _passwordField.text, userFacebookID];
                                     NSDictionary *dicLoginInfo = [[NSDictionary alloc]initWithObjects:values forKeys:keys];
                                     [[NSUserDefaults standardUserDefaults] setObject:dicLoginInfo forKey:@"loginInfo"];
                                     
                                     
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

/*-(void)loginViewShowingLoggedInUser:(FBLoginView *)loginView{
 //self.lblLoginStatus.text = @"You are logged in.";
 
 [self toggleHiddenState:NO];
 }*/

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


- (IBAction)backButtonPressed:(UIButton *)sender {
    
    [self goBackToLaunch];
    
}






-(void)toggleHiddenState:(BOOL)shouldHide{
    // self.lblUsername.hidden = shouldHide;
    // self.lblEmail.hidden = shouldHide;
    //self.profilePicture.hidden = shouldHide;
}

#pragma location methods
- (void)startStandartUpdates{
    if (self.locationManager == nil) {
        self.locationManager = [[CLLocationManager alloc]init];
    }
    
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = 1000;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    if (error) {
        NSLog(@"Error when fetching location: %@", error.description);
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [self.locationManager stopUpdatingLocation];
}

- (void)viewWillAppear:(BOOL)animated{
    
    
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.user = [SAPerson new];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    self.firstNameField.delegate = self;
    self.lastNameField.delegate = self;
    self.emailField.delegate = self;
    self.passwordField.delegate = self;
    
    switch ([CLLocationManager authorizationStatus]) {
            case kCLAuthorizationStatusNotDetermined:
                self.locationManager = [[CLLocationManager alloc]init];
                [self startStandartUpdates];
            
                self.user.locationManager = self.locationManager;
                [self.locationManager requestWhenInUseAuthorization];
                [self.locationManager requestLocation];
                break;
        default:
            break;
    }
    
    
    //[[FBSDKLoginManager new] logOut];
    // Do any additional setup after loading the view, typically from a nib.
    
    //Checa-se se o usuario ja aceitou os termos de uso
    //if (! [FBSDKAccessToken currentAccessToken]) {
        // User is logged in, do work such as go to next view controller.
        FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
        // Optional: Place the button in the center of your view.
        loginButton.center = _myView.center;
        [self.view addSubview:loginButton];
        loginButton.readPermissions =
        @[@"public_profile", @"email", @"user_friends"];
        
        loginButton.delegate = self;
    
    
    self.appLogo.layer.cornerRadius = self.appLogo.frame.size.height /2;
    self.appLogo.layer.masksToBounds = YES;
    self.appLogo.layer.borderWidth = 0;
    
//     [_emailField setSelectedTextRange:NSMakeRange(0, 0)];

   

    //[_emailField setSelectedTextRange:_emailField.beginningOfDocument];
 
    
}

- (void) changeJoinUsButton{
    _btnJoinUs.layer.cornerRadius = 7;
}

- (void) changeUserTextField:(UIColor *)color{
    UITextField *textField = _emailField;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:
                              CGRectMake(1, 1, _emailField.frame.size.width-2, _emailField.frame.size.height-1) byRoundingCorners: UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(7.0, 7.0)];
    
    [self changeTextFieldBorderWithField:textField andMaskPath:maskPath andColor:color];
}

- (void) changePwdTextField:(UIColor *)color{
    UITextField *textField = _passwordField;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:
                              CGRectMake(1, 0, textField.frame.size.width-2, textField.frame.size.height-1) byRoundingCorners: UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(7.0, 7.0)];
    
    [self changeTextFieldBorderWithField:textField andMaskPath:maskPath andColor:color];
}

- (void) changeTextFieldBorderWithField: (UITextField *)textField andMaskPath:(UIBezierPath *)maskPath andColor:(UIColor *)color {
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = textField.bounds;
    maskLayer.path = maskPath.CGPath;
    maskLayer.lineWidth = 1.0;
    
    
    //maskLayer.strokeColor = [UIColor colorWithRed:50.0f/255.0f green:226.0f/255.0f blue:196.0f/255.0f alpha:1.0f].CGColor;
    
    maskLayer.strokeColor = color.CGColor;
    
    maskLayer.fillColor = [UIColor clearColor].CGColor;
    
    [textField.layer addSublayer:maskLayer];
}

-(void)viewDidAppear:(BOOL)animated{
    
    UIColor *greenColor = [UIColor colorWithRed:50.0f/255.0f green:226.0f/255.0f blue:196.0f/255.0f alpha:1.0f];
   	
    //_emailField.text = @"";
    //_passwordField.text = @"";
    [self changeUserTextField:greenColor];
    [self changePwdTextField:greenColor];
    [self changeJoinUsButton];
    
}
- (void)goToFeed{
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *destination = [main instantiateViewControllerWithIdentifier:@"view2"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:destination animated:YES completion:^{
            
        }];
    });
}
- (void)goToPhoneView{
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Secondary" bundle:nil];
    SAAskPhoneViewController *destination = [main instantiateViewControllerWithIdentifier:@"phoneView"];
    
    destination.personRecord= _personRecord;
    
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

- (void)goBackToLaunch{
    UIStoryboard *daBarbara= [UIStoryboard storyboardWithName:@"StoryboardDaBarbara" bundle:nil];
    UIViewController *helloView = [daBarbara instantiateViewControllerWithIdentifier:@"joinView"];
    
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:helloView animated:YES completion:^{
            
        }];
    });
}


- (IBAction) backFromGender:(UIStoryboardSegue*)segue{
    
    
    _passwordField.text = _password;
    _emailField.text = _email;
    _userCommingBack =1;
    
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)dismissKeyboard{
    [self.lastNameField resignFirstResponder];
    [self.firstNameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    [self.emailField resignFirstResponder];
}


@end

