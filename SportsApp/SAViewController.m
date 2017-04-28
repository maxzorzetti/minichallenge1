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


@interface SAViewController ()



@property (weak, nonatomic) IBOutlet UILabel *myLabel;
//@property CKReference *ref;
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;



@property (weak, nonatomic) IBOutlet UITextField *emailField;



@property (weak, nonatomic) IBOutlet UITextField *lastNameField;

@property (weak, nonatomic) IBOutlet UITextField *passwordField;


@property (weak, nonatomic) IBOutlet UITextField *answer1;

@property (weak, nonatomic) IBOutlet UITextField *answer2;


@property NSString *firstName;
@property NSString *lastName;
@property NSString *fullName;
@property NSString *answer;


@property NSString *email;
@property NSArray <NSString *>*choosenQuestions; //POR QUE ID

@property  int questionNumber;

@property NSArray <NSString *> *securityQuestions;


@end

@implementation SAViewController






- (IBAction)finishedSignIn:(UIButton *)sender {
    
    _answer = [[NSString alloc] initWithString:  _answer1.text];
    _email = [[NSString alloc] initWithString:  _emailField.text];
}




- (IBAction)question1Chosen:(UIButton *)sender {
    
    _questionNumber =1;
    
}

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

- (IBAction)signInButtonPressed:(UIButton *)sender {
    
    NSString *question1 = @"What is the name of your first pet?";
    NSString *question2 = @"Which country would you like to visit most?";
    NSString *question3 = @"What is the name of your grandmother?";
    
    NSArray <NSString *> *arrayQuestions = [[NSArray alloc] initWithObjects:question1, nil];
    NSArray <NSString *> *arrayAnswers = [[NSArray alloc] init];
    
    
    _questionNumber = 0;
    _answer = nil;
    _email = nil;
    
    _firstName = [NSString stringWithFormat:@"%@", _firstNameField.text];
    _lastName = [NSString stringWithFormat:@"%@", _lastNameField.text];
    
    _fullName = [NSString stringWithFormat:@"%@ %@", _firstName, _lastName];
    
    
    CKContainer *container = [CKContainer defaultContainer];
    CKDatabase *publicDatabase = [container publicCloudDatabase];
    
    CKRecord *personRecord = [[CKRecord alloc]initWithRecordType:@"SAPerson"];
    CKRecord *identityRecord = [[CKRecord alloc]initWithRecordType:@"SAIdentity"];
    
    
    _email = _emailField.text;
    personRecord[@"name"] = _fullName;
    personRecord[@"email"] = _emailField.text;
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"email = %@", _email];
    CKQuery *query = [[CKQuery alloc] initWithRecordType:@"SAPerson" predicate:predicate];
    
    
    identityRecord[@"adapter"] = @"appLogin";
    
    
    
    
    identityRecord[@"hash"] = [self sha1:_passwordField.text];
    
    
    [publicDatabase performQuery:query inZoneWithID:nil completionHandler:^(NSArray *results, NSError *error) {
        if (error) {
            NSLog(@"error: %@",error.localizedDescription);
        }
        else {
            //if (![results firstObject]) {
            if ([results count] == 0) //nao tem registro com aquele nome
            {
                
                
                if (_questionNumber == 1 )
                    [personRecord setObject:arrayQuestions forKey:@"answers"];
                
                
                //ajeitar isso pra answers
                
                [personRecord setObject:arrayQuestions forKey:@"questions"];
                [personRecord setObject:_emailField.text forKey:@"email"];
                
                
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
                            
                            
                        }];
                    }
                    
                }];
            }
            else{
                NSLog(@"This username already exists");
                
            }
        }
    }];
    
}






-(void) loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{
    
}
- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error{
    
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"id,name,email" forKey:@"fields"];
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
             
             
             [publicDatabase performQuery:query inZoneWithID:nil completionHandler:^(NSArray *results, NSError *error) {
                 if (error) {
                     NSLog(@"error: %@",error.localizedDescription);
                 }
                 else {
                     //if (![results firstObject]) {
                     if ([results count] == 0)
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
                                 }];
                                 
                                 
                                 
                                 
                                 
                                 
                                 // _ref = [[CKReference alloc]initWithRecordID:personRecord.recordID action:CKReferenceActionNone];
                             }
                             
                         }];
                     }
                     else{
                         NSLog(@"pessoa existente");
                         
                         // Equivalent ways to get a value.
                         id value = [[results firstObject] objectForKey:@"recordID"];
                         value = [results firstObject][@"recordID"];
                         //user = [results firstObject];
                         // _ref = [[CKReference alloc]initWithRecordID:user.recordID action:CKReferenceActionNone];
                         //[self ref] = ref2;
                         //   CKReference *ref2 = [[CKReference alloc]initWithRecordID:user.recordID action:CKReferenceActionNone];
                         
                         //user.adapter;
                         
                         NSPredicate *useridPredicate = [NSPredicate predicateWithFormat:@"userId = %@", value]; //ccui
                         CKQuery *useridQuery = [[CKQuery alloc] initWithRecordType:@"SAIdentity" predicate:useridPredicate];
                         
                         
                         NSPredicate *adapterPredicate = [NSPredicate predicateWithFormat:@"adapter = %@", identityRecord[@"adapter"]];
                         CKQuery *adapterQuery = [[CKQuery alloc] initWithRecordType:@"SAIdentity" predicate:adapterPredicate];
                         
                         
                         
                         [publicDatabase performQuery:useridQuery inZoneWithID:nil completionHandler:^(NSArray *results, NSError *error){
                             if (error) {
                                 NSLog(@"error: %@",error.localizedDescription);
                             }
                             else {
                                 NSLog(@"userId already exists");
                                 
                                 
                                 int flag=0;
                                 
                                 for (CKRecord *record in results) {
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
                                     }];
                                     
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
   	
    
    
    [[FBSDKLoginManager new] logOut];
    // Do any additional setup after loading the view, typically from a nib.
    
    //Checa-se se o usuario ja aceitou os termos de uso
    if (! [FBSDKAccessToken currentAccessToken]) {
        // User is logged in, do work such as go to next view controller.
        
        NSLog(@"oioioioioi");
        FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
        // Optional: Place the button in the center of your view.
        loginButton.center = ((UIView *)[self.view viewWithTag:1]).center;
        [self.view addSubview:loginButton];
        loginButton.readPermissions =
        @[@"public_profile", @"email", @"user_friends"];
        
        loginButton.delegate = self;
        
        
    }
    //se nao, pede pra ele!
    else
    {
        
        
        NSLog(@"lallallala");
        
        
        // [self performSegueWithIdentifier:@"mySegue" sender:self];
        // NSLog(@"user logged");
    }
    
    // FBSDKLoginResult.declinedPermissions
    //[imageData release];
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

