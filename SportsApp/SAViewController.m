//
//  ViewController.m
//  SportsApp
//
//  Created by Bruno Scheltzke on 18/04/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "SAViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <UNIRest.h>



@interface SAViewController ()
@property (weak, nonatomic) IBOutlet UILabel *myLabel;

@end

@implementation SAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //Checa-se se o usuario ja aceitou os termos de uso
    if (! [FBSDKAccessToken currentAccessToken]) {
        // User is logged in, do work such as go to next view controller.
		
		FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
		// Optional: Place the button in the center of your view.
		loginButton.center = self.view.center;
		[self.view addSubview:loginButton];
		loginButton.readPermissions =
		@[@"public_profile", @"email", @"user_friends"];
		
		
    }
    //se nao, pede pra ele!
    else{
     //   GET graph.facebook.com
       // /{node-id}
		
       /// _myLabel.text = @"You're logged!";
        //[self presentModalViewController:tabBarController animated:YES];
        //[self performSegueWithIdentifier:mySegue sender:self];
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
