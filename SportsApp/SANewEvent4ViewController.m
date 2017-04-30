//
//  SANewEvent4ViewController.m
//  SportsApp
//
//  Created by Max Zorzetti on 27/04/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "SANewEvent1ViewController.h"
#import "SANewEvent4ViewController.h"

@interface SANewEvent4ViewController ()

@property (weak, nonatomic) IBOutlet UITextView *preferencesTextView;

@property (weak, nonatomic) IBOutlet UITableView *locationsTableView;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (nonatomic) NSString *selectedLocation;

@end

@implementation SANewEvent4ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	[self processPreferencesTextView];
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
	[rawText replaceOccurrencesOfString:@"<people>" withString:self.selectedPeopleType options:NSLiteralSearch range:NSMakeRange(0, rawText.length)];

	// Get preferences indexes
	NSRange selectedActivityRange = [rawText rangeOfString:self.selectedActivity.name];
	NSRange selectedScheduleRange = [rawText rangeOfString:self.selectedSchedule];
	NSRange selectedPeopleTypeRange = [rawText rangeOfString:self.selectedPeopleType];
	
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
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


- (IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
	
}

@end
