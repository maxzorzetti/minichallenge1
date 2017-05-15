//
//  SANewEvent7ViewController.m
//  SportsApp
//
//  Created by Max Zorzetti on 12/05/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "SAMatchMakerCore.h"
#import "SAMatchmaker.h"
#import "SANewEvent7ViewController.h"
@class SAEvent;

@interface SANewEvent7ViewController ()

@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) BOOL foundLocation;

@property (nonatomic) long fakeSearchTime;

@property (nonatomic) SAEvent *event;

@property (nonatomic) NSDate *startTime;

@property (weak, nonatomic) IBOutlet UIView *rectangleView;

@end

@implementation SANewEvent7ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.rectangleView.layer.cornerRadius = 3.6;
	self.rectangleView.layer.masksToBounds = YES;
	self.rectangleView.layer.borderWidth = 0;
	
	
	self.startTime = [NSDate new];
	self.fakeSearchTime = 3;
	self.foundLocation = NO;
	
	// Discover the party's location
	[self configurePartyLocation];
	// Enter matchmaking when the location is set (check didUpdateLocations)
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configurePartyLocation {
	
	switch ([CLLocationManager authorizationStatus]) {
		case kCLAuthorizationStatusAuthorizedAlways:
		case kCLAuthorizationStatusAuthorizedWhenInUse:
			
			[self configureLocationManager];
			[self.locationManager requestLocation];
			break;
			
		case kCLAuthorizationStatusNotDetermined:
			
			[self.locationManager requestWhenInUseAuthorization];
			break;
			
		default:
			// Handle something
			break;
	}
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
	
	if (!self.foundLocation) {
		self.foundLocation = YES;
		// Selecting the most recent location
		CLLocation *currentLocation = locations[locations.count - 1];
		
		// Set it as the party location
		self.party.location = currentLocation;
		
		// Enter matchmaking
		[self enterMatchmaking];
	}
}

- (void)enterMatchmaking {
	
	[SAMatchmaker enterMatchmakingWithParty:self.party handler:^(SAEvent * _Nullable event, NSError * _Nullable error) {
		
		// Wait 3 seconds before showing next screen
		dispatch_after(
		   dispatch_time(DISPATCH_TIME_NOW, self.fakeSearchTime * NSEC_PER_SEC),
		   dispatch_get_main_queue(),
		   ^{
			   // Go back to main thread
			   dispatch_async(dispatch_get_main_queue(), ^{
				   
				   self.event = event;
				   
				   [self performSegueWithIdentifier:@"backToEventListWithEvent" sender:self];
				   
			   });
			   
		   });
		
	}];
}

- (void)configureLocationManager {
	self.locationManager = [[CLLocationManager alloc] init];
	self.locationManager.delegate = self;
	self.locationManager.distanceFilter = 1000;
	self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	NSLog(@"%@", error);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
