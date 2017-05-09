//
//  SAGenderSelectionViewController.m
//  SportsApp
//
//  Created by Bruno Scheltzke on 2017-05-09.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "SAGenderSelectionViewController.h"
#import "SAPerson.h"
#import "SAFirstProfileViewController.h"

@interface SAGenderSelectionViewController ()
@property (weak, nonatomic) IBOutlet UIView *femaleView;
@property (weak, nonatomic) IBOutlet UIView *maleView;

@end

@implementation SAGenderSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //set margin and border to buttons
    self.femaleView.layer.borderColor = [UIColor colorWithRed:50/255.0 green:226/255.0 blue:196/255.0 alpha:1.0].CGColor;
    self.femaleView.layer.borderWidth = 2.0;
    self.femaleView.layer.cornerRadius = 8.0;
    self.maleView.layer.borderColor = [UIColor colorWithRed:50/255.0 green:226/255.0 blue:196/255.0 alpha:1.0].CGColor;
    self.maleView.layer.borderWidth = 2.0;
    self.maleView.layer.cornerRadius = 8.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)genderSelected:(UIButton *)sender {
    [self.user setGender:sender.currentTitle];
    
    [self performSegueWithIdentifier:@"goToPhoneNumberSignUpView" sender:sender];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    SAFirstProfileViewController *destination = segue.destinationViewController;
    
    destination.user = self.user;
}


@end
