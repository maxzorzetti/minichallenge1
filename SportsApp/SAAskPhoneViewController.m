//
//  SAAskPhoneViewController.m
//  SportsApp
//
//  Created by Laura Corssac on 04/05/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "SAAskPhoneViewController.h"


@interface SAAskPhoneViewController ()
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;

@property NSString *telephoneNumber;

@end

@implementation SAAskPhoneViewController



- (IBAction)completed:(UIButton *)sender {
    
    
    

    printf("%s", __PRETTY_FUNCTION__);
    _telephoneNumber = _phoneNumber.text;
    
    _telephoneNumber = @"999999999999";
    
    if (_telephoneNumber ==nil || [_telephoneNumber length] < 8 )
        
        
    _infoLabel.text = @"Invalid Telephone! Try Again";
    
    else
    {
        CKContainer *container = [CKContainer defaultContainer];
        CKDatabase *publicDatabase = [container publicCloudDatabase];
        
        
        
        
        _personRecord[@"phone"] = _telephoneNumber;
    [publicDatabase saveRecord:_personRecord  completionHandler:^(CKRecord *artworkRecord, NSError *error){
        if (error) {
            NSLog(@"Telephone not registered. Error: %@", error.description);
        }
        else
        {
            NSLog(@"telephone registered");
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                
                 [self performSegueWithIdentifier:@"toBarbaraSegue" sender:self];
            });
            
           
        
        }
    }];
    
    }
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _phoneNumber.userInteractionEnabled = YES;
    // Do any additional setup after loading the view.
    printf("%s", __PRETTY_FUNCTION__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    
    
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
