//
//  SAAskTheUserToCustomizeProfileViewController.m
//  SportsApp
//
//  Created by Bruno Scheltzke on 12/05/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "SAAskTheUserToCustomizeProfileViewController.h"
#import "SAGenderSelectionViewController.h"


@interface SAAskTheUserToCustomizeProfileViewController ()
@property (weak, nonatomic) IBOutlet UIView *noView;
@property (weak, nonatomic) IBOutlet UIView *yesView;

@end

@implementation SAAskTheUserToCustomizeProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //add border and margin to buttons view
    self.noView.layer.borderColor = [UIColor colorWithRed:50/255.0 green:226/255.0 blue:196/255.0 alpha:1.0].CGColor;
    self.noView.layer.borderWidth = 2.0;
    self.noView.layer.cornerRadius = 8.0;
    self.yesView.layer.borderColor = [UIColor colorWithRed:50/255.0 green:226/255.0 blue:196/255.0 alpha:1.0].CGColor;
    self.yesView.layer.borderWidth = 2.0;
    self.yesView.layer.cornerRadius = 8.0;
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
- (IBAction)gotToFinishSignUp:(UIButton *)sender {
    UIStoryboard *secondary = [UIStoryboard storyboardWithName:@"Secondary" bundle:nil];
    SAGenderSelectionViewController *genderSelection = [secondary instantiateViewControllerWithIdentifier:@"genderSelectionView"];
    
    genderSelection.user = self.user;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:genderSelection animated:YES completion:^{
            
        }];
    });
}
- (IBAction)goToFeed:(UIButton *)sender {
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *destination = [main instantiateViewControllerWithIdentifier:@"view2"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:destination animated:YES completion:^{
            
        }];
    });
}

@end
