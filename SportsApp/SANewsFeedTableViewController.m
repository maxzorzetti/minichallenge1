//
//  SANewsFeedTableViewController.m
//  SportsApp
//
//  Created by Laura Corssac on 27/04/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "SANewsFeedTableViewController.h"
#import "SAEvent.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "SANewsFeedTableViewCell.h"
#import <CloudKit/CloudKit.h>

#import "SAPersonConnector.h"
#import "SAPerson.h"
#import "SAEventConnector.h"
#import "SAActivity.h"
#import "SASectionView2.h"


@interface SANewsFeedTableViewController ()
@property NSMutableArray *eventArray;
@property (weak, nonatomic) IBOutlet UITableView *tableWithEvents;
@property CKRecordID *userRecordID;

@end


@implementation SANewsFeedTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    CKContainer *container = [CKContainer defaultContainer];
//    
//    [container fetchUserRecordIDWithCompletionHandler:^(CKRecordID * _Nullable recordID, NSError * _Nullable error) {
//        if (!error){
//            _userRecordID = recordID;
//        }
//            
//            }];
  

    
    _eventArray = [[NSMutableArray alloc]init];
    
    CKRecordID *personId = [[CKRecordID alloc]initWithRecordName:@"35D1ADBD-53F8-4D4F-80AB-D44419A25DB0"];
    
    [SAEventConnector getEventsByPersonId:personId handler:^(NSArray<SAEvent *> * _Nullable events, NSError * _Nullable error) {
        if (!error) {
            [self updateTableWithEventList:events];
        }
    }];
    
    
    //SAEvent *event = [[SAEvent alloc]init];
    //SAPerson *person = [[SAPerson alloc]init];
    //SAActivity *act = [[SAActivity alloc]initWithName:@"Futebol" minimumPeople:0 maximumPeople:0 picture:nil AndActivityId:nil];
    //act.name = ;
    //person.name = @"Pablo Diego José Francisco de Paula Juan Nepomuceno María de los Remedios Cipriano de la Santísima Trinidad Ruiz y Picasso";
    //person.facebookId = @"957060131063735";
    //event.name = @"Evento Pakas do Pablo Diego José Francisco de Paula Juan Nepomuceno María de los Remedios Cipriano de la Santísima Trinidad Ruiz y Picasso";
    //event.date = [NSDate date];
    //event.owner = person;
    //event.activity= act;
    //[_eventArray addObject:event];
    
    
//    NSMutableArray *friendList = [[NSMutableArray alloc] init];
//    
//    if ( [FBSDKAccessToken currentAccessToken]) {
//        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
//                                      initWithGraphPath:@"/me"
//                                      parameters:@{ @"fields": @"name, picture, friends",}
//                                      HTTPMethod:@"GET"];
//        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
//            
//            if ([error.userInfo[FBSDKGraphRequestErrorGraphErrorCode] isEqual:@200]) {
//                NSLog(@"permission error");
//            }
//            else
//            {
//                CKContainer *container = [CKContainer defaultContainer];
//                CKDatabase *publicDatabase = [container publicCloudDatabase];
//                
//                for (id person in [[result objectForKey:@"friends"]objectForKey:@"data"] )
//                {
//                    NSString *userID = [person objectForKey:@"id"];
//                        [friendList addObject:userID];
//  
//                }
//                
//                [SAPersonConnector getPeopleFromFacebookIds:friendList handler:^(NSArray<SAPerson *> * _Nullable results, NSError * _Nullable error) {
//                    if (!error)
//                    {
//                        CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:-30.033285 longitude:-51.213884];
//                        
//                      [SAEventConnector getSugestedEventsWithActivities:nil AndCurrentLocation:currentLocation andDistanceInMeters:1000000 AndFriends:results handler:^(NSArray<SAEvent *> * _Nullable events, NSError * _Nullable error) {
//                          
//                          
//                          if(!error)
//                          {
//                              for (SAEvent *event in events) {
//                                  NSLog(@"eventos = %@", event.name);
//                              }
//                              [self updateTableWithEventList:events];
//                              
//                          }else{
//                              NSLog(@"tome: %@", error.description);
//                          }
//                          }
//                      ];
//                        
//                    }
//                }];
//               NSLog(@" na moral funfa vai friend list = %@",  friendList);
//                
//            }
//        }];
//    }
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger numberOfEvents = _eventArray.count;
    return numberOfEvents;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SANewsFeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    
    
    
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"SACustomCell" bundle:nil] forCellReuseIdentifier:@"myCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    }
    [cell initWithEvent:self.eventArray[indexPath.row]];
    //cell.cellEvent = self.eventArray[indexPath.row];
    //cell.ownerName.text = @"vamooooooooo";
    
   
    return cell;
}

- (void)updateTableWithEventList:(NSArray<SAEvent *>*)events{
    [self.eventArray addObjectsFromArray:events];
    
    [self.tableWithEvents reloadData];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    static NSString *CellIdentifier = @"myHeader2";
 
    SASectionView2  *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:CellIdentifier];
    
    if (headerView == nil){
        //[NSException raise:@"headerView == nil.." format:@"No cells with matching CellIdentifier loaded from your storyboard"];
       // static NSString * const SectionHeaderViewIdentifier = ;
        
         [tableView registerNib:[UINib nibWithNibName:@"SASectionView2" bundle:nil] forHeaderFooterViewReuseIdentifier:@"myHeader2"];
        headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"myHeader2"];
    
    }
    //UILabel *label = (UILabel *)[headerView viewWithTag:123];
    //[label setText:@"Friends"];
    return headerView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return @"";
}



-(void) viewWillAppear:(BOOL)animated {
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}
/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
