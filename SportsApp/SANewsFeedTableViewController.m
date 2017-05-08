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

@end


@implementation SANewsFeedTableViewController

- (void)viewDidDisappear:(BOOL)animated{
    [self.locationManager stopUpdatingLocation];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSData *userData = [[NSUserDefaults standardUserDefaults] dataForKey:@"user"];
    self.currentUser = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    
    [self.navigationController.navigationBar setTranslucent:NO];

    
    switch ([CLLocationManager authorizationStatus]) {
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            self.locationManager = [[CLLocationManager alloc]init];
            [self startStandartUpdates];
            self.currentUser.locationManager = self.locationManager;
            [self.locationManager startUpdatingLocation];
            break;
            //        case kCLAuthorizationStatusNotDetermined:
            //            self.locationManager = [[CLLocationManager alloc]init];
            //            [self startStandartUpdates];
            //
            //            self.user.locationManager = self.locationManager;
            //            [self.locationManager requestWhenInUseAuthorization];
            //            [self.locationManager requestLocation];
            //            break;
        default:
            break;
    }
    
    _lastArray = [[NSMutableArray alloc]init];
    _todayEvents = [[NSMutableArray alloc]init];
    _eventArray = [[NSMutableArray alloc]init];
    
    CKRecordID *personId = self.currentUser.personId;
    
    [SAEventConnector getEventsByPersonId:personId handler:^(NSArray<SAEvent *> * _Nullable events, NSError * _Nullable error) {
        if (!error) {
            
            NSMutableArray *aux = [[NSMutableArray alloc] init];
            for (SAEvent *event in events) {
                
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                
                NSCalendar *calendar = [NSCalendar currentCalendar];
                [dateFormat setDateFormat:@"dd/MM/yyyy"];
                NSInteger day = [calendar component:NSCalendarUnitDay fromDate:event.date];
                
                NSInteger dayToday = [calendar component:NSCalendarUnitDay fromDate:[NSDate date]];
                
                
                
                if (day == dayToday)
                    [aux addObject:event];
                    
            }
            
            
            [self updateTableWithEventList:aux];
        }
    }];
    
    
    
    NSMutableArray *friendList = [[NSMutableArray alloc] init];
    
    
    
    
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
                    else
                        NSLog(@"%@", error.description);
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
    return _eventArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SANewsFeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"SACustomCell" bundle:nil] forCellReuseIdentifier:@"myCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    }
    
    
    [cell initWithEvent:self.eventArray[indexPath.row]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)updateTableWithEventList:(NSArray<SAEvent *>*)events {
    
    _eventArray= [[NSMutableArray alloc] init];
   
    for (SAEvent *event in events)
       if (! [_lastArray containsObject:event])
          [ _eventArray addObject:event];
    
    [_lastArray addObjectsFromArray:events];
    
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
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    if (error) {
        NSLog(@"Error when fetching location: %@", error.description);
    }
}

@end
