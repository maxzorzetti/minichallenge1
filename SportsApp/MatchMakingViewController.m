//
//  MatchMakingViewController.m
//  SportsApp
//
//  Created by Bruno Scheltzke on 2017-04-19.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "MatchMakingViewController.h"
#import <CloudKit/CloudKit.h>

@interface MatchMakingViewController ()

@end

@implementation MatchMakingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)startMatchMaking:(UIButton *)sender {
    CKContainer *myContainer = [CKContainer defaultContainer];
    CKDatabase *publicDatabase = [myContainer publicCloudDatabase];
    
    
    
    CKRecordID *eventId = [[CKRecordID alloc]initWithRecordName:@"100"];
    
    CKRecord *eventRecord = [[CKRecord alloc] initWithRecordType:@"Event" recordID:eventId];
    
    eventRecord[@"atividade"] = @"Futebol";
    eventRecord[@"requiredNumberPerson"] = @10;
    eventRecord[@"currentNumberPerson"] = @1;
    
    
    
    [publicDatabase saveRecord:eventRecord completionHandler:^(CKRecord *eventRecord, NSError *error){
        if (error) {
            NSLog(@"!!!!!!!!!!!!!Deu erro: %@", error.description);
        }
        else{
            NSLog(@"Bombo!!!!!!!!!!!!!!!!!");
        }
    }];
    
    
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
