//
//  SAIntro1ViewController.m
//  SportsApp
//
//  Created by Bharbara Cechin on 01/05/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "SAIntro1ViewController.h"

@interface SAIntro1ViewController ()
//@property (strong, nonatomic) IBOutlet UIView *intro1view;
@property (weak, nonatomic) IBOutlet UIView *signupView;
@property (weak, nonatomic) IBOutlet UIView *loginView;

@end

@implementation SAIntro1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //add border and margin to buttons view
    self.signupView.layer.borderColor = [UIColor colorWithRed:50/255.0 green:226/255.0 blue:196/255.0 alpha:1.0].CGColor;
    self.signupView.layer.borderWidth = 2.0;
    self.signupView.layer.cornerRadius = 8.0;
    self.loginView.layer.borderColor = [UIColor colorWithRed:50/255.0 green:226/255.0 blue:196/255.0 alpha:1.0].CGColor;
    self.loginView.layer.borderWidth = 2.0;
    self.loginView.layer.cornerRadius = 8.0;
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)actionSignUp:(id)sender {
}

- (IBAction)actionLogin:(id)sender {
}
@end
