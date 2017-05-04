//
//  SANewEvent5ViewController.m
//  SportsApp
//
//  Created by Max Zorzetti on 02/05/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "SACollectionButtonViewCell.h"
#import "SANewEvent1ViewController.h"
#import "SANewEvent5ViewController.h"
#import "SANewEvent6ViewController.h"
#import <NMRangeSlider.h>

@interface SANewEvent5ViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *genderCollectionView;

@property (weak, nonatomic) IBOutlet UITextView *preferencesTextView;

@property (weak, nonatomic) IBOutlet UITextField *eventNameTextField;

@property (weak, nonatomic) IBOutlet NMRangeSlider *capacitySlider;
//@property NMRangeSlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *minimumCapacityLabel;

@property (weak, nonatomic) IBOutlet UILabel *maximumCapacityLabel;

@end

@implementation SANewEvent5ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

	self.genderCollectionView.dataSource = self;
	self.genderCollectionView.delegate = self;
	
	NSLog(@"MAXIMUMPEOPLE %d", self.party.activity.maximumPeople);
	
	self.capacitySlider.stepValueContinuously = YES;
	self.capacitySlider.stepValue = 1;
	self.capacitySlider.minimumValue = 1;
	self.capacitySlider.lowerValue = 1;
	self.capacitySlider.maximumValue = 10;
	self.capacitySlider.upperValue = 10;
	
	self.capacitySlider.tintColor = [UIColor colorWithRed:50/255.0 green:226/255.0 blue:196/255.0 alpha:1];
	
	self.capacitySlider.minimumRange = 1;
	

	[self.genderCollectionView registerNib:[UINib nibWithNibName:@"SACollectionButtonViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
	
	
	[self processPreferencesTextView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sliderChanged:(NMRangeSlider *)sender {
	self.minimumCapacityLabel.text = [NSNumber numberWithFloat: sender.lowerValue].stringValue;
	self.maximumCapacityLabel.text = [NSNumber numberWithFloat: sender.upperValue].stringValue;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	SACollectionButtonViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
	
	switch (indexPath.item) {
		case 0:
			cell.titleLabel.text = @"Female";
			cell.unselectedImage = [UIImage imageNamed:@"Icon_Female"];
			cell.selectedImage = [UIImage imageNamed:@"Icon_Female_W"];
			cell.iconImageView.image = cell.unselectedImage;
			break;
		case 1:
			cell.titleLabel.text = @"Male";
			cell.unselectedImage = [UIImage imageNamed:@"Icon_Male"];
			cell.selectedImage = [UIImage imageNamed:@"Icon_Male_W"];
			cell.iconImageView.image = cell.unselectedImage;
			break;
		case 2:
			cell.titleLabel.text = @"Mixed";
			cell.unselectedImage = [UIImage imageNamed:@"Icon_Mixed"];
			cell.selectedImage = [UIImage imageNamed:@"Icon_Mixed_W"];
			cell.iconImageView.image = cell.unselectedImage;
	}


	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.item) {
		case 0:	self.party.gender = SAFemaleGender; break;
		case 1: self.party.gender = SAMaleGender; break;
		case 2: self.party.gender = SAMixedGender; break;
	}
	
	SACollectionButtonViewCell *cell = (SACollectionButtonViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
	[cell setCustomSelection:YES];
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
	self.party.gender = SANoGender;
	SACollectionButtonViewCell *cell = (SACollectionButtonViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
	[cell setCustomSelection:NO];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	NSInteger numberOfItems;
	switch (section) {
		case 0: numberOfItems = 3; break;
		default: numberOfItems = 0;	break;
	}
	return numberOfItems;
}


- (void)processPreferencesTextView {
	// Insert preferences in the text
	NSMutableString *rawText = [[NSMutableString alloc] initWithString:self.preferencesTextView.text];
	[rawText replaceOccurrencesOfString:@"<activity>" withString: [[NSString alloc] initWithFormat:@"play %@", self.party.activity.name.lowercaseString] options:NSLiteralSearch range:NSMakeRange(0, rawText.length)];
	[rawText replaceOccurrencesOfString:@"<schedule>" withString:self.party.schedule.lowercaseString options:NSLiteralSearch range:NSMakeRange(0, rawText.length)];
	NSString *peopleType;
	switch (self.party.peopleType) {
		case 0: peopleType = @"my friends"; break;
		case 1: peopleType = @"anyone"; break;
		default: peopleType = @"ERROR"; break;
	}
	[rawText replaceOccurrencesOfString:@"<people>" withString:peopleType options:NSLiteralSearch range:NSMakeRange(0, rawText.length)];
	[rawText replaceOccurrencesOfString:@"<location>" withString: [[NSString alloc] initWithFormat:@"%@ km", self.party.locationRadius.stringValue] options:NSLiteralSearch range:NSMakeRange(0, rawText.length)];

	
	// Get preferences indexes
	NSRange selectedActivityRange = [rawText rangeOfString:[[NSString alloc] initWithFormat:@"play %@", self.party.activity.name.lowercaseString]];
	NSRange selectedScheduleRange = [rawText rangeOfString:self.party.schedule.lowercaseString];
	NSRange selectedPeopleTypeRange = [rawText rangeOfString:peopleType];
	NSRange selectedLocationRadiusRange = [rawText rangeOfString:[[NSString alloc] initWithFormat:@"%@ km", self.party.locationRadius.stringValue]];
	
	// Update text (we do this so we don't lose the text's attributes)
	self.preferencesTextView.text = rawText;
	
	// Paint preferences
	UIColor *preferenceColor = [SANewEvent1ViewController preferenceColor];
	NSDictionary *attrs = @{ NSForegroundColorAttributeName : preferenceColor };
	NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.preferencesTextView.attributedText];
	[attributedText addAttributes:attrs range:selectedActivityRange];
	[attributedText addAttributes:attrs range:selectedScheduleRange];
	[attributedText addAttributes:attrs range:selectedPeopleTypeRange];
	[attributedText addAttributes:attrs range:selectedLocationRadiusRange];

	
	// Finally, place the completely processed text in the text view
	self.preferencesTextView.attributedText = attributedText;
}

 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	 if ([segue.identifier isEqualToString:@"newEvent5To6"]) {
		 
		 self.party.eventName = self.eventNameTextField.text;
		 
		 self.party.minParticipants = self.capacitySlider.lowerValue;
		 self.party.maxParticipants = self.capacitySlider.upperValue;
		 
		 NSLog(@"%d", self.party.minParticipants);
		 
		 SANewEvent6ViewController *newEvent6 = segue.destinationViewController;
		 newEvent6.party = [self.party copy];
	 }
 }
 

@end
