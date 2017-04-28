//
//  SANewEvent3ViewController.m
//  SportsApp
//
//  Created by Max Zorzetti on 27/04/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "SANewEvent3ViewController.h"
#import "SAActivityCollectionViewCell.h"

@interface SANewEvent3ViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *peopleCollectionView;

@property (nonatomic) NSArray *people;

@end

@implementation SANewEvent3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.peopleCollectionView.dataSource = self;
	
	self.people = @[@"with friends", @"with anyone"];
	
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	
	NSInteger numberOfItems;
	switch (section) {
		case 0:	numberOfItems = self.people.count; break;
		default: numberOfItems = 0;
	}
	return numberOfItems;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	SAActivityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"buttonCell" forIndexPath:indexPath];
	
	cell.title.text = self.people[indexPath.row];
	cell.icon.image = [UIImage imageNamed:@"ic_favorite"];
	
	return cell;
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
