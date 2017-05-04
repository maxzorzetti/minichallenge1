//
//  ClosedEventDescriptionViewController.m
//  SportsApp
//
//  Created by Bruno Scheltzke on 03/05/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "ClosedEventDescriptionViewController.h"
#import "SAClosedEventDescriptionTableViewCell.h"
#import "SAPersonConnector.h"
#import <UIKit/UIKit.h>
#import "SAEvent.h"
#import "SAActivity.h"
#import "SAPerson.h"

@interface ClosedEventDescriptionViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableViewWithParticipants;
@property NSMutableArray *arrayOfParticipants;

@end

@implementation ClosedEventDescriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _arrayOfParticipants = [NSMutableArray arrayWithArray:self.event.participants.allObjects];
    
    __block NSMutableArray *arrayToUpdate = [NSMutableArray new];
    for (SAPerson *person in self.arrayOfParticipants) {
        //if participant info is incomplete
        if ([person.name length] == 0) {
            
            
            //check if participant info is in userdefaults
            int isPersonInDefaults = 0;
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSArray *arrayOfDic = [userDefaults arrayForKey:@"ArrayOfDictionariesContainingPeople"];
            for (NSDictionary *dicPerson in arrayOfDic) {
                NSString *personInUDRecordName = dicPerson[@"personId"];
                if ([person.personId.recordName isEqualToString:personInUDRecordName]) {
                    NSData *personData = dicPerson[@"personData"];
                    SAPerson *personToAdd = [NSKeyedUnarchiver unarchiveObjectWithData:personData];
                    
                    [arrayToUpdate addObject:personToAdd];
                    isPersonInDefaults = 1;
                }
            }
            
            //participant not in userdefaults
            if (isPersonInDefaults == 0) {
                [SAPersonConnector getPersonFromId:person.personId handler:^(SAPerson * _Nullable personFetched, NSError * _Nullable error) {
                    if (!error && personFetched) {
                        [arrayToUpdate addObject:personFetched];
                        //once all participantss info are complete update table view
                        if ([arrayToUpdate count] == [self.arrayOfParticipants count]) {
                            [self updateTableViewWithParticipants:arrayToUpdate];
                        }
                    }else{
                        [arrayToUpdate addObject:person];
                        //once all participantss info are complete update table view
                        if ([arrayToUpdate count] == [self.arrayOfParticipants count]) {
                            [self updateTableViewWithParticipants:arrayToUpdate];
                        }
                    }
                }];
            }
        }
        //participant info was already complete, just add to array
        else{
            [arrayToUpdate addObject:person];
        }
        
        //once all participantss info are complete update table view
        if ([arrayToUpdate count] == [self.arrayOfParticipants count]) {
            [self updateTableViewWithParticipants:arrayToUpdate];
        }
        
    }
    
    
    self.tableViewWithParticipants.delegate = self;
    self.tableViewWithParticipants.dataSource = self;
    
    self.toBorderView.layer.borderColor = [UIColor colorWithRed:119/255.0 green:90/255.0 blue:218/255.0 alpha:1.0].CGColor;
    self.toBorderView.layer.borderWidth = 1.0;
    self.toBorderView.layer.cornerRadius = 8.0;
    self.eventName.text = self.event.name;
    self.activityIcon.image = [UIImage imageWithData:self.event.activity.picture];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void) viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
}

- (void)updateTableViewWithParticipants:(NSArray<SAPerson *>*)participants{
    [self.event replaceParticipants:participants];
    self.arrayOfParticipants = [NSMutableArray arrayWithArray:participants];

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableViewWithParticipants reloadData];
    });
}

#pragma tableViewPopulation methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SAClosedEventDescriptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"descriptionClosedEventCell"];
    
    cell.participant = self.arrayOfParticipants[indexPath.row];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.arrayOfParticipants count];
}

@end
