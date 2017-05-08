//
//  SAAskPhoneViewController.m
//  SportsApp
//
//  Created by Laura Corssac on 04/05/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "SAAskPhoneViewController.h"
#import "SAInterestsNavigationController.h"
#import "SAInterestsCollectionViewController.h"

@interface SAAskPhoneViewController ()
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;

@property NSString *telephoneNumber;

@end

@implementation SAAskPhoneViewController



- (IBAction)completed:(UIButton *)sender {
    
    
    

    printf("%s", __PRETTY_FUNCTION__);
    _telephoneNumber = _phoneNumber.text;
    
    //_telephoneNumber = @"999999999999";
    
    if (_telephoneNumber ==nil || [_telephoneNumber length] < 8 )
        
        
    _infoLabel.text = @"Invalid Telephone! Try Again";
    
    else
    {
        CKContainer *container = [CKContainer defaultContainer];
        CKDatabase *publicDatabase = [container publicCloudDatabase];
        
        //_personRecord[@"phone"] = _telephoneNumber;
        NSLog(@"%@", _personRecord[@"email"]);
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"email = %@", _personRecord[@"email"]];
        CKQuery *query = [[CKQuery alloc] initWithRecordType:@"SAPerson" predicate:predicate];
        
        
        [publicDatabase performQuery:query inZoneWithID:nil completionHandler:^(NSArray *results, NSError *error) {
            if (error) {
                NSLog(@"error: %@",error.localizedDescription);
            }
            else {
    
                    [results firstObject][@"telephone"] = _telephoneNumber;
                    
                    [publicDatabase saveRecord:[results firstObject]  completionHandler:^(CKRecord *artworkRecord, NSError *error){
                        if (error) {
                            NSLog(@"Telefone nao salvo. Error: %@", error.description);
                        }
                        else{
                            NSLog(@"Telephone salvo");
                            [self goToInterests];
                            }
                    }];
                
                
    }}];
                    
                    
        
        

                
        

//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                 [self performSegueWithIdentifier:@"toBarbaraSegue" sender:self];
//
//    
//
//            });
    }}
        

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

- (void)goToInterests{
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Secondary" bundle:nil];
    SAInterestsNavigationController *destination = [main instantiateViewControllerWithIdentifier:@"intNavController"];
    
    destination.email= _personRecord[@"email"];
    SAInterestsCollectionViewController *vai = destination.topViewController;
    vai.email = _personRecord[@"email"];
    
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:destination animated:YES completion:^{
            
        }];
    });
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    
    
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
