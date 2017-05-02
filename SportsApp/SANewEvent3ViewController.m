//
//  SANewEvent3ViewController.m
//  SportsApp
//
//  Created by Max Zorzetti on 27/04/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "SANewEvent1ViewController.h"
#import "SANewEvent3ViewController.h"
#import "SANewEvent4ViewController.h"
#import "SACollectionButtonViewCell.h"
@class SAPerson;

@interface SANewEvent3ViewController ()

@property (weak, nonatomic) IBOutlet UITextView *preferencesTextView;

@property (weak, nonatomic) IBOutlet UICollectionView *peopleCollectionView;

@property (weak, nonatomic) IBOutlet UITableView *friendsTableView;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (nonatomic) NSArray *peopleType;

@property (nonatomic) NSString *selectedPeopleType;
@property (nonatomic) NSSet<SAPerson *> *selectedFriends;

@end

@implementation SANewEvent3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self processPreferencesTextView];
	
	self.peopleCollectionView.dataSource = self;
	self.peopleCollectionView.delegate = self;
	
	[self.peopleCollectionView registerNib:[UINib nibWithNibName:@"SACollectionButtonViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];

	
	self.peopleType = @[@"My Friends", @"Anyone"];
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)processPreferencesTextView {
	// Insert preferences in the text
	NSMutableString *rawText = [[NSMutableString alloc] initWithString:self.preferencesTextView.text];
	[rawText replaceOccurrencesOfString:@"<activity>" withString:self.selectedActivity.name options:NSLiteralSearch range:NSMakeRange(0, rawText.length)];
	[rawText replaceOccurrencesOfString:@"<schedule>" withString:self.selectedSchedule options:NSLiteralSearch range:NSMakeRange(0, rawText.length)];
	
	// Get preferences indexes
	NSRange selectedActivityRange = [rawText rangeOfString:self.selectedActivity.name];
	NSRange selectedScheduleRange = [rawText rangeOfString:self.selectedSchedule];

	// Update text (we do this so we don't lose the text's attributes)
	self.preferencesTextView.text = rawText;
	
	// Paint preferences
	UIColor *preferenceColor = [SANewEvent1ViewController preferenceColor];
	NSDictionary *attrs = @{ NSForegroundColorAttributeName : preferenceColor };
	NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.preferencesTextView.attributedText];
	[attributedText addAttributes:attrs range:selectedActivityRange];
	[attributedText addAttributes:attrs range:selectedScheduleRange];
	
	// Finally, place the completely processed text in the text view
	self.preferencesTextView.attributedText = attributedText;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	
	NSInteger numberOfItems;
	switch (section) {
		case 0:	numberOfItems = self.peopleType.count; break;
		default: numberOfItems = 0;
	}
	return numberOfItems;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	SACollectionButtonViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
	
	cell.iconImageView.image = [UIImage imageNamed:@"ic_favorite"];
	cell.titleLabel.text = self.peopleType[indexPath.item];
	
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	
	self.selectedPeopleType = self.peopleType[indexPath.item];
	[collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
	
	self.selectedPeopleType = nil;
	[collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

- (void)setSelectedPeopleType:(NSString *)selectedPeopleType {
	_selectedPeopleType = selectedPeopleType;
	self.nextButton.enabled = selectedPeopleType != nil;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

	if ([segue.identifier isEqualToString:@"newEvent3To4"]) {
		SANewEvent4ViewController *newEvent4 = segue.destinationViewController;
		newEvent4.selectedActivity = self.selectedActivity;
		newEvent4.selectedSchedule = self.selectedSchedule;
		newEvent4.selectedPeopleType = self.selectedPeopleType;
		newEvent4.selectedFriends = self.selectedFriends;
	}
}

- (IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
	
}

@end
