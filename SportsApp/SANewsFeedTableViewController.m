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
#import "SAEventDescriptionViewController.h"


@interface SANewsFeedTableViewController ()
@property NSMutableArray *eventArray;
@property NSMutableArray *todayEvents;
@property NSMutableArray *lastArray;
@property (weak, nonatomic) IBOutlet UITableView *tableWithEvents;
@property CKRecordID *userRecordID;
@property int section;

@end


@implementation SANewsFeedTableViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTranslucent:NO];

    printf("%s", __PRETTY_FUNCTION__);
//    CKContainer *container = [CKContainer defaultContainer];
////    
//    [container fetchUserRecordIDWithCompletionHandler:^(CKRecordID * _Nullable recordID, NSError * _Nullable error) {
//        if (!error){
//            _userRecordID = recordID;
//        }
//        else
//            NSLog(@"SEU ERRO == %@", error.description);
////            
//           }];
  

    _lastArray = [[NSMutableArray alloc]init];
    _todayEvents = [[NSMutableArray alloc]init];
    _eventArray = [[NSMutableArray alloc]init];
    
    CKRecordID *personId = [[CKRecordID alloc]initWithRecordName:@"BB905180-6C9D-41F0-B2FA-25D7F65F5B81"];
    
    [SAEventConnector getEventsByPersonId:personId handler:^(NSArray<SAEvent *> * _Nullable events, NSError * _Nullable error) {
        if (!error) {
            [self updateTableWithEventList:events];
        }
    }];
    
    
    SAEvent *eventPakas = [[SAEvent alloc]init];
    SAPerson *person = [[SAPerson alloc]init];
    SAActivity *act = [[SAActivity alloc]initWithName:@"Futebol" minimumPeople:0 maximumPeople:0 picture:nil AndActivityId:nil];
    //act.name = ;
    person.name = @"Pablo Diego José Francisco de Paula Juan Nepomuceno María de los Remedios Cipriano de la Santísima Trinidad Ruiz y Picasso";
    person.facebookId = @"957060131063735";
    eventPakas.name = @"Evento Pakas do Pablo Diego José Francisco de Paula Juan Nepomuceno María de los Remedios Cipriano de la Santísima Trinidad Ruiz y Picasso";
    eventPakas.date = [NSDate date];
    eventPakas.owner = person;
    eventPakas.activity= act;
    //[_eventArray addObject:event];
    
    
    NSMutableArray *friendList = [[NSMutableArray alloc] init];
//    
    if ( [FBSDKAccessToken currentAccessToken]) {
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                      initWithGraphPath:@"/me"
                                      parameters:@{ @"fields": @"friends",}
                                    HTTPMethod:@"GET"];
            [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
//            
            if (error) {
                NSLog(@"ERRO = %@", error.description);
            }
            else
           {
                CKContainer *container = [CKContainer defaultContainer];
                CKDatabase *publicDatabase = [container publicCloudDatabase];
               
                for (id person in [[result objectForKey:@"friends"]objectForKey:@"data"] )
                {
                    NSString *userID = [person objectForKey:@"id"];
                        [friendList addObject:userID];
  
                }
                
                [SAPersonConnector getPeopleFromFacebookIds:friendList handler:^(NSArray<SAPerson *> * _Nullable results, NSError * _Nullable error) {
                    if (!error)
                    {
                        CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:-30.033285 longitude:-51.213884];
//                        
                      [SAEventConnector getSugestedEventsWithActivities:nil AndCurrentLocation:currentLocation andDistanceInMeters:1000000 AndFriends:results handler:^(NSArray<SAEvent *> * _Nullable events, NSError * _Nullable error) {
//                          
//                          
                          if(!error)
                          {
                              for (SAEvent *event in events) {
                                  NSLog(@"eventos = %@", event.name);
                              }
                              
                              
                              
                              //[_friendsEvents addObject:eventPakas];
                              [self updateTableWithEventList:events];
//                              
                          }else{
                              NSLog(@"tome: %@", error.description);
                          }
                          }
                      ];
                        
                    }
                }];
              NSLog(@" na moral funfa vai friend list = %@",  friendList);
               
           }
        }];
    }
    
    
    
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

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    
    NSInteger numberOfEvents = 0;
    //if (section ==0) {
        
        numberOfEvents = _eventArray.count;
    //}
    //if (section==1) {
        //numberOfEvents = _friendsEvents.count;
    //}
    return numberOfEvents;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    printf("%s SECTION = %ld ROW = %ld\n", __PRETTY_FUNCTION__, (long)indexPath.section, (long)indexPath.row);
    
    SANewsFeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    
    
    
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"SACustomCell" bundle:nil] forCellReuseIdentifier:@"myCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    }
    
    //if (indexPath.section == 0)
        [cell initWithEvent:self.eventArray[indexPath.row]];
    //if (indexPath.section ==1 ){
        //[cell initWithEvent:self.friendsEvents[_section]];
       // _section ++;
        
    //}
    
    //cell.cellEvent = self.eventArray[indexPath.row];
    //cell.ownerName.text = @"vamooooooooo";
    
    
   
    return cell;
}

- (void)updateTableWithEventList:(NSArray<SAEvent *>*)events {
    printf("%s\n", __PRETTY_FUNCTION__);
    
    
//    NSMutableSet *set1 = [NSMutableSet setWithArray: events];
//    NSSet *set2 = [NSSet setWithArray: _lastArray];
//    
//    [set1 intersectSet: set2];
//    NSArray *resultArray = [set1 allObjects];
//    
//    
//    for (SAEvent *event in resultArray)
////        if ([events containsObject:event]) // passar pra
//            [events removeObj
//        _eventArray=[[NSMutableArray alloc]initWithArray:resultArray];
//
    _eventArray= [[NSMutableArray alloc] init];
    [_eventArray addObjectsFromArray:events];
    //[_lastArray addObjectsFromArray:events];
    
    [self.tableWithEvents reloadData];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    printf("%s", __PRETTY_FUNCTION__);
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
    
    if (section == 0)
        headerView.sectionTitle.text = @"TODAY";
    else
        if (section == 1)
            headerView.sectionTitle.text = @"FRIENDS";
    else
            headerView.sectionTitle.text = @"SUGGESTIONS";
    
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




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    SANewsFeedTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"mySegue" sender:cell];
}
    
    


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(SANewsFeedTableViewCell *)sender{
    
    SAEventDescriptionViewController *destView = segue.destinationViewController;
    destView.currentEvent= sender.cellEvent;
    
    
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
