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
