//
//  SANewEvent2ViewController.m
//  SportsApp
//
//  Created by Max Zorzetti on 27/04/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "SANewEvent1ViewController.h"
#import "SANewEvent2ViewController.h"
#import "SANewEvent3ViewController.h"
#import "SACollectionButtonViewCell.h"

@interface SANewEvent2ViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *timetableCollectionView;

@property (weak, nonatomic) IBOutlet UITextView *preferencesTextView;

@property (nonatomic) NSArray *timetable;

@property (nonatomic) NSString *selectedSchedule;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end

@implementation SANewEvent2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.timetableCollectionView.dataSource = self;
	self.timetableCollectionView.delegate = self;
	
	[self processPreferencesTextView];
	
	[self.timetableCollectionView registerNib:[UINib nibWithNibName:@"SACollectionButtonViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];

	
	self.timetable = @[@"Tomorrow", @"Next Week", @"Next Month", @"Today", @"This Week", @"Any Day"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)processPreferencesTextView {
	// Insert the preference in the text
	NSMutableString *rawText = [[NSMutableString alloc] initWithString:self.preferencesTextView.text];
	[rawText replaceOccurrencesOfString:@"<activity>" withString:self.selectedActivity.name options:NSLiteralSearch range:NSMakeRange(0, rawText.length)];
	NSRange selectedActivityRange = [rawText rangeOfString:self.selectedActivity.name];
	self.preferencesTextView.text = rawText;
	
	// Paint the preference
	UIColor *preferenceColor = [SANewEvent1ViewController preferenceColor];

	NSDictionary *attrs = @{ NSForegroundColorAttributeName : preferenceColor };
	NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.preferencesTextView.attributedText];
	[attributedText addAttributes:attrs range:selectedActivityRange];
	
	self.preferencesTextView.attributedText = attributedText;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	SACollectionButtonViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
	
	cell.iconImageView.image = [UIImage imageNamed:@"ic_favorite"];
	cell.titleLabel.text = self.timetable[indexPath.item];
	
	return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	
	NSInteger numberOfItems;
	switch (section) {
		case 0: numberOfItems = self.timetable.count; break;
		default: numberOfItems = 0;
	}
	return numberOfItems;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	
	self.selectedSchedule = self.timetable[indexPath.item];
	[collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
	
	self.selectedSchedule = nil;
	[collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

- (void)setSelectedSchedule:(NSString *)selectedSchedule {
	_selectedSchedule = selectedSchedule;
	self.nextButton.enabled = selectedSchedule != nil;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"newEvent2To3"]) {
		SANewEvent3ViewController *newEvent3 = segue.destinationViewController;
		newEvent3.selectedActivity = self.selectedActivity;
		newEvent3.selectedSchedule = self.selectedSchedule;
	}
}

- (IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
	
}

@end
