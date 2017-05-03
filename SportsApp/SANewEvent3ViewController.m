//
//  SANewEvent3ViewController.m
//  SportsApp
//
//  Created by Max Zorzetti on 27/04/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "SANewEvent1ViewController.h"
#import "SANewEvent3ViewController.h"
#import "SANewEvent4ViewController.h"
#import "SAFriendTableViewCell.h"
#import "SAPersonConnector.h"
#import "SACollectionButtonViewCell.h"

@class SAPerson;

@interface SANewEvent3ViewController ()

@property (weak, nonatomic) IBOutlet UITextView *preferencesTextView;

@property (weak, nonatomic) IBOutlet UICollectionView *peopleCollectionView;

@property (weak, nonatomic) IBOutlet UITableView *friendsTableView;
@property (nonatomic) NSArray<SAPerson *> *friends;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (nonatomic) NSArray<NSNumber *> *peopleType;

@end

@implementation SANewEvent3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self processPreferencesTextView];
	
	self.peopleCollectionView.dataSource = self;
	self.peopleCollectionView.delegate = self;
	
	self.friendsTableView.dataSource = self;
	self.friendsTableView.delegate = self;
	self.friendsTableView.allowsMultipleSelection = YES;
	
	[self.peopleCollectionView registerNib:[UINib nibWithNibName:@"SACollectionButtonViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
	
	self.peopleType = @[[NSNumber numberWithInteger:SAAnyonePeopleType],
						[NSNumber numberWithInteger:SAMyFriendsPeopleType]];
	
	//self.selectedFriends = [NSMutableSet new];
	
	[self getFriendsList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)processPreferencesTextView {
	// Insert preferences in the text
	NSMutableString *rawText = [[NSMutableString alloc] initWithString:self.preferencesTextView.text];
	[rawText replaceOccurrencesOfString:@"<activity>" withString:self.party.activity.name options:NSLiteralSearch range:NSMakeRange(0, rawText.length)];
	[rawText replaceOccurrencesOfString:@"<schedule>" withString:self.party.schedule options:NSLiteralSearch range:NSMakeRange(0, rawText.length)];
	
	// Get preferences indexes
	NSRange selectedActivityRange = [rawText rangeOfString:self.party.activity.name];
	NSRange selectedScheduleRange = [rawText rangeOfString:self.party.schedule];

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
	
	NSString *cellLabelText;
	switch (indexPath.item) {
		case 0:	cellLabelText = @"My Friends"; break;
		case 1: cellLabelText = @"Anyone"; break;
	}
	cell.titleLabel.text = cellLabelText;
		
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	//self.selectedPeopleType = self.peopleType[indexPath.item];
	self.party.peopleType = self.peopleType[indexPath.item].integerValue;
	[self updateNextButton];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
	//self.selectedPeopleType = nil;
	self.party.peopleType = SANoPeopleType;
	[self updateNextButton];
}

- (void)getFriendsList {
	
	NSMutableArray *friendList = [[NSMutableArray alloc] init];
	//
	if ( [FBSDKAccessToken currentAccessToken]) {
		FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
									  initWithGraphPath:@"/me"
									  parameters:@{ @"fields": @"friends",}
									  HTTPMethod:@"GET"];
		[request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
			//
			if (error) {
				NSLog(@"ERRO = %@", error.description);
			}
			else {
			
				for (id person in [[result objectForKey:@"friends"]objectForKey:@"data"] )
				{
					NSString *userID = [person objectForKey:@"id"];
					[friendList addObject:userID];
					
				}
				
				[SAPersonConnector getPeopleFromFacebookIds:friendList handler:^(NSArray<SAPerson *> * _Nullable results, NSError * _Nullable error) {
					if (!error)
					{
						NSLog(@"EH TCHOLA");
						[self updateTableViewWithFriends:results];
						
					}
				}];
				NSLog(@" na moral funfa vai friend list = %@",  friendList);
				
			}
		}];
	}
}

- (void)updateTableViewWithFriends:(NSArray<SAPerson *> *)friends {
	self.friends = friends;
	NSLog(@"%@", friends);
	[self.friendsTableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	SAFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendCell"];
	
	SAPerson *friend = self.friends[indexPath.row];
	
	cell.nameLabel.text = friend.name;
	cell.profilePictureImageView.image = [UIImage imageWithData:friend.photo];

	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.friends.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self.party.invitedPeople addObject:self.friends[indexPath.row]];
}


- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
		
	[self.party.invitedPeople removeObject:self.friends[indexPath.row]];
}

- (void)updateNextButton {
	self.nextButton.enabled = self.party.peopleType != SANoPeopleType;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	NSLog(@"%@", segue.identifier);
	if ([segue.identifier isEqualToString:@"newEvent3To4"]) {
		SANewEvent4ViewController *newEvent4 = segue.destinationViewController;
		
		newEvent4.party = [self.party copy];
	}
}

- (IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
	
}

@end
