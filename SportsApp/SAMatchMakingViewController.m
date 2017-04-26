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
#import "SAMatchmaker.h"

@interface SAMatchMakingViewController ()
@property (nonatomic) NSSet *activities;

@end

@implementation SAMatchMakingViewController
CKContainer *myContainer;
CKDatabase *publicDatabase;


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)startMatchMaking:(UIButton *)sender {
    NSMutableSet *people;
    
    
    SAParty *myParty = [[SAParty alloc]initWithPeople:people date:[NSDate date]activity:@"Futebol Salao" maxParticipants:15 AndminParticipants:10];
    
    [SAMatchmaker enterMatchmakingWithParty:myParty];
    
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
