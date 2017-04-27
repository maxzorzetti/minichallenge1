//
//  SASecondaryViewController.m
//  SportsApp
//
//  Created by Bharbara Cechin on 25/04/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "SASecondaryViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <CommonCrypto/CommonDigest.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <UNIRest.h>
#import <QuartzCore/QuartzCore.h>
#import <CloudKit/CloudKit.h>

@interface SASecondaryViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgLogoSecondary;
@property (weak, nonatomic) IBOutlet UITextField *txtUser;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnJoinUs;

@end

@implementation SASecondaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self changeJoinUsButton];
    [self changeUserTextField];
    [self changePwdTextField];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Sets orientation to Portrait
//- (BOOL)shouldAutorotate{
//    return NO;
//}
//
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
//    return UIInterfaceOrientationMaskPortrait;
//}

- (void) changeJoinUsButton{
    _btnJoinUs.layer.cornerRadius = 5;
}

- (void) changeUserTextField{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(1, 1, _txtUser.frame.size.width, _txtUser.frame.size.height-1) byRoundingCorners: UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(6.0, 6.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _txtUser.bounds;
    maskLayer.path = maskPath.CGPath;
    maskLayer.lineWidth = 1.0;
    maskLayer.strokeColor = [UIColor colorWithRed:156.0f/255.0f green:156.0f/255.0f blue:156.0f/255.0f alpha:1.0f].CGColor;
    maskLayer.fillColor = [UIColor clearColor].CGColor;
    
    [_txtUser.layer addSublayer:maskLayer];
}

- (void) changePwdTextField{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(1, 0, _txtPassword.frame.size.width, _txtPassword.frame.size.height-1) byRoundingCorners: UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(6.0, 6.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _txtPassword.bounds;
    maskLayer.path = maskPath.CGPath;
    maskLayer.lineWidth = 1.0;
    maskLayer.strokeColor = [UIColor colorWithRed:156.0f/255.0f green:156.0f/255.0f blue:156.0f/255.0f alpha:1.0f].CGColor;
    maskLayer.fillColor = [UIColor clearColor].CGColor;
    
    [_txtPassword.layer addSublayer:maskLayer];
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
             //personRecord[@"facebookId"] = userFacebookID;
             
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
