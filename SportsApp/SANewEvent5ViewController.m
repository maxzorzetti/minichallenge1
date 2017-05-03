//
//  SANewEvent5ViewController.m
//  SportsApp
//
//  Created by Max Zorzetti on 02/05/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "SACollectionButtonViewCell.h"
#import "SANewEvent5ViewController.h"
#import "SANewEvent6ViewController.h"

@interface SANewEvent5ViewController ()

@property (nonatomic) NSString *selectedGender;

@property (weak, nonatomic) IBOutlet UICollectionView *genderCollectionView;

@end

@implementation SANewEvent5ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

	self.genderCollectionView.dataSource = self;
	self.genderCollectionView.delegate = self;

	[self.genderCollectionView registerNib:[UINib nibWithNibName:@"SACollectionButtonViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	NSString *genderName;
	UIImage *genderImage;
	NSLog(@"FEITOMAN");
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
		case 0:	self.selectedGender = @"Female"; break;
		case 1: self.selectedGender = @"Male"; break;
		case 2: self.selectedGender = @"Mixed";
	}
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
	self.selectedGender = nil;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	NSInteger numberOfItems;
	switch (section) {
		case 0: numberOfItems = 3; break;
		default: numberOfItems = 0;	break;
	}
	return numberOfItems;
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	 if ([segue.identifier isEqualToString:@"newEvent5To6"]) {
		 NSLog(@"ESSEFOI");
		 SANewEvent6ViewController *newEvent6 = segue.destinationViewController;
		 newEvent6.selectedActivity = self.selectedActivity;
		 newEvent6.selectedSchedule = self.selectedSchedule;
		 newEvent6.selectedPeopleType = self.selectedPeopleType;
		 newEvent6.selectedFriends = self.selectedFriends;
		 newEvent6.selectedGender = self.selectedGender;
	 }
 }
 

@end
