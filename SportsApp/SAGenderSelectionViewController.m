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
#import "SAViewController.h"

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


- (IBAction)backButtonPressed:(UIButton *)sender {
    
    if ([_previousView isEqualToString:@"profile"]){
        [self goToProfile];
        
    }
    else {
        
        [self goBackToHelloView];
    }
    
    
   
    
    
    
    
    
    

    
}



-(void)goToProfile{
    
   
    
    
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *destination = [main instantiateViewControllerWithIdentifier:@"view2"];
    [destination setSelectedViewController:[destination.viewControllers objectAtIndex:2]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:destination animated:YES completion:^{
            
        }];
    });
    
    
    
    
    
}

- (void)goBackToHelloView{
    UIStoryboard *secondary= [UIStoryboard storyboardWithName:@"Secondary" bundle:nil];
    SAViewController *helloView = [secondary instantiateViewControllerWithIdentifier:@"helloView"];
    
    
    CKContainer *container = [CKContainer defaultContainer];
    CKDatabase *publicDatabase = [container publicCloudDatabase];

    [publicDatabase deleteRecordWithID:_user.personId completionHandler:^(CKRecordID * _Nullable recordID, NSError * _Nullable error) {
        
        if (!error)
        {
            
            if (![_user.facebookId isEqualToString:@""]){
                
                FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
                [loginManager logOut];
                
                
            }
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:helloView animated:YES completion:^{
                    
                }];
            });
            
        }
        
        else{
            
            NSLog(@"%@", error.description);
        }
    }];
    
    
    
    
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
    
    if ( [self.previousView isEqualToString: @"profile"] ){
        destination.previousView = @"profile";
    }
    destination.user = self.user;
}


@end
