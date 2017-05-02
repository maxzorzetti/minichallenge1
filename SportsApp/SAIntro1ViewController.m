//
//  SAIntro1ViewController.m
//  SportsApp
//
//  Created by Bharbara Cechin on 01/05/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "SAIntro1ViewController.h"

@interface SAIntro1ViewController ()
@property (strong, nonatomic) IBOutlet UIView *intro1view;

@end

@implementation SAIntro1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = [_intro1view bounds];
    gradient.colors = @[(id)self.view.tintColor, (id)self.view.backgroundColor];
    gradient.startPoint = CGPointMake(0.5, 1.0);
    gradient.endPoint = CGPointMake(0.5, 0.0);
    
    [self.view.layer insertSublayer:gradient atIndex:0];
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
