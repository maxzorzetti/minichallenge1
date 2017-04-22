//
//  MatchMakingViewController.m
//  SportsApp
//
//  Created by Bruno Scheltzke on 2017-04-19.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "SAMatchMakingViewController.h"
#import <CloudKit/CloudKit.h>
#import "SAParty.h"

@interface SAMatchMakingViewController ()
@property (nonatomic) NSSet *activities;

@end

@implementation SAMatchMakingViewController
CKContainer *myContainer;
CKDatabase *publicDatabase;


- (void)viewDidLoad {
    [super viewDidLoad];
    myContainer = [CKContainer defaultContainer];
    publicDatabase = [myContainer publicCloudDatabase];
    
    //Fetch activity options and populates the activity selection component
    NSPredicate *anyPredicate = [NSPredicate predicateWithValue:YES];
    CKQuery *activitiesQuery = [[CKQuery alloc]initWithRecordType:@"SAActivity" predicate:anyPredicate];
    [publicDatabase performQuery:activitiesQuery inZoneWithID:nil completionHandler:^(NSArray *results, NSError *error) {
        if (error) {
            // Error handling for failed fetch from public database
            NSLog(@"%@", error.description);
        }
        else {
            for (CKRecord *activity in results) {
                NSLog(@"%@", activity[@"name"]);
                //TODO populate the activities selection component
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)startMatchMaking:(UIButton *)sender {
    
    SAParty *myParty = [[SAParty alloc]initWithPeople:nil maxParticipants:nil AndminParticipants:nil];
    //send this party information to a webservermethod that returns whether it was attached to another party or made an event out of it
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
