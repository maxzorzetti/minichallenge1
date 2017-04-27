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


@interface SANewsFeedTableViewController ()
@property NSArray<SAEvent *> *eventArray;
@end

@implementation SANewsFeedTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
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
                //NSLog(@"fetched user:%@", result );
                //NSLog(@"Nome: %@", [result objectForKey:@"name"]);
                //_userInfo.text =[result objectForKey:@"name"];
                // NSLog(@"Facebook id: %@", [result objectForKey:@"id"]);
                //_userInfo.text = [_userInfo.text stringByAppendingString:[result objectForKey:@"id"]];
                
                NSMutableArray<SAPerson *> *friendList = [[NSMutableArray alloc] init];
                CKContainer *container = [CKContainer defaultContainer];
                CKDatabase *publicDatabase = [container publicCloudDatabase];
                
                for (id person in [[result objectForKey:@"friends"]objectForKey:@"data"] )
                {
                    
                    
                    NSString *userID = [person objectForKey:@"id"];
                    
                    
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"facebookId = %@", userID];
                    CKQuery *query = [[CKQuery alloc] initWithRecordType:@"SAPerson" predicate:predicate];
                    
                    
                    //NSLog(@"%@", person);
                    
                    
                    [publicDatabase performQuery:query inZoneWithID:nil completionHandler:^(NSArray*results, NSError *error) {
                        if (error) {
                            NSLog(@"error: %@",error.localizedDescription);
                        }
                        else {
                            
                            if (results.count != 0 )
                                [friendList addObject:[results firstObject] ];
                            //NSLog(@" meu amigo %@", [person objectForKey:@"name"]);
                            
                            
                        }}];
                    
                    
                    
                    
                }
                
                NSLog(@"freiend list = %@", friendList);
                
            }
            
            // FBSDKLoginResult.declinedPermissions
            
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
