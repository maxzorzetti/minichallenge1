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

@interface SAEventListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableWithEvents;
@property NSArray *currentArray;

@property (nonatomic, strong) id previewingContext;

@property NSArray *dicListOfComingEvents, *dicListOfPastEvents;

@end

@implementation SAEventListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //check if 3d touch is available, if it is, assign current view as delegate
    if ([self isForceTouchAvailable]) {
        self.previewingContext = [self registerForPreviewingWithDelegate:self sourceView:self.view];
    }
    
    
    
    self.tableWithEvents.tableHeaderView = nil;
    _currentArray = [NSArray new];
    
    self.tableWithEvents.delegate = self;
    self.tableWithEvents.dataSource = self;
    
    NSData *userData = [[NSUserDefaults standardUserDefaults] dataForKey:@"user"];
    SAPerson *user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    
    CKRecordID *personId = user.personId;
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
    return self.currentArray.count;
}




#pragma segue perfoming methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SANewsFeedTableViewCell *cell = [self.tableWithEvents cellForRowAtIndexPath:indexPath];
    
    NSDate *today = [NSDate date];
    
    if([cell.cellEvent.participants count] >= [cell.cellEvent.minPeople integerValue] || [cell.cellEvent.date earlierDate:today]){
        [self performSegueWithIdentifier:@"descriptionEventSegue" sender:cell];
    }else{
        [self performSegueWithIdentifier:@"descriptionNotClosedEventSegue" sender:cell];
    }
}

- (IBAction)backFromNewEvent:(UIStoryboardSegue *)sender {
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(SANewsFeedTableViewCell *)sender{
	if ([segue.identifier isEqualToString:@"descriptionEventSegue"]) {
		if ([sender.cellEvent.participants count] >= [sender.cellEvent.minPeople integerValue] || [sender.cellEvent.date earlierDate: [NSDate date]]){
			ClosedEventDescriptionViewController *destView = segue.destinationViewController;
			destView.event = sender.cellEvent;
		}else{
			SAEventDescriptionViewController *destView = segue.destinationViewController;
			destView.currentEvent = sender.cellEvent;
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

//- (UIViewController *)previewingContext:(id )previewingContext viewControllerForLocation:(CGPoint)location{
//    // check if we're not already displaying a preview controller (WebViewController is my preview controller)
//    if ([self.presentedViewController isKindOfClass:[WebViewController class]]) {
//        return nil;
//    }
//    
//    CGPoint cellPostion = [self.tableView convertPoint:location fromView:self.view];
//    NSIndexPath *path = [self.tableView indexPathForRowAtPoint:cellPostion];
//    
//    if (path) {
//        UITableViewCell *tableCell = [self.tableView cellForRowAtIndexPath:path];
//        
//        // get your UIStoryboard
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MyStoryboard" bundle:nil];
//        
//        // set the view controller by initializing it form the storyboard
//        WebViewController *previewController = [storyboard instantiateViewControllerWithIdentifier:@"MyWebView"];
//        
//        // if you want to transport date use your custom "detailItem" function like this:
//        previewController.detailItem = [self.data objectAtIndex:path.row];
//        
//        previewingContext.sourceRect = [self.view convertRect:tableCell.frame fromView:self.tableView];
//        return previewController;
//    }
//    return nil;
//}
//
//- (void)previewingContext:(id )previewingContext commitViewController: (UIViewController *)viewControllerToCommit {
//    
//    // if you want to present the selected view controller as it self us this:
//    // [self presentViewController:viewControllerToCommit animated:YES completion:nil];
//    
//    // to render it with a navigation controller (more common) you should use this:
//    [self.navigationController showViewController:viewControllerToCommit sender:nil];
//}
//
//- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
//    [super traitCollectionDidChange:previousTraitCollection];
//    if ([self isForceTouchAvailable]) {
//        if (!self.previewingContext) {
//            self.previewingContext = [self registerForPreviewingWithDelegate:self sourceView:self.view];
//        }
//    } else {
//        if (self.previewingContext) {
//            [self unregisterForPreviewingWithContext:self.previewingContext];
//            self.previewingContext = nil;
//        }
//    }
//}


@end
