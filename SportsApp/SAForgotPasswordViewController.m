//
//  SAForgotPasswordViewController.m
//  SportsApp
//
//  Created by Bharbara Cechin on 25/04/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "SAForgotPasswordViewController.h"
#import <CloudKit/CloudKit.h>

#import <CommonCrypto/CommonDigest.h>

@interface SAForgotPasswordViewController ()

@property (weak, nonatomic) IBOutlet UILabel *question;

@property (weak, nonatomic) IBOutlet UITextField *answerField;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;


@property (weak, nonatomic) IBOutlet UITextField *passwordField;



@end

@implementation SAForgotPasswordViewController


- (IBAction)answerSent:(UIButton *)sender {
    
    
    CKContainer *container = [CKContainer defaultContainer];
    CKDatabase *publicDatabase = [container publicCloudDatabase];
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"email = %@", _usernameField.text];
    CKQuery *query = [[CKQuery alloc] initWithRecordType:@"SAPerson" predicate:predicate];
    
    
    [publicDatabase performQuery:query inZoneWithID:nil completionHandler:^(NSArray *results, NSError *error) {
        if (error) {
            NSLog(@"error: %@",error.localizedDescription);
        }
        else {
            if (results.count == 0)
                NSLog(@"Wrong username");
            else
            {
                NSArray *userQuestions = [results firstObject][@"questions"];
                _question.text = userQuestions[0];
                NSArray *userAnswers = [results firstObject][@"answers"];
                
                
                id value = [[results firstObject] objectForKey:@"recordID"];
                value = [results firstObject][@"recordID"];
                
                NSPredicate *useridPredicate = [NSPredicate predicateWithFormat:@"userId = %@", value]; //ccui
                CKQuery *useridQuery = [[CKQuery alloc] initWithRecordType:@"SAIdentity" predicate:useridPredicate];
                
                
                [publicDatabase performQuery:useridQuery inZoneWithID:nil completionHandler:^(NSArray *results, NSError *error){
                    if (error) {
                        NSLog(@"error: %@",error.localizedDescription);
                    }
                    
                    else
                    {
                        
                        
                        
                        
                        if ( [_answerField.text isEqualToString:userAnswers[0]])
                        {
                            NSLog(@"certo");
                            NSString *newPassword = [ self sha1:_passwordField.text];
                            [results firstObject][@"hash"] = newPassword;
                            
                            [publicDatabase saveRecord:[results firstObject]  completionHandler:^(CKRecord *artworkRecord, NSError *error){
                                if (error) {
                                    NSLog(@"Record Identity not created. Error: %@", error.description);
                                }
                                else
                                    NSLog(@"Senha alterada");
                            }];
                            
                        }
                        else
                            NSLog(@"errada a resposta");
                    }}];
                
                
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



- (IBAction)newPasswordSent:(UIButton *)sender {
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
