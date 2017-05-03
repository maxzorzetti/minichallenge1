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
#import "SAPersonConnector.h"


@interface SALogInViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;



@property NSString *email;
@property NSString *password;

@end

@implementation SALogInViewController




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
                NSLog(@"Wrong username");
            
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
                        }
                        else{
                            NSLog(@"Wrong password");
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
