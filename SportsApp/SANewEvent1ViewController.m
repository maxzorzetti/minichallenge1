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
	
	self.activitiesCollectionView.dataSource = self;
	self.activitiesCollectionView.delegate = self;
	
	self.activitiesCollectionView.allowsSelection = YES;
	
    SAActivity *futebas = [[SAActivity alloc]initWithName:@"Futebas" minimumPeople:14 maximumPeople:16 picture:nil AndActivityId:nil];
	SAActivity *volei = [[SAActivity alloc]initWithName:@"Volei" minimumPeople:14 maximumPeople:16 picture:nil AndActivityId:nil];
	SAActivity *tenis = [[SAActivity alloc]initWithName:@"Tenis" minimumPeople:14 maximumPeople:16 picture:nil AndActivityId:nil];
	SAActivity *golf = [[SAActivity alloc]initWithName:@"Golf" minimumPeople:14 maximumPeople:16 picture:nil AndActivityId:nil];
	SAActivity *basquete = [[SAActivity alloc]initWithName:@"Basquete" minimumPeople:14 maximumPeople:16 picture:nil AndActivityId:nil];
	
	self.activities = @[futebas, volei, tenis, golf, basquete, futebas, volei, tenis, basquete, futebas, futebas, futebas, futebas, futebas, futebas, futebas, futebas, futebas, futebas, futebas, futebas];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	SAActivityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"buttonCell" forIndexPath:indexPath];
	[cell configureWithActivity: self.activities[indexPath.item]];
	cell.name.text = self.activities[indexPath.item].name;
	
	NSLog(@"%s", __PRETTY_FUNCTION__);
	//if (self.selectedActivityIndexPath != nil && [indexPath compare:self.selectedActivityIndexPath] == NSOrderedSame) {
	if (cell.selected) {
		//cell.backgroundColor = [UIColor redColor];
		//cell.icon.layer.borderColor = [[UIColor redColor] CGColor];
		//cell.icon.layer.borderWidth = 4.0;
	} else {
		//cell.icon.layer.borderColor = nil;
		//cell.icon.layer.borderWidth = 0.0;
	}
	
	
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
	NSLog(@"%s", __PRETTY_FUNCTION__);
	
	self.selectedActivityIndexPath = indexPath;
	[collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
	
	[self performSegueWithIdentifier:@"newEvent1To2" sender:self];
	
	SAActivityCollectionViewCell *cell = (SAActivityCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
	
	
	//NSMutableArray *indexPaths = [[NSMutableArray alloc] initWithObjects: indexPath, nil];
	
//	if (self.selectedActivityIndexPath) {
//
//		if ([self.selectedActivityIndexPath isEqual:indexPath]) {
//			self.selectedActivityIndexPath = nil;
//		} else {
//			[indexPaths addObject:self.selectedActivityIndexPath];
//			self.selectedActivityIndexPath = indexPath;
//		}
//
//	} else self.selectedActivityIndexPath = indexPath;
	
	//[collectionView reloadItemsAtIndexPaths:indexPaths];
	
	NSLog(@"%@ SELECTED", self.selectedActivityIndexPath);
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
	
	[collectionView deselectItemAtIndexPath:indexPath animated:YES];
	self.selectedActivityIndexPath = nil;

	SAActivityCollectionViewCell *cell = (SAActivityCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
	
	[UIView animateWithDuration:1 animations:^{
		cell.layer.borderColor = [[UIColor clearColor] CGColor];
		//cell.layer.borderWidth = 0.0;
	}];
	
	NSLog(@"%@ UNSELECTED", self.selectedActivityIndexPath);
	//[collectionView reloadItemsAtIndexPaths:@[indexPath]];
}

- (void)setSelectedActivityIndexPath:(NSIndexPath *)selectedActivityIndexPath {
	_selectedActivityIndexPath = selectedActivityIndexPath;
	if (selectedActivityIndexPath == nil) _selectedActivity = nil;
	else _selectedActivity = self.activities[selectedActivityIndexPath.item];
	
	self.nextButton.enabled = selectedActivityIndexPath != nil;
}

+ (UIColor *)preferenceColor {
	return [UIColor colorWithRed:119/255.0 green:90/255.0 blue:218/255.0 alpha:1];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	
	if ([segue.identifier isEqualToString:@"newEvent1To2"]) {
		SANewEvent2ViewController *newEvent2 = segue.destinationViewController;
		newEvent2.selectedActivity = self.selectedActivity;
	}
	
}

- (IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
	[self.activitiesCollectionView deselectItemAtIndexPath:self.selectedActivityIndexPath animated:YES];
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
