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
#import "SAShiftCollectionViewCell.h"

@interface SANewEvent2ViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *timetableCollectionView;

@property (weak, nonatomic) IBOutlet UICollectionView *shiftsCollectionView;

@property (weak, nonatomic) IBOutlet UITextView *preferencesTextView;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (nonatomic) NSArray *timetable;
@property (nonatomic) NSArray<NSNumber *> *shifts;

//@property (nonatomic) NSString *selectedSchedule;
//@property (nonatomic) NSString *selectedShift;

@end

@implementation SANewEvent2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.timetableCollectionView.dataSource = self;
	self.timetableCollectionView.delegate = self;
	self.timetableCollectionView.tag = 0;
	
	self.shiftsCollectionView.dataSource = self;
	self.shiftsCollectionView.delegate = self;
	self.shiftsCollectionView.tag = 1;
	
	[self processPreferencesTextView];
	
	[self.timetableCollectionView registerNib:[UINib nibWithNibName:@"SACollectionButtonViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];

	
	self.timetable = @[@"Tomorrow", @"Next Week", @"Next Month", @"Today", @"This Week", @"Any Day"];
	
	self.shifts = @[[NSNumber numberWithInteger:SAMorningShift],
					[NSNumber numberWithInteger:SAAfternoonShift],
					[NSNumber numberWithInteger:SANightShift]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)processPreferencesTextView {
	// Insert the preference in the text
	NSMutableString *rawText = [[NSMutableString alloc] initWithString:self.preferencesTextView.text];
	[rawText replaceOccurrencesOfString:@"<activity>" withString:self.party.activity.name options:NSLiteralSearch range:NSMakeRange(0, rawText.length)];
	NSRange selectedActivityRange = [rawText rangeOfString:self.party.activity.name];
	self.preferencesTextView.text = rawText;
	
	// Paint the preference
	UIColor *preferenceColor = [SANewEvent1ViewController preferenceColor];

	NSDictionary *attrs = @{ NSForegroundColorAttributeName : preferenceColor };
	NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.preferencesTextView.attributedText];
	[attributedText addAttributes:attrs range:selectedActivityRange];
	
	self.preferencesTextView.attributedText = attributedText;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	if (collectionView.tag == 0) {
		
		SACollectionButtonViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
		
		cell.iconImageView.image = [UIImage imageNamed:@"ic_calendarButton"];
		cell.titleLabel.text = self.timetable[indexPath.item];
		
		return cell;
		
	} else {
		
		SAShiftCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"shiftCell" forIndexPath:indexPath];
		
		NSString *cellLabelText;
		
		switch (self.shifts[indexPath.item].integerValue) {
			case 0: cellLabelText = @"Morning"; break;
			case 1: cellLabelText = @"Afternoon"; break;
			case 2: cellLabelText = @"Night"; break;
		}
		
		cell.shiftLabel.text = cellLabelText;
		
		return cell;
	}
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	
	if (collectionView.tag == 0) {
		NSInteger numberOfItems;
		switch (section) {
			case 0: numberOfItems = self.timetable.count; break;
			default: numberOfItems = 0;
		}
		return numberOfItems;
	} else {
		return self.shifts.count;
	}
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	if (collectionView.tag == 0) {
		
		//self.selectedSchedule = self.timetable[indexPath.item];
		self.party.schedule = self.timetable[indexPath.item];
		//[collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
		
	} else {
		//self.selectedShift = self.shifts[indexPath.item];
		self.party.shift = self.shifts[indexPath.item].integerValue;
	}
	
	[self updateNextButton];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
	if (collectionView.tag == 0) {
		
		//self.selectedSchedule = nil;
		self.party.schedule = nil;
		[collectionView deselectItemAtIndexPath:indexPath animated:YES];
		
	} else {
		
		self.party.shift = SANoShift;
		//self.selectedShift = nil;
		
	}
	[self updateNextButton];
}

//- (void)setSelectedSchedule:(NSString *)selectedSchedule {
//	_selectedSchedule = selectedSchedule;
//	[self updateNextButton];
//}
//
//- (void)setSelectedShift:(NSString *)selectedShift {
//	_selectedShift = selectedShift;
//	[self updateNextButton];
//}

- (void)updateNextButton {
	self.nextButton.enabled = self.party.schedule != nil && self.party.shift != SANoShift;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	NSLog(@"EVENT2 %@", [self.party.invitedPeople class]);
	if ([segue.identifier isEqualToString:@"newEvent2To3"]) {
		SANewEvent3ViewController *newEvent3 = segue.destinationViewController;
		//newEvent3.selectedActivity = self.selectedActivity;
		//newEvent3.selectedSchedule = self.selectedSchedule;
		
		newEvent3.party = [self.party copy];
	}
}

- (IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
	
}

@end
