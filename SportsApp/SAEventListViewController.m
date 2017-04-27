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
    
    
    //UGLIEST CODE JUST TO TEST THO, CHILL MAN
    [SAActivityConnector getAllActivities:^(NSArray * _Nullable activities, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error.description);
        } else {
            for (SAActivity *activity in activities) {
                NSLog(@"%@", activity.name);
                
                [SAEventConnector getEventsByActivity:activity handler:^(NSArray * _Nullable events, NSError * _Nullable error) {
                    if (error) {
                        NSLog(@"%@", error.description);
                    } else {
                        NSMutableArray *eventList = [NSMutableArray new];
                        for (SAEvent *event in events) {
                            //NSLog(@"Events from activities: %@", event.name);
                            
                            [SAEventConnector getEventById:event.eventId handler:^(SAEvent * _Nullable eventFromid, NSError * _Nullable error) {
                                if (error) {
                                    NSLog(@"%@", error.description);
                                } else {
                                    NSLog(@"ERA PRA DAR CERTO POU: %@", eventFromid.name);
                                    [eventList addObject:eventFromid];
                                }
                            }];
                        }
                        
                        [self updateTableWithEventList:eventList];
                    }
                }];
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *customCell = [tableView dequeueReusableCellWithIdentifier:@""];
    
    
    return customCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.arrayOfEvents count];
}

- (void)updateTableWithEventList:(NSArray<SAEvent *>*)events{
    [self.arrayOfEvents addObjectsFromArray:events];
    NSLog(@"CHEGOU AQUI PELO MENOS");
    
    for (SAEvent *event in self.arrayOfEvents) {
        NSLog(@"CARALHO CUZAO DEU CERTO!!!!");
    }
    
    //[self.tableWithEvents reloadData];
}




@end
