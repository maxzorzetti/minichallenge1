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
#import "SANewsFeedTableViewCell.h"
#import "SAEventsTableViewCell.h"
#import "SASectionView2.h"
#import "SAUser.h"
#import "SAPerson.h"
#import "SAEventDescriptionViewController.h"
#import "ClosedEventDescriptionViewController.h"
#import "SANewEvent6ViewController.h"

@interface SAEventListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableWithEvents;
@property NSArray *currentArray;

@property (nonatomic, strong) id previewingContext;

@property NSArray *dicListOfComingEvents, *dicListOfPastEvents;
@property CLLocationManager *locationManager;
@property (nonatomic) SAPerson *user;

@property (nonatomic) SAEvent *tempEvent;

@end

@implementation SAEventListViewController

- (void)viewWillAppear:(BOOL)animated{
    //only try to update from userdefaults once events from cloudkit were already fetched
    if (self.dicListOfComingEvents) {
        
        NSMutableArray *alreadyFetchedEvents = [NSMutableArray new];
        

        //if segment control is selected with the coming up section
        if (self.segmentControl.selectedSegmentIndex == 1) {
            //get all events fetched from cloudkit
            for (NSDictionary *dictionaryOfSectionsContainingComingUpEvents in self.dicListOfComingEvents) {
                [alreadyFetchedEvents addObjectsFromArray:dictionaryOfSectionsContainingComingUpEvents[@"events"]];
            }
            
            NSArray *comingUpEventsInDefaults = [SAEvent getEventsFromComingUpCategory];
            
            //if there are more events in defaults than the ones fetched
            if ([comingUpEventsInDefaults count] != [alreadyFetchedEvents count]) {
                alreadyFetchedEvents = [NSMutableArray arrayWithArray:comingUpEventsInDefaults];
                
                //sort array into monthly section
                NSArray *arrayOfEventsSeparatedInSectionToUpdate = [self sortEventsIntoMonthlySections:alreadyFetchedEvents];
                
                //replace global array
                self.dicListOfComingEvents = arrayOfEventsSeparatedInSectionToUpdate;
                
                [self updateTableWithEventList:self.dicListOfComingEvents];
            }
        }else{
            //get all events fetched from cloudkit for past category
            for (NSDictionary *dictionaryOfSectionsContainingPastEvents in self.dicListOfPastEvents) {
                [alreadyFetchedEvents addObjectsFromArray:dictionaryOfSectionsContainingPastEvents[@"events"]];
            }
            
            NSArray *pastEventsInUserDefaults   = [SAEvent getEventsForPastCategory];
            
            //if there are more events in defaults than the ones fetched
            if ([pastEventsInUserDefaults count] != [alreadyFetchedEvents count]) {
                alreadyFetchedEvents = [NSMutableArray arrayWithArray:pastEventsInUserDefaults];
                
                //sort array into monthly section
                NSArray *arrayOfEventsSeparatedInSectionToUpdate = [self sortEventsIntoMonthlySections:alreadyFetchedEvents];
                
                //replace global array
                self.dicListOfPastEvents = arrayOfEventsSeparatedInSectionToUpdate;
                
                [self updateTableWithEventList:self.dicListOfPastEvents];
            }
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSData *userData = [[NSUserDefaults standardUserDefaults] dataForKey:@"user"];
    self.user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    
    //check if 3d touch is available, if it is, assign current view as delegate
    if ([self isForceTouchAvailable]) {
        self.previewingContext = [self registerForPreviewingWithDelegate:self sourceView:self.tableWithEvents];
    }
    
    //adds refresh control to tableview
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(refreshTable:) forControlEvents:UIControlEventValueChanged];
    self.tableWithEvents.refreshControl = refreshControl;
    
    
    self.tableWithEvents.tableHeaderView = nil;
    _currentArray = [NSArray new];
    
    self.tableWithEvents.delegate = self;
    self.tableWithEvents.dataSource = self;
    
    CKRecordID *personId = self.user.personId;
    [SAEventConnector getEventsByPersonId:personId handler:^(NSArray<SAEvent *> * _Nullable events, NSError * _Nullable error) {
        if (!error) {
            events = [events sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                SAEvent *event1 = obj1;
                SAEvent *event2 = obj2;
                
                if (event1.date < event2.date) {
                    return (NSComparisonResult)NSOrderedAscending;
                }else if(event1.date > event2.date){
                    return (NSComparisonResult)NSOrderedDescending;
                }
                return (NSComparisonResult)NSOrderedSame;
            }];
            
            self.dicListOfComingEvents = [self sortEventsIntoMonthlySections:events];
            [self updateTableWithEventList:self.dicListOfComingEvents];
        }
    }];
    [SAEventConnector getPastEventsByPersonId:personId handler:^(NSArray * _Nullable events, NSError * _Nullable error) {
        if(!error){
            events = [events sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                SAEvent *event1 = obj1;
                SAEvent *event2 = obj2;
                
                if (event1.date < event2.date) {
                    return (NSComparisonResult)NSOrderedAscending;
                }else if(event1.date > event2.date){
                    return (NSComparisonResult)NSOrderedDescending;
                }
                return (NSComparisonResult)NSOrderedSame;
            }];
            self.dicListOfPastEvents = [self sortEventsIntoMonthlySections:events];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	// Gamby (TM) to transition to event screens after we created an event
	if (self.tempEvent) {
		
		if ( self.tempEvent.participants.count >= self.tempEvent.minPeople.integerValue ) {

			[self performSegueWithIdentifier:@"descriptionNotClosedEventSegue" sender:self];
			
		} else {
			
			[self performSegueWithIdentifier:@"descriptionNotClosedEventSegue" sender:self];
		}
	}
}

#pragma Table population methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SANewsFeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    NSDictionary *dict = self.currentArray[indexPath.section];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary *dict = self.currentArray[section];
    NSArray *arrayOfEvents = dict[@"events"];
    
    return [arrayOfEvents count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSDictionary *dict = self.currentArray[section];
    NSNumber *month = dict[@"month"];
    
    NSString *CellIdentifier = @"myHeader2";
    
    SASectionView2  *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:CellIdentifier];
    
    
    [tableView registerNib:[UINib nibWithNibName:@"SASectionView2" bundle:nil] forHeaderFooterViewReuseIdentifier:CellIdentifier];
    headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"myHeader2"];
    NSString *text = [self monthFromNumber:month];
    headerView.sectionTitle.text = text;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([self.currentArray count] == 0) {
        //say that there are no events :((((
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableWithEvents.bounds.size.width, self.tableWithEvents.bounds.size.height)];
        
        //messageLabel.text = @"You have no events in this section, how about creating new ones? :)";
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont systemFontOfSize:20];
        [messageLabel sizeToFit];
        
        self.tableWithEvents.backgroundView = messageLabel;
        self.tableWithEvents.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    
    
    return self.currentArray.count;
}




#pragma segue perfoming methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SANewsFeedTableViewCell *cell = [self.tableWithEvents cellForRowAtIndexPath:indexPath];
    
    NSComparisonResult result = [cell.cellEvent.date compare:[NSDate date]];
    
    if([cell.cellEvent.participants count] >= [cell.cellEvent.minPeople integerValue] || result == NSOrderedAscending){
        [self performSegueWithIdentifier:@"descriptionNotClosedEventSegue" sender:cell];
    }else{
        [self performSegueWithIdentifier:@"descriptionNotClosedEventSegue" sender:cell];
    }
}

- (IBAction)backFromNewEvent:(UIStoryboardSegue *)sender {
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	
}

- (IBAction)backWithNewEvent:(UIStoryboardSegue *)segue {
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	
	SANewEvent6ViewController *vc = segue.sourceViewController;
	SAEvent *event = vc.event;
	
	self.tempEvent = event;
	
//	if (event.participants.count >= event.minPeople.integerValue) {
//		NSLog(@"Closed Event");
//		self.eventSegue = @"descriptionEventSegue";
//		//[self performSegueWithIdentifier:@"startNewEvent" sender:self];
//		
//	} else {
//		NSLog(@"Not Closed Event");
//		self.eventSegue = @"descriptionNotClosedEventSegue";
//		[self performSegueWithIdentifier:@"descriptionNotClosedEventSegue" sender:self];
//		
//	}
	
	
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSObject *)sender {
	
	// Test to see if we are going into an event screen
	if ([segue.identifier isEqualToString:@"descriptionEventSegue"] || [segue.identifier isEqualToString:@"descriptionNotClosedEventSegue"]) {
		SAEvent *event;
		// See if we are going because we tapped an event cell
		if (sender.class == SANewsFeedTableViewCell.class) {
			event = ((SANewsFeedTableViewCell *)sender).cellEvent;
			
		// See if we are going because we created a new event
		} else if (sender.class == self.class) {
			event = ((SAEventListViewController *)sender).tempEvent;
			self.tempEvent = nil;	// Set the event to nil so ViewDidAppear doesn't screw up everything
		}
		
		// Go to the appropriate event screen depending on the event
		if ([segue.identifier isEqualToString:@"descriptionEventSegue"]) {
			ClosedEventDescriptionViewController *destView = segue.destinationViewController;
			destView.event = event;
		} else if ([segue.identifier isEqualToString:@"descriptionNotClosedEventSegue"]) {
			SAEventDescriptionViewController *destView = segue.destinationViewController;
			destView.currentEvent = event;
		}
		
	} else if ([segue.identifier isEqualToString:@"startNewEvent"]) {
		// :)
	}
}

- (IBAction)backFromDescription:(UIStoryboardSegue *)segue{
    
}


#pragma section methods
- (NSArray *)sortEventsIntoMonthlySections:(NSArray<SAEvent *>*)events{
    NSMutableArray *arrayOfDic = [NSMutableArray new];
    
    for (SAEvent *event in events) {
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:event.date];
        NSNumber *month = [NSNumber numberWithInteger:[components month]];
        int wasSmthAdded = 0;
        
        for (int i=0; i<arrayOfDic.count; i++) {
            NSDictionary *section = arrayOfDic[i];
            if ([section[@"month"] isEqualToNumber:month]){
                wasSmthAdded = 1;
                NSMutableArray *eventsOfSection = section[@"events"];
                [eventsOfSection addObject:event];
                NSDictionary *replacingDictionary = @{
                                                      @"month" : section[@"month"],
                                                      @"events" : eventsOfSection
                                                      };
                [arrayOfDic removeObjectAtIndex:i];
                [arrayOfDic insertObject:replacingDictionary atIndex:i];
            }
        }
        if (wasSmthAdded==0) {
            NSMutableArray *eventsOfNewSection = [NSMutableArray arrayWithObject:event];
            NSDictionary *newSection = @{
                                         @"month" : month,
                                         @"events" : eventsOfNewSection
                                         };
            [arrayOfDic addObject:newSection];
        }
    }
    return arrayOfDic;
}

-(NSString *)monthFromNumber:(NSNumber *)month{
    switch ([month intValue]) {
        case 1:
            return @"JANUARY";
            break;
        case 2:
            return @"FEBRUARY";
            break;
        case 3:
            return @"MARCH";
            break;
        case 4:
            return @"APRIL";
            break;
        case 5:
            return @"MAY";
            break;
        case 6:
            return @"JUNE";
            break;
        case 7:
            return @"JULY";
            break;
        case 8:
            return @"AUGUST";
            break;
        case 9:
            return @"SEPTEMBER";
            break;
        case 10:
            return @"OCTOBER";
            break;
        case 11:
            return @"NOVEMBER";
            break;
        case 12:
            return @"DEZEMBER";
            break;
            
        default:
            return @"EVENTS";
            break;
    }
}

#pragma segment selection methods
- (IBAction)changeSegment:(UISegmentedControl *)sender {
    if(sender.selectedSegmentIndex==1){
        [self updateTableWithEventList:self.dicListOfComingEvents];
    }else{
        [self updateTableWithEventList:self.dicListOfPastEvents];
    }
}

- (void)updateTableWithEventList:(NSArray<SAEvent *>*)events{
    self.currentArray = events;
    
    dispatch_async(dispatch_get_main_queue(), ^{
       [self.tableWithEvents reloadData];
    });
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



- (void) refreshTable:(UIRefreshControl *)refreshControl{
    //update events of coming segment
    if (self.segmentControl.selectedSegmentIndex==1) {
        [SAEventConnector getEventsByPersonId:self.user.personId handler:^(NSArray<SAEvent *> * _Nullable events, NSError * _Nullable error) {
            if (!error) {
                events = [events sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                    SAEvent *event1 = obj1;
                    SAEvent *event2 = obj2;
                    
                    if (event1.date < event2.date) {
                        return (NSComparisonResult)NSOrderedAscending;
                    }else if(event1.date > event2.date){
                        return (NSComparisonResult)NSOrderedDescending;
                    }
                    return (NSComparisonResult)NSOrderedSame;
                }];
                
                self.dicListOfComingEvents = [self sortEventsIntoMonthlySections:events];
                [self updateTableWithEventList:self.dicListOfComingEvents];
                
                //stop refreshing
                [refreshControl endRefreshing];
                
            }else{
                //say that an error occured
                [refreshControl endRefreshing];
                UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableWithEvents.bounds.size.width, self.tableWithEvents.bounds.size.height)];
                
                messageLabel.text = @"An error occured, maybe you don't have internet connection?";
                messageLabel.textColor = [UIColor blackColor];
                messageLabel.numberOfLines = 0;
                messageLabel.textAlignment = NSTextAlignmentCenter;
                messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
                [messageLabel sizeToFit];
                
                self.tableWithEvents.backgroundView = messageLabel;
                self.tableWithEvents.separatorStyle = UITableViewCellSeparatorStyleNone;
            }
        }];
    }
    //update events of past segment
    else{
        [SAEventConnector getPastEventsByPersonId:self.user.personId handler:^(NSArray * _Nullable events, NSError * _Nullable error) {
            if(!error){
                events = [events sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                    SAEvent *event1 = obj1;
                    SAEvent *event2 = obj2;
                    
                    if (event1.date < event2.date) {
                        return (NSComparisonResult)NSOrderedAscending;
                    }else if(event1.date > event2.date){
                        return (NSComparisonResult)NSOrderedDescending;
                    }
                    return (NSComparisonResult)NSOrderedSame;
                }];
                self.dicListOfPastEvents = [self sortEventsIntoMonthlySections:events];
                [self updateTableWithEventList:self.dicListOfPastEvents];
                
                //stop refreshing
                [refreshControl endRefreshing];
            }
            else{
                [refreshControl endRefreshing];
                //say that an error occured
                [refreshControl endRefreshing];
                UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableWithEvents.bounds.size.width, self.tableWithEvents.bounds.size.height)];
                
                messageLabel.text = @"An error occured, maybe you don't have internet connection?";
                messageLabel.textColor = [UIColor blackColor];
                messageLabel.numberOfLines = 0;
                messageLabel.textAlignment = NSTextAlignmentCenter;
                messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
                [messageLabel sizeToFit];
                
                self.tableWithEvents.backgroundView = messageLabel;
                self.tableWithEvents.separatorStyle = UITableViewCellSeparatorStyleNone;
            }
        }];
    }
    
    
}


@end
