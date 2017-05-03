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

@end

@implementation SAIntro1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    UIColor *lightcolor = [UIColor colorWithRed:119.0f/255.0f green:90.0f/255.0f blue:218.0f/255.0f alpha:0.56f];
//    UIColor *darkcolor = [UIColor colorWithRed:119.0f/255.0f green:90.0f/255.0f blue:218.0f/255.0f alpha:1.0f];
//    
//    CAGradientLayer *gradient = [CAGradientLayer layer];
//    gradient.frame = [_intro1view bounds];
//    gradient.colors = @[(id)lightcolor, (id)darkcolor];
//    gradient.startPoint = CGPointMake(0.5, 1.0);
//    gradient.endPoint = CGPointMake(0.5, 0.0);
//    
//    [self.view.layer insertSublayer:gradient atIndex:0];
    
    
    
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
