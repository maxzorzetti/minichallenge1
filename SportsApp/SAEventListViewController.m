//
//  SAEventListViewController.m
//  SportsApp
//
//  Created by Bruno Scheltzke on 27/04/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "SAEventListViewController.h"
#import "SAEvent.h"
#import "SAEventConnector.h"
#import "SAActivityConnector.h"
#import "SAActivity.h"
#import <CloudKit/CloudKit.h>
#import "SANewsFeedTableViewCell.h"
#import "SAEventsTableViewCell.h"

@interface SAEventListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableWithEvents;
@property (atomic) NSMutableArray *arrayOfEvents;

@end

@implementation SAEventListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _arrayOfEvents = [NSMutableArray new];
    
    self.tableWithEvents.delegate = self;
    self.tableWithEvents.dataSource = self;
    
    //TODO get from User defaults instead
    CKRecordID *personId = [[CKRecordID alloc]initWithRecordName:@"35D1ADBD-53F8-4D4F-80AB-D44419A25DB0"];
    [SAEventConnector getEventsByPersonId:personId handler:^(NSArray<SAEvent *> * _Nullable events, NSError * _Nullable error) {
        if (!error) {
            [self updateTableWithEventList:events];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SANewsFeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];

    
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"SACustomCell" bundle:nil] forCellReuseIdentifier:@"myCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    }
    [cell initWithEvent:self.arrayOfEvents[indexPath.row]];
    
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.arrayOfEvents count];
}

- (void)updateTableWithEventList:(NSArray<SAEvent *>*)events{
    [self.arrayOfEvents addObjectsFromArray:events];
    
    [self.tableWithEvents reloadData];
}




@end
