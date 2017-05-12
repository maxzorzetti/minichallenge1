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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    self.txtFirstName.delegate = self;
    self.txtLastName.delegate = self;
    self.txtPhoneNumber.delegate = self;
    self.txtPhoneNumber.keyboardType = UIKeyboardTypePhonePad;
    
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
                lastName = names[i];
            }
        }
        
        self.txtFirstName.text = firstName;
        self.txtLastName.text = lastName;
        self.imgProfilePhoto.image = [UIImage imageWithData:self.user.photo];
        if (self.user.telephone) {
            self.txtPhoneNumber.text = self.user.telephone;
        }
    }
}





- (IBAction)joinUsButtonPressed2:(UIButton *)sender {
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


#pragma dismissing keyboard methods
- (void)dismissKeyboard{
    [self.txtPhoneNumber resignFirstResponder];
    [self.txtLastName resignFirstResponder];
    [self.txtFirstName resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    return YES;
}

- (NSString *) removeSpecialCharacterOfString:(NSString *)string{
    string = [string stringByReplacingOccurrencesOfString:@"(" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@")" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"-" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    return string;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == self.txtPhoneNumber) {
        int lengthOfPhoneNumber = (int)[self removeSpecialCharacterOfString:textField.text].length;
        
        //don't let user input more than 11 numbers
        if (range.length==0 && lengthOfPhoneNumber == 11) {
            return NO;
        }
        
        if (lengthOfPhoneNumber == 2) {
            NSString *formattedStr = [self removeSpecialCharacterOfString:textField.text];
            textField.text = [NSString stringWithFormat:@"(%@) ",formattedStr];
            if(range.length == 1){
                textField.text = [NSString stringWithFormat:@"%@",[formattedStr substringToIndex:2]];
            }
        }
        
        if (lengthOfPhoneNumber == 7) {
            NSString *formattedStr = [self removeSpecialCharacterOfString:textField.text];
            textField.text = [NSString stringWithFormat:@"(%@) %@-",[formattedStr substringToIndex:2], [formattedStr substringFromIndex:2]];
            if(range.length == 1){
                textField.text = [NSString stringWithFormat:@"(%@) %@",[formattedStr substringToIndex:2], [formattedStr substringFromIndex:2]];
            }
        }
    }
    
    return YES;
}

@end
