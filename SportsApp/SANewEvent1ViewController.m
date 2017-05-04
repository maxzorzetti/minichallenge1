//
//  SANewEvent1ViewController.m
//  SportsApp
//
//  Created by Max Zorzetti on 27/04/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "SANewEvent1ViewController.h"
#import "SANewEvent2ViewController.h"
#import "SAActivityConnector.h"
#import "SAActivity.h"
#import "SAActivityCollectionViewCell.h"
#import "SACollectionButtonViewCell.h"

@interface SANewEvent1ViewController ()

@property (nonatomic) NSArray<SAActivity *> *activities;

@property (nonatomic) NSIndexPath *selectedActivityIndexPath;
@property (nonatomic, readonly) SAActivity *selectedActivity;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UICollectionView *activitiesCollectionView;

@end

@implementation SANewEvent1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	[self.navigationController setNavigationBarHidden:YES animated:NO];
	[self.navigationController setToolbarHidden:YES animated:NO];
	
	self.activitiesCollectionView.dataSource = self;
	self.activitiesCollectionView.delegate = self;
	[self.activitiesCollectionView registerNib:[UINib nibWithNibName:@"SACollectionButtonViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
	
	NSMutableArray *arrayOfActivities = [[NSUserDefaults standardUserDefaults] mutableArrayValueForKey:@"ArrayOfDictionariesContainingTheActivities"];
	NSMutableArray<SAActivity *> *activities = [NSMutableArray new];
	for (NSDictionary *activityDic in arrayOfActivities) {
		SAActivity *activity = [NSKeyedUnarchiver unarchiveObjectWithData:activityDic[@"activityData"]];
		NSLog(@"ACTIVITY %@", activity);
		[activities addObject: activity];
	}
	
	[activities sortUsingComparator:^NSComparisonResult(SAActivity*  _Nonnull obj1, SAActivity*  _Nonnull obj2) {
		return [obj1.name compare:obj2.name];
	}];
	
	self.activities = activities;
	
	self.party = [SAParty new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	SACollectionButtonViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
	
	SAActivity *activity = self.activities[indexPath.item];
	UIImage *image = [UIImage imageWithData:activity.picture];
	cell.iconImageView.image = image;//[UIImage imageWithData:activity.picture];
	cell.unselectedImage = image;//[UIImage imageWithData:activity.picture];
	cell.selectedImage = [UIImage imageWithData:activity.pictureWhite];
	
	cell.titleLabel.text = activity.name;
	
	return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	
	NSInteger numberOfItems;
	switch (section) {
		case 0: numberOfItems = self.activities.count; break;
		default: numberOfItems = 0;
	}
	return numberOfItems;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	SACollectionButtonViewCell *cell = (SACollectionButtonViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
	[cell setCustomSelection:YES];
	
	self.selectedActivityIndexPath = indexPath;
	self.party.activity = self.activities[indexPath.item];
	
	[self performSegueWithIdentifier:@"newEvent1To2" sender:self];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
	
	SACollectionButtonViewCell *cell = (SACollectionButtonViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
	[cell setCustomSelection:NO];
	
	self.party.activity = nil;
	self.selectedActivityIndexPath = nil;
}

- (void)updateNextButton {
	self.nextButton.enabled = self.party.activity != nil;
}

+ (UIColor *)preferenceColor {
	return [UIColor colorWithRed:119/255.0 green:90/255.0 blue:218/255.0 alpha:1];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"newEvent1To2"]) {
		SANewEvent2ViewController *newEvent2 = segue.destinationViewController;
		//newEvent2.selectedActivity = self.selectedActivity;
		newEvent2.party = [self.party copy];
	}
}

- (IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
	[self.activitiesCollectionView deselectItemAtIndexPath:self.selectedActivityIndexPath animated:NO];
	SACollectionButtonViewCell *cell = (SACollectionButtonViewCell *)[self.activitiesCollectionView cellForItemAtIndexPath:self.selectedActivityIndexPath];
	[cell setCustomSelection:NO];
}

//
//- (NSMutableAttributedString *)processPreferencesTextWithActivity:(SAActivity *)activity schedule:(NSString *)schedule people:(NSString *)people location:(NSString *)location {
//	NSMutableString *rawText;
//
//	if (location) {
//		rawText = [[NSMutableString alloc] initWithString:@"I want to <activity> <schedule> with <people> at <location>!"];
//	} else if (people) {
//		rawText = [[NSMutableString alloc] initWithString:@"I want to <activity> <schedule> with <people> at..."];
//	} else if (schedule) {
//		rawText = [[NSMutableString alloc] initWithString:@"I want to <activity> <schedule> with..."];
//	} else if (activity) {
//		rawText = [[NSMutableString alloc] initWithString:@"I want to <activity>..."];
//	}
//
//
//	NSRange selectedActivityRange;
//	NSRange selectedScheduleRange;
//	NSRange selectedPeopleTypeRange;
//	NSRange selectedLocationRange;
//
//	if (activity) {
//
//		[rawText replaceOccurrencesOfString:@"<activity>" withString:activity.name options:NSLiteralSearch range:NSMakeRange(0, rawText.length)];
//		selectedActivityRange = [rawText rangeOfString:activity.name];
//
//	} else if (schedule) {
//
//		[rawText replaceOccurrencesOfString:@"<schedule>" withString:schedule options:NSLiteralSearch range:NSMakeRange(0, rawText.length)];
//		selectedScheduleRange = [rawText rangeOfString:schedule];
//
//	} else if (people) {
//
//		[rawText replaceOccurrencesOfString:@"<people>" withString:people options:NSLiteralSearch range:NSMakeRange(0, rawText.length)];
//		selectedPeopleTypeRange = [rawText rangeOfString:people];
//
//	} else if (location) {
//
//		[rawText replaceOccurrencesOfString:@"<people>" withString:people options:NSLiteralSearch range:NSMakeRange(0, rawText.length)];
//		selectedLocationRange = [rawText rangeOfString:location];
//
//	}
//
//	// Update text (we do this so we don't lose the text's attributes)
//	self.preferencesTextView.text = rawText;
//
//	// Paint preferences
//	UIColor *preferenceColor = [[UIColor alloc] initWithRed:202/255.0 green:32/255.0 blue:41/255.0 alpha:1];
//	NSDictionary *attrs = @{ NSForegroundColorAttributeName : preferenceColor };
//	NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.preferencesTextView.attributedText];
//	[attributedText addAttributes:attrs range:selectedActivityRange];
//	[attributedText addAttributes:attrs range:selectedScheduleRange];
//	[attributedText addAttributes:attrs range:selectedPeopleTypeRange];
//
//	// Finally, place the completely processed text in the text view
//	self.preferencesTextView.attributedText = attributedText;
//
//}

@end
