//
//  SANewEvent4ViewController.m
//  SportsApp
//
//  Created by Max Zorzetti on 27/04/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "SANewEvent1ViewController.h"
#import "SANewEvent4ViewController.h"
#import "SANewEvent5ViewController.h"

@interface SANewEvent4ViewController ()

@property (weak, nonatomic) IBOutlet UITextView *preferencesTextView;

@property (weak, nonatomic) IBOutlet UISlider *locationRadiusSlider;

@property (weak, nonatomic) IBOutlet UILabel *locationRadiusLabel;

@property (weak, nonatomic) IBOutlet UITableView *locationsTableView;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (nonatomic) CLLocationManager *locationManager;

@end

@implementation SANewEvent4ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //CHECK IF USER HAS ALLOWED LOCATION SERVICES, IF YES REQUEST USER'S CURRENT LOCATION
    switch ([CLLocationManager authorizationStatus]) {
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            self.locationManager = [[CLLocationManager alloc]init];
            [self startStandartUpdates];
            
            //THIS METHOD MAKES THE LOCATION MANAGER GET THE LOCATION, ONCE IT GETS THE LOCATION IT WILL CALL THE LOCATION didUpdateLocations METHOD DOWN DOWN BELOW
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
    
    
    
    
	
	//self.locationRadiusSlider.value
	self.locationRadiusLabel.text = [[NSString alloc] initWithFormat:@"%.0f km", self.locationRadiusSlider.value];
	
	self.locationRadiusSlider.value = (self.locationRadiusSlider.minimumValue + self.locationRadiusSlider.maximumValue)/2;
	[self processPreferencesTextView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)locationRadiusChanged:(UISlider *)sender {
	self.locationRadiusLabel.text = [[NSString alloc] initWithFormat:@"%.0f km", sender.value];
}

- (void)processPreferencesTextView {
	// Insert preferences in the text
	NSMutableString *rawText = [[NSMutableString alloc] initWithString:self.preferencesTextView.text];
	[rawText replaceOccurrencesOfString:@"<activity>" withString: [[NSString alloc] initWithFormat:@"%@ %@", self.party.activity.auxiliarVerb, self.party.activity.name.lowercaseString] options:NSLiteralSearch range:NSMakeRange(0, rawText.length)];
	[rawText replaceOccurrencesOfString:@"<schedule>" withString:self.party.schedule.lowercaseString options:NSLiteralSearch range:NSMakeRange(0, rawText.length)];
	NSString *peopleType;
	switch (self.party.peopleType) {
		case 0: peopleType = @"my friends"; break;
		case 1: peopleType = @"anyone"; break;
		default: peopleType = @"ERROR"; break;
	}
	
	[rawText replaceOccurrencesOfString:@"<people>" withString:peopleType options:NSLiteralSearch range:NSMakeRange(0, rawText.length)];

	// Get preferences indexes
	NSRange selectedActivityRange = [rawText rangeOfString:[[NSString alloc] initWithFormat:@"%@", self.party.activity.name.lowercaseString]];
	NSRange selectedScheduleRange = [rawText rangeOfString:self.party.schedule.lowercaseString];
	NSRange selectedPeopleTypeRange = [rawText rangeOfString:peopleType];
	
	// Update text (we do this so we don't lose the text's attributes)
	self.preferencesTextView.text = rawText;
	
	// Paint preferences
	UIColor *preferenceColor = [SANewEvent1ViewController preferenceColor];
	NSDictionary *attrs = @{ NSForegroundColorAttributeName : preferenceColor };
	NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.preferencesTextView.attributedText];
	[attributedText addAttributes:attrs range:selectedActivityRange];
	[attributedText addAttributes:attrs range:selectedScheduleRange];
	[attributedText addAttributes:attrs range:selectedPeopleTypeRange];
	
	// Finally, place the completely processed text in the text view
	self.preferencesTextView.attributedText = attributedText;
}



#pragma mark - Navigation


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	NSLog(@"newEvent4");
	NSLog(@"%@", segue.identifier);
	if ([segue.identifier isEqualToString: @"newEvent4To5"]) {
		SANewEvent5ViewController *newEvent5 = segue.destinationViewController;
		self.party.locationRadius = [NSNumber numberWithLong: lroundf(self.locationRadiusSlider.value)];
		
		
		newEvent5.party = [self.party copy];
	}
}

- (IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
	
}

#pragma location methods
- (void)startStandartUpdates{
    if (self.locationManager == nil) {
        self.locationManager = [[CLLocationManager alloc]init];
    }
    
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = 1000;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    
    [self.locationManager startUpdatingLocation];
}

//THIS METHOD WILL BE CALLED ONCE THE LOCATION MANAGER GET ANY LOCATION FROM THE USER DEVICE
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    //DO WHAT YOU WANT WITH THE LOCATION
    
    //EXAMPLE DOWN BELOW
    
    
//    NSArray *sortedArray;
//    
//    sortedArray = [locations sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//        CLLocation *loc1 = obj1;
//        CLLocation *loc2 = obj2;
//        
//        return [loc1.timestamp compare:loc2.timestamp];
//    }];
//    
//    
//    //make locationReadable
//    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
//    [geocoder reverseGeocodeLocation:[sortedArray firstObject] completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
//        if (!error) {
//            CLPlacemark *placemark = [placemarks objectAtIndex:0];
//            NSLog(@"Location from event4 view: %@", [NSString stringWithFormat:@"%@",placemark.locality.capitalizedString]);
//        }
//    }];
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    if (error) {
        NSLog(@"Error when fetching location: %@", error.description);
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [self.locationManager stopUpdatingLocation];
}


@end
