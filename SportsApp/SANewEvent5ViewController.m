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

@end

@implementation SANewEvent5ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

	self.genderCollectionView.dataSource = self;
	self.genderCollectionView.delegate = self;

	[self.genderCollectionView registerNib:[UINib nibWithNibName:@"SACollectionButtonViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
	
	
	[self processPreferencesTextView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	NSString *genderName;
	UIImage *genderImage;
	switch (indexPath.item) {
		case 0: genderName = @"Female"; genderImage = [UIImage imageNamed:@"ic_female"];
			break;
		case 1: genderName = @"Male"; genderImage = [UIImage imageNamed:@"ic_male"];
			break;
		case 2: genderName = @"Mixed"; genderImage = [UIImage imageNamed:@"ic_mixed"];
	}
	
	SACollectionButtonViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
	
	cell.titleLabel.text = genderName;
	cell.iconImageView.image = genderImage;

	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.item) {
		case 0:	self.party.gender = SAFemaleGender; break;
		case 1: self.party.gender = SAMaleGender; break;
		case 2: self.party.gender = SAMixedGender; break;
	}
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
	//self.selectedGender = nil;
	self.party.gender = SANoGender;
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
	[rawText replaceOccurrencesOfString:@"<activity>" withString:self.party.activity.name options:NSLiteralSearch range:NSMakeRange(0, rawText.length)];
	[rawText replaceOccurrencesOfString:@"<schedule>" withString:self.party.schedule options:NSLiteralSearch range:NSMakeRange(0, rawText.length)];
	NSString *peopleType;
	switch (self.party.peopleType) {
		case 0: peopleType = @"my friends"; break;
		case 1: peopleType = @"anyone"; break;
		default: peopleType = @"ERROR"; break;
	}
	[rawText replaceOccurrencesOfString:@"<people>" withString:peopleType options:NSLiteralSearch range:NSMakeRange(0, rawText.length)];
	[rawText replaceOccurrencesOfString:@"<location>" withString:self.party.locationRadius.stringValue options:NSLiteralSearch range:NSMakeRange(0, rawText.length)];

	
	// Get preferences indexes
	NSRange selectedActivityRange = [rawText rangeOfString:self.party.activity.name];
	NSRange selectedScheduleRange = [rawText rangeOfString:self.party.schedule];
	NSRange selectedPeopleTypeRange = [rawText rangeOfString:peopleType];
	NSRange selectedLocationRadiusRange = [rawText rangeOfString:self.party.locationRadius.stringValue];
	
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
		 
		 SANewEvent6ViewController *newEvent6 = segue.destinationViewController;
		 newEvent6.party = [self.party copy];
	 }
 }
 

@end
