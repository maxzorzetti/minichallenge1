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


@interface SAViewController ()



@property (weak, nonatomic) IBOutlet UILabel *myLabel;
//@property CKReference *ref;
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;

@property (weak, nonatomic) IBOutlet UIView *myView;

@property (weak, nonatomic) IBOutlet UIButton *btnJoinUs;

//@property (weak, nonatomic) IBOutlet UITextField *emailField;

@property (weak, nonatomic) IBOutlet UITextField *emailField;


@property (weak, nonatomic) IBOutlet UITextField *lastNameField;

@property (weak, nonatomic) IBOutlet UITextField *passwordField;


//@property (weak, nonatomic) IBOutlet UITextField *answer1;

//@property (weak, nonatomic) IBOutlet UITextField *answer2;


@property NSString *firstName;
@property NSString *lastName;
@property NSString *fullName;
@property NSString *password;


@property NSString *email;
//@property NSArray <NSString *>*choosenQuestions; //POR QUE ID

//@property  int questionNumber;

//@property NSArray <NSString *> *securityQuestions;


@end

@implementation SAViewController






//- (IBAction)finishedSignIn:(UIButton *)sender {
//    
//    _answer = [[NSString alloc] initWithString:  _answer1.text];
//    _email = [[NSString alloc] initWithString:  _emailField.text];
//}




//- (IBAction)question1Chosen:(UIButton *)sender {
//    
//    _questionNumber =1;
//    
//}

//- (IBAction)question2Chosen:(UIButton *)sender {
//    
//    
//    
//    
//    
//    
//    
//    
//    
//}



- (IBAction)joinUsButtonPressed:(UIButton *)sender {
    
    
    _email = [NSString stringWithFormat:@"%@", _emailField.text];
    _password = [NSString stringWithFormat:@"%@", _passwordField.text];
    
    
    
    
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
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self performSegueWithIdentifier:@"logInSegue2" sender:self];
                });
                
                
            }
            
            else
                NSLog(@"Pessoa já existe. Lembrar de colocar isso na tela");
    
}
    }];
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(SAViewController *)sender{
    
    
    if ([segue.identifier isEqualToString: @"logInSegue2"]) {
        
        SAFirstProfileViewController *destView = segue.destinationViewController;
        destView.password= sender.password;
        destView.email= sender.password;
    }}




//- (IBAction)signInButtonPressed:(UIButton *)sender {
//    
//    //NSString *question1 = @"What is the name of your first pet?";
//   // NSString *question2 = @"Which country would you like to visit most?";
//    //NSString *question3 = @"What is the name of your grandmother?";
//    
//    //NSArray <NSString *> *arrayQuestions = [[NSArray alloc] initWithObjects:question1, nil];
//    //NSArray <NSString *> *arrayAnswers = [[NSArray alloc] init];
//    
//    
//    //_questionNumber = 0;
//    //_answer = nil;
//    _email = [NSString stringWithFormat:@"%@", _emailField.text];
//    _password = [NSString stringWithFormat:@"%@", _passwordField.text];
//    
//    //_firstName = [NSString stringWithFormat:@"%@", _firstNameField.text];
//    //_lastName = [NSString stringWithFormat:@"%@", _lastNameField.text];
//    
//    //_fullName = [NSString stringWithFormat:@"%@ %@", _firstName, _lastName];
//    
//    
//    CKContainer *container = [CKContainer defaultContainer];
//    CKDatabase *publicDatabase = [container publicCloudDatabase];
//    
//    CKRecord *personRecord = [[CKRecord alloc]initWithRecordType:@"SAPerson"];
//    CKRecord *identityRecord = [[CKRecord alloc]initWithRecordType:@"SAIdentity"];
//    
//    
//    //_email = _emailField.text;
//    //personRecord[@"name"] = _fullName;
//    personRecord[@"email"] = _emailField.text;
//    
//    
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"email = %@", _email];
//    CKQuery *query = [[CKQuery alloc] initWithRecordType:@"SAPerson" predicate:predicate];
//    
//    
//    identityRecord[@"adapter"] = @"appLogin";
//    identityRecord[@"hash"] = [self sha1:_passwordField.text];
//    
//    
//    [publicDatabase performQuery:query inZoneWithID:nil completionHandler:^(NSArray *results1, NSError *error) {
//        if (error) {
//            NSLog(@"error: %@",error.localizedDescription);
//        }
//        else {
//            //if (![results firstObject]) {
//            if ([results1 count] == 0) //nao tem registro com aquele nome
//            {
//                
//                
////                if (_questionNumber == 1 )
////                    [personRecord setObject:arrayQuestions forKey:@"answers"];
////                
////                
//                //ajeitar isso pra answers
//                
//               // [personRecord setObject:arrayQuestions forKey:@"questions"];
//                [personRecord setObject:_emailField.text forKey:@"email"];
//                
//                
//                [publicDatabase saveRecord:personRecord completionHandler:^(CKRecord *artworkRecord, NSError *error){
//                    if (error) {
//                        NSLog(@"Record Party not created. Error: %@", error.description);
//                    }
//                    else{
//                        CKReference *ref = [[CKReference alloc]initWithRecordID:personRecord.recordID action:CKReferenceActionNone];
//                        identityRecord[@"userId"] = ref;
//                        
//                        NSLog(@"Record Person created");
//                        [publicDatabase saveRecord:identityRecord completionHandler:^(CKRecord *artworkRecord, NSError *error){
//                            if (error) {
//                                NSLog(@"Record Identity not created. Error: %@", error.description);
//                            }
//                            else
//                                NSLog(@"Record Identity created. New person in the app.");
//                                SAPerson *person = [SAPersonConnector getPersonFromRecord:[results1 firstObject] andPicture:nil];
//                                
//                                [SAUser saveToUserDefaults:person];
//                            
//                                //saves user login info in userdefaults
//                                NSDictionary *dicLoginInfo = @{
//                                                               @"username" : person.name,
//                                                               @"password" : _passwordField.text
//                                                               };
//                                [[NSUserDefaults standardUserDefaults] setObject:dicLoginInfo forKey:@"loginInfo"];
//                            
//                                //sets current user
//                                SAUser *obj = [SAUser new];
//                                [obj setCurrentPerson:person];
//                            
//                        }];
//                    }
//                    
//                }];
//            }
//            else{
//                NSLog(@"This username already exists");
//                
//            }
//        }
//    }];
//    
//}






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
             //mexer
             
             // CKRecord *user;
             
             
             [publicDatabase performQuery:query inZoneWithID:nil completionHandler:^(NSArray *results1, NSError *error) {
                 if (error) {
                     NSLog(@"error: %@",error.localizedDescription);
                 }
                 else {
                     //if (![results firstObject]) {
                     if ([results1 count] == 0)
                     {
                         [publicDatabase saveRecord:personRecord completionHandler:^(CKRecord *artworkRecord, NSError *error){
                             if (error) {
                                 NSLog(@"Record Party not created. Error: %@", error.description);
                             }
                             else{
                                 CKReference *ref = [[CKReference alloc]initWithRecordID:personRecord.recordID action:CKReferenceActionNone];
                                 identityRecord[@"userId"] = ref;
                                 
                                 NSLog(@"Record Person created");
                                 [publicDatabase saveRecord:identityRecord completionHandler:^(CKRecord *artworkRecord, NSError *error){
                                     if (error) {
                                         NSLog(@"Record Identity not created. Error: %@", error.description);
                                     }
                                     else
                                         NSLog(@"Record Identity created. New person in the app.");
                                         NSData *photo = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:[[[result objectForKey:@"picture"]objectForKey:@"data"]objectForKey:@"url"]]];
                                         SAPerson *person = [SAPersonConnector getPersonFromRecord:[results1 firstObject] andPicture:[result valueForKey:@"picture"]];
                                         
                                         [SAUser saveToUserDefaults:person];
                                         
                                         //saves user login info in userdefaults
                                         NSDictionary *dicLoginInfo = @{
                                                                        @"username" : person.name,
                                                                        @"password" : _passwordField.text,
                                                                        @"facebookId" : userFacebookID
                                                                        };
                                         [[NSUserDefaults standardUserDefaults] setObject:dicLoginInfo forKey:@"loginInfo"];
                                         //sets current user
                                         SAUser *obj = [SAUser new];
                                         [obj setCurrentPerson:person];
                                 }];
                                 
                                 
                                 
                                 
                                 
                                 
                                 // _ref = [[CKReference alloc]initWithRecordID:personRecord.recordID action:CKReferenceActionNone];
                             }
                             
                         }];
                     }
                     else{
                         NSLog(@"pessoa existente");
                         
                         // Equivalent ways to get a value.
                         id value = [[results1 firstObject] objectForKey:@"recordID"];
                         value = [results1 firstObject][@"recordID"];
                         //user = [results firstObject];
                         // _ref = [[CKReference alloc]initWithRecordID:user.recordID action:CKReferenceActionNone];
                         //[self ref] = ref2;
                         //   CKReference *ref2 = [[CKReference alloc]initWithRecordID:user.recordID action:CKReferenceActionNone];
                         
                         //user.adapter;
                         
                         NSPredicate *useridPredicate = [NSPredicate predicateWithFormat:@"userId = %@", value]; //ccui
                         CKQuery *useridQuery = [[CKQuery alloc] initWithRecordType:@"SAIdentity" predicate:useridPredicate];
                         
                         
                         NSPredicate *adapterPredicate = [NSPredicate predicateWithFormat:@"adapter = %@", identityRecord[@"adapter"]];
                         CKQuery *adapterQuery = [[CKQuery alloc] initWithRecordType:@"SAIdentity" predicate:adapterPredicate];
                         
                         
                         
                         [publicDatabase performQuery:useridQuery inZoneWithID:nil completionHandler:^(NSArray *results2, NSError *error){
                             if (error) {
                                 NSLog(@"error: %@",error.localizedDescription);
                             }
                             else {
                                 NSLog(@"userId already exists");
                                 
                                 
                                 int flag=0;
                                 
                                 for (CKRecord *record in results2) {
                                     NSString *adapter = record[@"adapter"];
                                     if ( [adapter isEqualToString:@"Facebook"]) {
                                         
                                         flag=1;
                                         
                                         
                                     }
                                 }
                                 if (!flag)
                                 {
                                     [publicDatabase saveRecord:identityRecord completionHandler:^(CKRecord *artworkRecord, NSError *error){
                                         if (error) {
                                             NSLog(@"Record Identity not created. Error: %@", error.description);
                                         }
                                         else
                                             NSLog(@"Record Identity created. New person using facebook.");
                                         NSData *photo = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:[[[result objectForKey:@"picture"]objectForKey:@"data"]objectForKey:@"url"]]];
                                         SAPerson *person = [SAPersonConnector getPersonFromRecord:[results2 firstObject] andPicture:photo];
                                         
                                         [SAUser saveToUserDefaults:person];
                                         
                                         //saves user login info in userdefaults
                                         NSDictionary *dicLoginInfo = @{
                                                                        @"username" : person.name,
                                                                        @"password" : _passwordField.text,
                                                                        @"facebookId" : userFacebookID
                                                                        };
                                         [[NSUserDefaults standardUserDefaults] setObject:dicLoginInfo forKey:@"loginInfo"];
                                         //sets current user
                                         SAUser *obj = [SAUser new];
                                         [obj setCurrentPerson:person];
                                         
                                     }];
                                     
                                 }
                                 else{
                                     NSData *photo = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:[[[result objectForKey:@"picture"]objectForKey:@"data"]objectForKey:@"url"]]];
                                     
                                     SAPerson *person = [SAPersonConnector getPersonFromRecord:[results1 firstObject] andPicture:photo];
                                     
                                     [SAUser saveToUserDefaults:person];
                                     
                                     //saves user login info in userdefaults
                                     NSArray *keys = @[@"username", @"password", @"facebookId"];
                                     NSArray *values = @[person.name, _passwordField.text, userFacebookID];
                                     NSDictionary *dicLoginInfo = [[NSDictionary alloc]initWithObjects:values forKeys:keys];
                                     [[NSUserDefaults standardUserDefaults] setObject:dicLoginInfo forKey:@"loginInfo"];
                                     //sets current user
                                     SAUser *obj = [SAUser new];
                                     [obj setCurrentPerson:person];
                                 }
                                 
                             }
                             
                         }];
                         
                         
                         
                         
                     }
                     
                 }
             }];
             
             
             
             
             
             
             
         }
         else{
             NSLog(@"%@",error.localizedDescription);
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








-(void)toggleHiddenState:(BOOL)shouldHide{
    // self.lblUsername.hidden = shouldHide;
    // self.lblEmail.hidden = shouldHide;
    //self.profilePicture.hidden = shouldHide;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   	
    [self changeJoinUsButton];
    [self changeUserTextField];
    [self changePwdTextField];
    
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
        
        
    //}
    //se nao, pede pra ele!
    //else
    //{
        
        
        // [self performSegueWithIdentifier:@"mySegue" sender:self];
        // NSLog(@"user logged");
    //}
    
    // FBSDKLoginResult.declinedPermissions
    //[imageData release];
    
}

- (void) changeJoinUsButton{
    _btnJoinUs.layer.cornerRadius = 7;
}

- (void) changeUserTextField{
    UITextField *textField = _emailField;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:
                              CGRectMake(1, 1, _emailField.frame.size.width, _emailField.frame.size.height-1) byRoundingCorners: UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(7.0, 7.0)];
    
    [self changeTextFieldBorderWithField:textField andMaskPath:maskPath];
}

- (void) changePwdTextField{
    UITextField *textField = _passwordField;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:
                              CGRectMake(1, 0, textField.frame.size.width, textField.frame.size.height-1) byRoundingCorners: UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(7.0, 7.0)];
    
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


@end

