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
#import "SASectionView2.h"

@interface SAEventListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableWithEvents;
@property NSArray *currentArray;


@property NSArray *dicListOfComingEvents, *dicListOfPastEvents;

@end

@implementation SAEventListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableWithEvents.tableHeaderView = nil;
    // Do any additional setup after loading the view.
    _currentArray = [NSArray new];
    
    self.tableWithEvents.delegate = self;
    self.tableWithEvents.dataSource = self;
    
    //TODO get from User defaults instead
    CKRecordID *personId = [[CKRecordID alloc]initWithRecordName:@"35D1ADBD-53F8-4D4F-80AB-D44419A25DB0"];
    [SAEventConnector getEventsByPersonId:personId handler:^(NSArray<SAEvent *> * _Nullable events, NSError * _Nullable error) {
        if (!error) {
            //self.arrayOfComingUpEvents = [NSMutableArray arrayWithArray:events];
            self.dicListOfComingEvents = [self sortEventsIntoMonthlySections:events];
            [self updateTableWithEventList:self.dicListOfComingEvents];
        }
    }];
    [SAEventConnector getPastEventsByPersonId:personId handler:^(NSArray * _Nullable events, NSError * _Nullable error) {
        if(!error){
            //self.arrayOfPastEvents = [NSMutableArray arrayWithArray:events];
            self.dicListOfPastEvents = [self sortEventsIntoMonthlySections:events];
        }
    }];
}

- (NSArray *)sortEventsIntoMonthlySections:(NSArray<SAEvent *>*)events{
    NSMutableArray *arrayOfDic = [NSMutableArray new];
    
    for (SAEvent *event in events) {
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:event.date];
        NSNumber *month = [NSNumber numberWithInteger:[components month]];
        int wasSmthAdded = 0;
        
        for (int i=0; i<arrayOfDic.count; i++) {
            NSDictionary *section = arrayOfDic[i];
            if ([section[@"month"] isEqualToNumber:month]){
                wasSmthAdded = 1;
                NSMutableArray *eventsOfSection = section[@"events"];
                [eventsOfSection addObject:event];
                NSDictionary *replacingDictionary = @{
                                             @"month" : section[@"month"],
                                             @"events" : eventsOfSection
                                             };
                [arrayOfDic removeObjectAtIndex:i];
                [arrayOfDic insertObject:replacingDictionary atIndex:i];
            }
        }
        if (wasSmthAdded==0) {
            NSMutableArray *eventsOfNewSection = [NSMutableArray arrayWithObject:event];
            NSDictionary *newSection = @{
                                         @"month" : month,
                                         @"events" : eventsOfNewSection
                                         };
            [arrayOfDic addObject:newSection];
        }
    }
    return arrayOfDic;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SANewsFeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    NSDictionary *dict = self.currentArray[indexPath.section];
    NSArray *arrayOfEvents = dict[@"events"];
    
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"SACustomCell" bundle:nil] forCellReuseIdentifier:@"myCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    }
    [cell initWithEvent:arrayOfEvents[indexPath.row]];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary *dict = self.currentArray[section];
    NSArray *arrayOfEvents = dict[@"events"];
    
    return [arrayOfEvents count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSDictionary *dict = self.currentArray[section];
    NSNumber *month = dict[@"month"];
    
    NSString *CellIdentifier = @"myHeader2";
    
    SASectionView2  *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:CellIdentifier];
    
        
    [tableView registerNib:[UINib nibWithNibName:@"SASectionView2" bundle:nil] forHeaderFooterViewReuseIdentifier:CellIdentifier];
    headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"myHeader2"];
    NSString *text = [self monthFromNumber:month];
    headerView.sectionTitle.text = text;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.currentArray.count;
}

-(NSString *)monthFromNumber:(NSNumber *)month{
    switch ([month intValue]) {
        case 1:
            return @"JANUARY";
            break;
        case 2:
            return @"FEBRUARY";
            break;
        case 3:
            return @"MARCH";
            break;
        case 4:
            return @"APRIL";
            break;
        case 5:
            return @"MAY";
            break;
        case 6:
            return @"JUNE";
            break;
        case 7:
            return @"JULY";
            break;
        case 8:
            return @"AUGUST";
            break;
        case 9:
            return @"SEPTEMBER";
            break;
        case 10:
            return @"OCTOBER";
            break;
        case 11:
            return @"NOVEMBER";
            break;
        case 12:
            return @"DEZEMBER";
            break;
            
        default:
            return @"EVENTS";
            break;
    }
}

- (IBAction)changeSegment:(UISegmentedControl *)sender {
    if(sender.selectedSegmentIndex==0){
        [self updateTableWithEventList:self.dicListOfComingEvents];
    }else{
        [self updateTableWithEventList:self.dicListOfPastEvents];
    }
}

- (void)updateTableWithEventList:(NSArray<SAEvent *>*)events{
    self.currentArray = events;
    
    [self.tableWithEvents reloadData];
}




@end
