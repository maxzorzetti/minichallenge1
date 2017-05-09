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
#import "SAInterestsCollectionViewController.h"
#import "SAInterestsNavigationController.h"

@interface SAFirstProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgProfilePhoto;
@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtPhoneNumber;
@property (weak, nonatomic) IBOutlet UIButton *btnJoinUs;


@property (weak, nonatomic) IBOutlet UILabel *infoLabel;



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
    
    
    if (self.user.facebookId) {
        NSArray *names = [self.user.name componentsSeparatedByString:@" "];
        NSString *firstName = [names firstObject];
        NSString *lastName = [NSString new];
        for (int i=0; i<[names count]; i++) {
            if (i!=0) {
                lastName = [NSString stringWithFormat:@"%@%@",lastName,names[i]];
            }
        }
        
        self.txtFirstName.text = firstName;
        self.txtLastName.text = lastName;
        self.imgProfilePhoto.image = [UIImage imageWithData:self.user.photo];
    }
}





- (IBAction)joinUsButtonPressed2:(UIButton *)sender {
    
    
    
    CKContainer *container = [CKContainer defaultContainer];
    CKDatabase *publicDatabase = [container publicCloudDatabase];
    
    CKRecord *personRecord = [[CKRecord alloc]initWithRecordType:@"SAPerson"];
    CKRecord *identityRecord = [[CKRecord alloc]initWithRecordType:@"SAIdentity"];
    
    
    
    NSString *firstName = self.txtFirstName.text;
    NSString *lastName = self.txtLastName.text;
    NSString *fullName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    
    
    if ([firstName isEqualToString:@""] || [lastName isEqualToString:@""]  || [_txtPhoneNumber.text isEqualToString:@""] )
    {
        
        _infoLabel.text = @"Please, fill all the information";
    }
    else{
        [self.user setName:fullName];
        [self.user setTelephone:self.txtPhoneNumber.text];
        [self goToInterestsView];
    }
}
- (void)goToInterestsView{
    
    UIStoryboard *secondary = [UIStoryboard storyboardWithName:@"Secondary" bundle:nil];

    SAInterestsCollectionViewController *destination = [secondary instantiateViewControllerWithIdentifier:@"interestsView"];
    destination.user = self.user;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:destination animated:YES completion:^{
        }];
    });
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


#pragma mark - Navigation

- (IBAction)backFromInterests:(UIStoryboardSegue *)segue{
    
}


@end
