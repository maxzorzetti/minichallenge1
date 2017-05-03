//
//  SANewEvent6ViewController.m
//  SportsApp
//
//  Created by Max Zorzetti on 02/05/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "SAFriendCollectionViewCell.h"
#import "SANewEvent6ViewController.h"


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

@end

@implementation SANewEvent6ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.friendsCollectionView.dataSource = self;
	
	self.rectangleView.layer.cornerRadius = 3.6;
	self.rectangleView.layer.masksToBounds = YES;
	self.rectangleView.layer.borderWidth = 0;
	
	self.eventNameLabel.text;
	self.scheduleLabel.text = self.party.schedule;
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
	self.locationLabel.text = self.party.locationRadius.stringValue;
	self.capacityLabel.text = [[NSString alloc] initWithFormat:@"%d/%d", self.party.minParticipants, self.party.maxParticipants];
	
	self.capacityProgressBar.progress = 1.0 * self.party.minParticipants / self.party.maxParticipants;
	
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
