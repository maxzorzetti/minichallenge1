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
#import "ClosedEventDescriptionViewController.h"
#import "SAPersonConnector.h"
#import "SAPerson.h"
#import "SAEventConnector.h"
#import "SAActivity.h"
#import "SASectionView2.h"
#import "SAEventDescriptionViewController.h"
#import "SAEvent.h"


@interface SANewsFeedTableViewController ()
@property NSMutableArray *eventArray;
@property NSMutableArray *todayEvents;
@property NSMutableArray *lastArray;
@property (weak, nonatomic) IBOutlet UITableView *tableWithEvents;
@property CKRecordID *userRecordID;
@property int section;
@property SAPerson *currentUser;
@property CLLocationManager *locationManager;
@property int canRefresh;
@property NSMutableArray *facebookIdOfFriends;
@property NSArray<SAPerson *> *friends;
@property NSMutableArray *arrayOfSectionsWithEvents;

@property (nonatomic, strong) id previewingContext;

@end


@implementation SANewsFeedTableViewController
//make sure when location updates event methods are called once
static dispatch_once_t predicate;
static dispatch_once_t predicateForFriends;



- (void)viewDidDisappear:(BOOL)animated{
    [self.locationManager stopUpdatingLocation];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _canRefresh = 0;
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    self.arrayOfSectionsWithEvents = [NSMutableArray new];
    self.facebookIdOfFriends = [NSMutableArray new];
    
    //check if 3d touch is available, if it is, assign current view as delegate
    if ([self isForceTouchAvailable]) {
        self.previewingContext = [self registerForPreviewingWithDelegate:self sourceView:self.tableWithEvents];
    }
    
    //adds refresh control to tableview
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(refreshTable:) forControlEvents:UIControlEventValueChanged];
    self.tableWithEvents.refreshControl = refreshControl;
    
    
    NSData *userData = [[NSUserDefaults standardUserDefaults] dataForKey:@"user"];
    self.currentUser = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    
    //create notification subscriptions
    [self createSubscriptionsForNotifications];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    
    //load FB friends
    //get fb id of friends
    if ( [FBSDKAccessToken currentAccessToken]) {
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                      initWithGraphPath:@"/me"
                                      parameters:@{ @"fields": @"friends",}
                                      HTTPMethod:@"GET"];
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            
            if (!error){
                for (id person in [[result objectForKey:@"friends"]objectForKey:@"data"] )
                {
                    NSString *userID = [person objectForKey:@"id"];
                    [self.facebookIdOfFriends addObject:userID];
                }
                
                //get people record from fb id
                if (self.facebookIdOfFriends) {
                    [SAPersonConnector getPeopleFromFacebookIds:self.facebookIdOfFriends handler:^(NSArray<SAPerson *> * _Nullable results, NSError * _Nullable error) {
                        if (!error)
                        {
                            self.friends = results;
                            //if location already set, fetch friends events
                            if (self.currentUser.location) {
                                dispatch_once(&predicateForFriends, ^{
                                    //FETCH EVENTS FOR FRIENDS SECTION
                                    [SAEventConnector getSugestedEventsWithActivities:nil AndCurrentLocation:self.currentUser.location andDistanceInMeters:1000000 AndFriends:_friends handler:^(NSArray<SAEvent *> * _Nullable events, NSError * _Nullable error) {
                                        if(!error){
                                            NSDictionary *myDic = @{
                                                                    @"section" : @"FRIENDS",
                                                                    @"events" : events
                                                                    };
                                            
                                            [self.arrayOfSectionsWithEvents addObject:myDic];
                                        }
                                        [self updateTableView];
                                        self.canRefresh = 1;
                                    }];
                                });
                            }
                        }
                    }];
                }
            }
        }];
    }
    
    //FETCH EVENTS FOR INVITED SECTION
    [SAEventConnector getEventsWhereUserIsAnInvitee:self.currentUser.personId handler:^(NSArray<SAEvent *> * _Nullable events, NSError * _Nullable error) {
        if(!error){
            NSDictionary *myDic = @{
                                    @"section" : @"INVITED",
                                    @"events" : events
                                    };
            
            [self.arrayOfSectionsWithEvents addObject:myDic];
        }
        [self updateTableView];
    }];

    //check location authorization status
    switch ([CLLocationManager authorizationStatus]) {
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            self.locationManager = [[CLLocationManager alloc]init];
            [self startStandartUpdates];
            self.currentUser.locationManager = self.locationManager;
            [self.locationManager startUpdatingLocation];
            break;
        case kCLAuthorizationStatusNotDetermined:
            self.locationManager = [[CLLocationManager alloc]init];
            [self startStandartUpdates];

            self.currentUser.locationManager = self.locationManager;
            [self.locationManager requestWhenInUseAuthorization];
            [self.locationManager requestLocation];
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}

#pragma mark - Table view population methods

- (void)refreshTable:(UIRefreshControl *)refreshControl{
    if (self.canRefresh == 1) {
        __block int finishedLoadingAllSectionsOfFeed = 0;
        
        [SAEventConnector getSugestedEventsWithActivities:nil AndCurrentLocation:self.currentUser.location andDistanceInMeters:1000000 AndFriends:self.friends handler:^(NSArray<SAEvent *> * _Nullable events, NSError * _Nullable error) {
            if(!error){
                NSDictionary *myDic = @{
                                        @"section" : @"FRIENDS",
                                        @"events" : events
                                        };
                
                [self.arrayOfSectionsWithEvents replaceObjectAtIndex:2 withObject:myDic];
                
                finishedLoadingAllSectionsOfFeed += 1;
                if (finishedLoadingAllSectionsOfFeed == 3) {
                    [refreshControl endRefreshing];
                }
            }
            [self updateTableView];
        }];
        [SAEventConnector getComingEventsBasedOnFavoriteActivities:self.currentUser.interests AndCurrentLocation:self.currentUser.location AndRadiusOfDistanceDesiredInMeters:1000000 handler:^(NSArray<SAEvent *> * _Nullable events, NSError * _Nullable error) {
            if(!error){
                NSDictionary *myDic = @{
                                        @"section" : @"TODAY",
                                        @"events" : events
                                        };
                
                [self.arrayOfSectionsWithEvents replaceObjectAtIndex:0 withObject:myDic];
                
                finishedLoadingAllSectionsOfFeed += 1;
                if (finishedLoadingAllSectionsOfFeed == 3) {
                    [refreshControl endRefreshing];
                }
            }
            [self updateTableView];
        }];
        
        [SAEventConnector getEventsWhereUserIsAnInvitee:self.currentUser.personId handler:^(NSArray<SAEvent *> * _Nullable events, NSError * _Nullable error) {
            if(!error && events){
                NSDictionary *myDic = @{
                                        @"section" : @"INVITED",
                                        @"events" : events
                                        };
                
                [self.arrayOfSectionsWithEvents replaceObjectAtIndex:1 withObject:myDic];
                
                finishedLoadingAllSectionsOfFeed += 1;
                if (finishedLoadingAllSectionsOfFeed == 3) {
                    [refreshControl endRefreshing];
                }
            }
            [self updateTableView];
        }];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return [self.arrayOfSectionsWithEvents count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *dict = self.arrayOfSectionsWithEvents[section];
    NSArray *arrayOfEvents = dict[@"events"];
    
    
    return [arrayOfEvents count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SANewsFeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    NSDictionary *dict = self.arrayOfSectionsWithEvents[indexPath.section];
    NSArray *arrayOfEvents = dict[@"events"];
    
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"SACustomCell" bundle:nil] forCellReuseIdentifier:@"myCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    }
    [cell initWithEvent:arrayOfEvents[indexPath.row]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)updateTableView{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableWithEvents reloadData];
    });
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSDictionary *dict = self.arrayOfSectionsWithEvents[section];
    
    SASectionView2  *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"myHeader2"];
    
    [tableView registerNib:[UINib nibWithNibName:@"SASectionView2" bundle:nil] forHeaderFooterViewReuseIdentifier:@"myHeader2"];
    headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"myHeader2"];
    NSString *text = dict[@"section"];
    headerView.sectionTitle.text = text;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

-(void) viewWillAppear:(BOOL)animated {
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    //update events from userdefaults
    if ([self.arrayOfSectionsWithEvents count]>2) {
        [self updateEventsWithUserDefaults];
    }
}

-(void) updateEventsWithUserDefaults{
    [self.arrayOfSectionsWithEvents replaceObjectAtIndex:0 withObject: @{
                                                                         @"section" : @"TODAY",
                                                                         @"events" : [SAEvent getEventsForTodayCategory]
                                                                         }];
    [self.arrayOfSectionsWithEvents replaceObjectAtIndex:1 withObject: @{
                                                                         @"section" : @"INIVTED",
                                                                         @"events" : [SAEvent getEventsForInvitedCategory]
                                                                         }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SANewsFeedTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
//    NSComparisonResult result = [cell.cellEvent.date compare:[NSDate date]];
//    
//    if([cell.cellEvent.participants count] >= [cell.cellEvent.minPeople integerValue] || result == NSOrderedAscending){
//        [self performSegueWithIdentifier:@"closedEventSegue" sender:cell];
//    }else{
//        [self performSegueWithIdentifier:@"mySegue" sender:cell];
//    }
    
    
    
    
    //never show view with phone number
    [self performSegueWithIdentifier:@"mySegue" sender:cell];
}
    
    


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(SANewsFeedTableViewCell *)sender{
	
    
    
//    if ([segue.identifier isEqualToString: @"mySegue"]) {
//		
//		SAEventDescriptionViewController *destView = segue.destinationViewController;
//		destView.currentEvent= sender.cellEvent;
//    }else{
//        ClosedEventDescriptionViewController *destView = segue.destinationViewController;
//        destView.event = sender.cellEvent;
//    }
    
    //never show view with phone number
    SAEventDescriptionViewController *destView = segue.destinationViewController;
    destView.currentEvent= sender.cellEvent;
}

- (IBAction)backFromDescription:(UIStoryboardSegue *)segue{
    [self updateEventsWithUserDefaults];
    dispatch_async(dispatch_get_main_queue(), ^{
       [self.tableView reloadData]; 
    });
}

#pragma location methods
- (void)startStandartUpdates{
    if (self.locationManager == nil) {
        self.locationManager = [[CLLocationManager alloc]init];
    }
    
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = 10000;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    NSArray *sortedArray;
    
    sortedArray = [locations sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        CLLocation *loc1 = obj1;
        CLLocation *loc2 = obj2;
        
        return [loc1.timestamp compare:loc2.timestamp];
    }];
    
    
    //once location is set, fetch events based on location from db
    
    //only fetch events once friends are fetched
    if (self.friends) {
        //make sure event fetch are called once
        dispatch_once(&predicateForFriends, ^{
            //FETCH EVENTS FOR FRIENDS SECTION
            [SAEventConnector getSugestedEventsWithActivities:nil AndCurrentLocation:[sortedArray firstObject] andDistanceInMeters:1000000 AndFriends:_friends handler:^(NSArray<SAEvent *> * _Nullable events, NSError * _Nullable error) {
                if(!error){
                    NSDictionary *myDic = @{
                                            @"section" : @"FRIENDS",
                                            @"events" : events
                                            };
                    
                    [self.arrayOfSectionsWithEvents addObject:myDic];
                }
                [self updateTableView];
            }];

        });
    }
    //make sure event fetch are called once
    dispatch_once(&predicate, ^{
        //FETCH EVENTS FOR TODAY SECTION
        [SAEventConnector getComingEventsBasedOnFavoriteActivities:self.currentUser.interests AndCurrentLocation:[sortedArray firstObject] AndRadiusOfDistanceDesiredInMeters:1000000 handler:^(NSArray<SAEvent *> * _Nullable events, NSError * _Nullable error) {
            if(!error){
                NSDictionary *myDic = @{
                                        @"section" : @"TODAY",
                                        @"events" : events
                                        };
                
                [self.arrayOfSectionsWithEvents addObject:myDic];
            }
            [self updateTableView];
        }];
    });
    
    [self.currentUser setLocation:[sortedArray firstObject]];
    
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    if (error) {
        NSLog(@"Error when fetching location: %@", error.description);
    }
}


#pragma force touch methods
- (BOOL)isForceTouchAvailable {
    BOOL isForceTouchAvailable = NO;
    if ([self.traitCollection respondsToSelector:@selector(forceTouchCapability)]) {
        isForceTouchAvailable = self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable;
    }
    return isForceTouchAvailable;
}

- (UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location{
    // check if we're not already displaying a preview controller (WebViewController is my preview controller)
    //    if ([self.presentedViewController isKindOfClass:[WebViewController class]]) {
    //        return nil;
    //    }
    
    NSIndexPath *path = [self.tableWithEvents indexPathForRowAtPoint:location];
    
    if (path) {
        SANewsFeedTableViewCell *cell = [self.tableWithEvents cellForRowAtIndexPath:path];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        
        //check for what peek view to show
        /*NSComparisonResult result = [cell.cellEvent.date compare:[NSDate date]];
        if([cell.cellEvent.participants count] >= [cell.cellEvent.minPeople integerValue] || result == NSOrderedAscending){
            //event closed, show closed event description
            ClosedEventDescriptionViewController *previewController = [storyboard instantiateViewControllerWithIdentifier:@"eventFull"];
            
            previewController.event = cell.cellEvent;
            
            previewingContext.sourceRect = cell.frame;
            
            return previewController;
        }else{*/
            //event open, show open event description
            SAEventDescriptionViewController *previewController = [storyboard instantiateViewControllerWithIdentifier:@"eventDescription"];
            
            previewController.currentEvent = cell.cellEvent;
            
            previewingContext.sourceRect = cell.frame;
            
            return previewController;
        //}
    }
    return nil;
}

- (void)previewingContext:(id )previewingContext commitViewController: (UIViewController *)viewControllerToCommit {
    
    // if you want to present the selected view controller as it self us this:
    // [self presentViewController:viewControllerToCommit animated:YES completion:nil];
    
    // to render it with a navigation controller (more common) you should use this:
    [self.navigationController showViewController:viewControllerToCommit sender:nil];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    if ([self isForceTouchAvailable]) {
        if (!self.previewingContext) {
            self.previewingContext = [self registerForPreviewingWithDelegate:self sourceView:self.view];
        }
    } else {
        if (self.previewingContext) {
            [self unregisterForPreviewingWithContext:self.previewingContext];
            self.previewingContext = nil;
        }
    }
}

#pragma notification methods
-(void)createSubscriptionsForNotifications{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //checks if user already has a subscription of events for invited section
    //[userDefaults setBool:YES forKey:@"hasSubscriptionForEventForInvitedSection"];
    if (![userDefaults boolForKey:@"hasSubscriptionForEventForInvitedSection"]) {
        CKReference *userRef = [[CKReference alloc]initWithRecordID:self.currentUser.personId action:CKReferenceActionNone];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%@ IN inviteesNotConfirmed", userRef];
        //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"minPeople >0"];
        CKSubscription *subscription = [[CKSubscription alloc]initWithRecordType:@"Event" predicate:predicate options:CKSubscriptionOptionsFiresOnRecordCreation | CKSubscriptionOptionsFiresOnRecordUpdate];
        
        CKNotificationInfo *notificationInfo  = [CKNotificationInfo new];
        notificationInfo.alertBody = @"Some of your friends added you in an event!";
        notificationInfo.shouldBadge = YES;
        notificationInfo.category = @"userInvitedToEvent";
        //notificationInfo.desiredKeys = [NSArray arrayWithObjects: @"recordType", nil];
        subscription.notificationInfo = notificationInfo;
        
        //saves the subscription to the database
        CKDatabase *publicDatabase = [[CKContainer defaultContainer] publicCloudDatabase];
        [publicDatabase saveSubscription:subscription completionHandler:^(CKSubscription * _Nullable subscription, NSError * _Nullable error) {
            if (!error) {
                //subscription created, let user defaults know :)
                [userDefaults setBool:YES forKey:@"hasSubscriptionForEventForInvitedSection"];
                [userDefaults synchronize];
            }
        }];
    }
    
    
    //cheks if user already has a subscription for when invitees of user's event has confirmed
    if (![userDefaults boolForKey:@"hasSubscriptionForInviteeHasJoinedEvent"]) {
        CKReference *userRef = [[CKReference alloc]initWithRecordID:self.currentUser.personId action:CKReferenceActionNone];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"owner = %@", userRef];
        CKSubscription *subscription = [[CKSubscription alloc]initWithRecordType:@"Event" predicate:predicate options: CKSubscriptionOptionsFiresOnRecordUpdate];
        
        CKNotificationInfo *notificationInfo  = [CKNotificationInfo new];
        notificationInfo.alertBody = @"Your event has been updated! Check it out";
        notificationInfo.shouldBadge = YES;
        notificationInfo.category = @"eventUpdated";
        //notificationInfo.desiredKeys = [NSArray arrayWithObjects: @"recordType", nil];
        subscription.notificationInfo = notificationInfo;
        
        //saves the subscription to the database
        CKDatabase *publicDatabase = [[CKContainer defaultContainer] publicCloudDatabase];
        [publicDatabase saveSubscription:subscription completionHandler:^(CKSubscription * _Nullable subscription, NSError * _Nullable error) {
            if (!error) {
                //subscription created, let user defaults know :)
                [userDefaults setBool:YES forKey:@"hasSubscriptionForInviteeHasJoinedEvent"];
                [userDefaults synchronize];
            }
        }];
    }
    
}



@end
