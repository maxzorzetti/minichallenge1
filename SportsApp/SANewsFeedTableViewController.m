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
#import "SAFacebookIdDAO.h"
#import "SAPersonConnector.h"
#import "SAPerson.h"
#import "SAEventConnector.h"

@interface SANewsFeedTableViewController ()
@property NSArray<SAEvent *> *eventArray;
@property int flaaag;

@end


@implementation SANewsFeedTableViewController
/*
- (void)userFriendsFacebookIds:(NSString *)userFacebookId callback:(ConverteArrayCallback) callback {
    NSMutableArray *coordinates = [[NSMutableArray alloc] initWithCapacity:0];
    SAFacebookIdDAO *faceIdDAO = [[SAFacebookIdDAO alloc] init];
    [faceIdDAO userFriendsFacebookIdsHandler:^(NSArray * _Nullable activities, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error.description);
            handler(nil, error);
        }else{
            NSMutableArray *arrayOfActivities = [NSMutableArray new];
            for (CKRecord *activity in activities) {
                SAActivity *activityFromRecord = [self activityFromRecord:activity];
                [arrayOfActivities addObject:activityFromRecord];
            }
            handler(arrayOfActivities, nil);
        }
    }];

}*/

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *friendList = [[NSMutableArray alloc] init];
    
    if ( [FBSDKAccessToken currentAccessToken]) {
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                      initWithGraphPath:@"/me"
                                      parameters:@{ @"fields": @"name, picture, friends",}
                                      HTTPMethod:@"GET"];
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            
            if ([error.userInfo[FBSDKGraphRequestErrorGraphErrorCode] isEqual:@200]) {
                NSLog(@"permission error");
            }
            else
            {
                CKContainer *container = [CKContainer defaultContainer];
                CKDatabase *publicDatabase = [container publicCloudDatabase];
                
                for (id person in [[result objectForKey:@"friends"]objectForKey:@"data"] )
                {
                    _flaaag = 0;
                    
                    NSString *userID = [person objectForKey:@"id"];
                    
                   // NSPredicate *predicate = [NSPredicate predicateWithFormat:@"facebookId = %@", userID];
                   // CKQuery *query = [[CKQuery alloc] initWithRecordType:@"SAPerson" predicate:predicate];
                    
                   /*
                    [publicDatabase performQuery:query inZoneWithID:nil completionHandler:^(NSArray*results, NSError *error) {
                        if (error) {
                            NSLog(@"error: %@",error.localizedDescription);
                        }
                        else {
                            
                            if (results.count != 0 )
                                [friendList addObject:userID];
                            else
                                NSLog(@"man not in the app");
                        }}];
                    
                    if (_flaaag)*/
                        [friendList addObject:userID];
                    
                    
                    
                    
                }
                
                [SAPersonConnector getPeopleFromFacebookIds:friendList handler:^(NSArray<SAPerson *> * _Nullable results, NSError * _Nullable error) {
                    if (!error)
                    {
                        CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:-30.033285 longitude:-51.213884];
                        
                      [SAEventConnector getSugestedEventsWithActivities:nil AndCurrentLocation:currentLocation andDistanceInMeters:100 AndFriends:results handler:^(NSArray<SAEvent *> * _Nullable events, NSError * _Nullable error) {
                          
                          
                          if(!error)
                          {
                              for (SAEvent *event in events) {
                                  NSLog(@"eventos = %@", event.name);
                              }
                              
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
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger numberOfEvents = _eventArray.count;
    return numberOfEvents;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    SANewsFeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    [cell initWithEvent:_eventArray[indexPath.row]];
    
    
    return cell;
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
