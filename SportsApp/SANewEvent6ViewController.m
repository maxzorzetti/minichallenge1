//
//  SANewEvent6ViewController.m
//  SportsApp
//
//  Created by Max Zorzetti on 02/05/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "SAFriendCollectionViewCell.h"
#import "SANewEvent6ViewController.h"
#import "SAMatchmaker.h"
#import "SAEvent.h"
#import "ClosedEventDescriptionViewController.h"
#import "SAEventDescriptionViewController.h"

@interface SANewEvent6ViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *friendsCollectionView;

@property (weak, nonatomic) IBOutlet UIView *rectangleView;

@property (weak, nonatomic) IBOutlet UILabel *eventNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *scheduleLabel;

@property (weak, nonatomic) IBOutlet UILabel *shiftLabel;

@property (weak, nonatomic) IBOutlet UIImageView *genderImageView;

@property (weak, nonatomic) IBOutlet UILabel *genderLabel;

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@property (weak, nonatomic) IBOutlet UILabel *capacityLabel;

@property (weak, nonatomic) IBOutlet UIProgressView *capacityProgressBar;

@property (weak, nonatomic) IBOutlet UIButton *publishButton;

@end

@implementation SANewEvent6ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
    // Do any additional setup after loading the view.
	
	self.friendsCollectionView.dataSource = self;
	
	self.rectangleView.layer.cornerRadius = 3.6;
	self.rectangleView.layer.masksToBounds = YES;
	self.rectangleView.layer.borderWidth = 0;
	
	self.eventNameLabel.text = self.party.eventName;
	self.scheduleLabel.text = self.party.schedule.uppercaseString;
	NSString *shiftText;
	switch (self.party.shift) {
		case SAMorningShift:	shiftText = @"Morning";		break;
		case SAAfternoonShift:	shiftText = @"Afternoon";	break;
		case SANightShift:		shiftText = @"Night";		break;
		case SANoShift:			shiftText = @"Error";		break;
	}
	self.shiftLabel.text = shiftText;
	
	UIImage *genderImage;
	NSString *genderText;
	switch (self.party.gender) {
		case SAFemaleGender:
			genderText = @"Female";
			genderImage = [UIImage imageNamed:@"ic_female"]; break;
		case SAMaleGender:
			genderText = @"Male";
			genderImage = [UIImage imageNamed:@"ic_male"]; break;
		case SAMixedGender:
			genderText = @"Mixed";
			genderImage = [UIImage imageNamed:@"ic_mixed"];
			break;
		case SANoGender:
			genderText = @"Error";
			genderImage = [UIImage imageNamed:@"ic_mixed"];
			break;
	}
	self.genderLabel.text = genderText;
	self.genderImageView.image = genderImage;
	self.locationLabel.text = [[NSString alloc] initWithFormat: @"In up to %@ km", self.party.locationRadius.stringValue];
	NSLog(@"EVENTO6 %d", self.party.minParticipants);
	self.capacityLabel.text = [[NSString alloc] initWithFormat:@"1/%d", self.party.maxParticipants];
	
	self.capacityProgressBar.progress = 1.0 / self.party.maxParticipants;
	
	NSLog(@"%@", self.genderLabel.text);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	SAFriendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"friendCell" forIndexPath:indexPath];
	
	NSArray<SAPerson *> *friends = [self.party.invitedPeople allObjects];
	
	cell.profilePictureImageView.image = [UIImage imageWithData: friends[indexPath.item].photo];

	return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return self.party.invitedPeople.count;
}

- (IBAction)publishPressed:(UIButton *)sender {
	
	[SAMatchmaker enterMatchmakingWithParty:self.party handler:^(SAEvent * _Nullable event, NSError * _Nullable error) {
		dispatch_async(dispatch_get_main_queue(), ^{
			//
			
			if ( event.participants.count >= event.minPeople.integerValue ) {
				NSLog(@"FULL EVENT");
				UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
				
				ClosedEventDescriptionViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"eventFull"];
				
				vc.event = event;
				
				[self presentViewController:vc animated:YES completion:^{
					//unwind man
				}];
			} else {
				NSLog(@"No event found");
				
				UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
				
				
				SAEventDescriptionViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"eventDescription"];
				
				vc.currentEvent = event;
				
				NSLog(@"%@", event);
				
				[self presentViewController:vc animated:YES completion:^{
					NSLog(@"%@", vc.currentEvent);
				}];
			}
		});
		
		
	}];
	
}



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	NSLog(@"SEGUEUEUEUEEUU");
	
}


@end
