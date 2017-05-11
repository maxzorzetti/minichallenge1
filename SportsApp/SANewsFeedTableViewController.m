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

@property NSMutableArray *facebookIdOfFriends;
@property NSArray<SAPerson *> *friends;
@property NSMutableArray *arrayOfSectionsWithEvents;

@end


@implementation SANewsFeedTableViewController
//make sure when location updates event methods are called once
static dispatch_once_t predicate;



- (void)viewDidDisappear:(BOOL)animated{
    [self.locationManager stopUpdatingLocation];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrayOfSectionsWithEvents = [NSMutableArray new];
    self.facebookIdOfFriends = [NSMutableArray new];
    
    NSData *userData = [[NSUserDefaults standardUserDefaults] dataForKey:@"user"];
    self.currentUser = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    
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
                        }
                    }];
                }
            }
        }];
    }
    
    
    
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

#pragma mark - Table view data source

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
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SANewsFeedTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    NSComparisonResult result = [cell.cellEvent.date compare:[NSDate date]];
    
    if([cell.cellEvent.participants count] >= [cell.cellEvent.minPeople integerValue] || result == NSOrderedAscending){
        [self performSegueWithIdentifier:@"closedEventSegue" sender:cell];
    }else{
        [self performSegueWithIdentifier:@"mySegue" sender:cell];
    }
}
    
    


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(SANewsFeedTableViewCell *)sender{
	
    
    
    if ([segue.identifier isEqualToString: @"mySegue"]) {
		
		SAEventDescriptionViewController *destView = segue.destinationViewController;
		destView.currentEvent= sender.cellEvent;
    }else{
        ClosedEventDescriptionViewController *destView = segue.destinationViewController;
        destView.event = sender.cellEvent;
    }
}

- (IBAction)backFromDescription:(UIStoryboardSegue *)segue{
    
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
    
    [self.currentUser setLocation:[sortedArray firstObject]];
    
    
    //once location is set, fetch events based on location from db
    
    //make sure event fetch are called once
    dispatch_once(&predicate, ^{
        //FETCH EVENTS FOR TODAY SECTION
        [SAEventConnector getComingEventsBasedOnFavoriteActivities:self.currentUser.interests AndCurrentLocation:self.currentUser.location AndRadiusOfDistanceDesiredInMeters:1000000 handler:^(NSArray<SAEvent *> * _Nullable events, NSError * _Nullable error) {
            if(!error){
                NSDictionary *myDic = @{
                                        @"section" : @"TODAY",
                                        @"events" : events
                                        };
                
                [self.arrayOfSectionsWithEvents addObject:myDic];
            }
            [self updateTableView];
        }];
        
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
        }];
    });
    
    
    
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    if (error) {
        NSLog(@"Error when fetching location: %@", error.description);
    }
}

@end
