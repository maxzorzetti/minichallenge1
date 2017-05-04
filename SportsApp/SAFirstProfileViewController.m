//
//  SAFirstProfileViewController.m
//  SportsApp
//
//  Created by Bharbara Cechin on 25/04/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "SAFirstProfileViewController.h"
#import <CloudKit/CloudKit.h>
#import "SAPerson.h"
#import "SAPersonConnector.h"
#import <CommonCrypto/CommonDigest.h>
#import "SAUser.h"
#import "SAPerson.h"
#import "SAPersonConnector.h"

@interface SAFirstProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgProfilePhoto;
@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtPhoneNumber;
@property (weak, nonatomic) IBOutlet UIButton *btnJoinUs;





@property (weak, nonatomic) IBOutlet UIButton *joinButton;
@end

@implementation SAFirstProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self changeFirstNameTextField];
    [self changeLastNameTextField];
    [self changePhoneNumberTextField];
    [self changeButtonJoinUs];
}





- (IBAction)joinUsButtonPressed2:(UIButton *)sender {
    
    
    
    CKContainer *container = [CKContainer defaultContainer];
    CKDatabase *publicDatabase = [container publicCloudDatabase];
    
    CKRecord *personRecord = [[CKRecord alloc]initWithRecordType:@"SAPerson"];
    CKRecord *identityRecord = [[CKRecord alloc]initWithRecordType:@"SAIdentity"];
    
    
    
    NSString *firstName = [NSString stringWithFormat:@"%@", _txtFirstName.text];
    NSString *lastName = [NSString stringWithFormat:@"%@", _txtLastName.text];
    NSString *fullName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    
    personRecord[@"email"] = _email;
    personRecord[@"telephone"] = _txtPhoneNumber.text;
    personRecord[@"name"] = fullName;
    
    identityRecord[@"adapter"] = @"appLogin";
    identityRecord[@"hash"] = [self sha1:_password];
    
    
    
    
    [personRecord setObject:_email forKey:@"email"];
    
    
    
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
                SAPerson *person = [SAPersonConnector getPersonFromRecord:artworkRecord andPicture:nil];
                
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
                
            }];
    
    
        }}];
    
    
    
    //PERFORM SEGUE


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



- (void) changeButtonJoinUs{
    _btnJoinUs.layer.cornerRadius = 7;
}

- (void) changeFirstNameTextField{
    UITextField *textField = _txtFirstName;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:
                              CGRectMake(1, 1, textField.frame.size.width, textField.frame.size.height-1) byRoundingCorners: UIRectCornerTopLeft cornerRadii:CGSizeMake(7.0, 7.0)];
    
    [self changeTextFieldBorderWithField:textField andMaskPath:maskPath];
}

- (void) changeLastNameTextField{
    UITextField *textField = _txtLastName;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:
                              CGRectMake(1, 1, textField.frame.size.width-2, textField.frame.size.height-1) byRoundingCorners: UIRectCornerTopRight cornerRadii:CGSizeMake(7.0, 7.0)];
    
    [self changeTextFieldBorderWithField:textField andMaskPath:maskPath];
}

- (void) changePhoneNumberTextField{
    UITextField *textField = _txtPhoneNumber;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
