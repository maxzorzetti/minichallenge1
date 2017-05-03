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

@end

@implementation SANewEvent6ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.friendsCollectionView.dataSource = self;
	
	self.rectangleView.layer.cornerRadius = 3.6;
	self.rectangleView.layer.masksToBounds = YES;
	self.rectangleView.layer.borderWidth = 0;
	
	
	NSLog(@"%@", self.selectedFriends);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"AOKAPORKAEPOKEPORKEWPOKEWPORKEWOP");
	
	SAFriendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"friendCell" forIndexPath:indexPath];
	
	NSArray<SAPerson *> *friends = [self.selectedFriends allObjects];
	
	cell.profilePictureImageView.image = [UIImage imageWithData: friends[indexPath.item].photo];

	return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return self.selectedFriends.count;
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
