//
//  SASecondaryViewController.m
//  SportsApp
//
//  Created by Bharbara Cechin on 25/04/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "SASecondaryViewController.h"

@interface SASecondaryViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgLogoSecondary;
@property (weak, nonatomic) IBOutlet UITextField *txtUser;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnJoinUs;

@property (weak, nonatomic) IBOutlet UIButton *btnForgotPassword;

@end

@implementation SASecondaryViewController

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
