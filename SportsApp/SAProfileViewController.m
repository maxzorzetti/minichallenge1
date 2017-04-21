
//
//  SAProfileViewController.m
//  SportsApp
//
//  Created by Laura Corssac on 21/04/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "SAProfileViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <UNIRest.h>
#import "FBSDKLoginButton.h"

@interface SAProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profilePhoto;
@property (weak, nonatomic) IBOutlet UILabel *userInfo;

@end

@implementation SAProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ( [FBSDKAccessToken currentAccessToken]) {
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                      initWithGraphPath:@"/me"
                                      parameters:@{ @"fields": @"name, picture, friends",}
                                      HTTPMethod:@"GET"];
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            
            if ([error.userInfo[FBSDKGraphRequestErrorGraphErrorCode] isEqual:@200]) {
                NSLog(@"permission error");
            }
            else
            {
                //NSLog(@"fetched user:%@", result );
                //NSLog(@"Nome: %@", [result objectForKey:@"name"]);
                _userInfo.text =[result objectForKey:@"name"];
               // NSLog(@"Facebook id: %@", [result objectForKey:@"id"]);
                _userInfo.text = [_userInfo.text stringByAppendingString:[result objectForKey:@"id"]];
                
                for (id person in [[result objectForKey:@"friends"]objectForKey:@"data"] )
                {
                    //NSLog(@"%@", [person objectForKey:@"name"]);
                    _userInfo.text = [_userInfo.text stringByAppendingString:[person objectForKey:@"name"]];
                    
                    
                }
                
                NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:[[[result objectForKey:@"picture"]objectForKey:@"data"]objectForKey:@"url"]]];
                _profilePhoto.image = [UIImage imageWithData: imageData];
            }
            
            // FBSDKLoginResult.declinedPermissions
            
        }];
        
        
        
    }
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
