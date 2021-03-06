//
//  ViewController.h
//  SportsApp
//
//  Created by Bruno Scheltzke on 18/04/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <FacebookSDK/FacebookSDK.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <CloudKit/CloudKit.h>
#import <CoreLocation/CoreLocation.h>



@interface SAViewController : UIViewController <FBSDKLoginButtonDelegate, CLLocationManagerDelegate, UITextFieldDelegate>

-(void)toggleHiddenState:(BOOL)shouldHide;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;


@end

