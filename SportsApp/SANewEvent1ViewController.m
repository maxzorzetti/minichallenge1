//
//  SANewEvent1ViewController.m
//  SportsApp
//
//  Created by Max Zorzetti on 27/04/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "SANewEvent1ViewController.h"
#import "SAActivityConnector.h"
#import "SAActivity.h"
#import "SAActivityCollectionViewCell.h"

@interface SANewEvent1ViewController ()

@property (nonatomic) NSArray *activities;
@property (weak, nonatomic) IBOutlet UICollectionView *activitiesCollectionView;

@end

@implementation SANewEvent1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.activitiesCollectionView.dataSource = self;
	
	SAActivity *futebas = [[SAActivity alloc]initWithName:@"Futebas" minimumPeople:14 maximumPeople:16 AndActivityId:nil];
	SAActivity *volei = [[SAActivity alloc]initWithName:@"Volei" minimumPeople:14 maximumPeople:16 AndActivityId:nil];
	SAActivity *tenis = [[SAActivity alloc]initWithName:@"Tenis" minimumPeople:14 maximumPeople:16 AndActivityId:nil];
	SAActivity *golf = [[SAActivity alloc]initWithName:@"Golf" minimumPeople:14 maximumPeople:16 AndActivityId:nil];
	SAActivity *basquete = [[SAActivity alloc]initWithName:@"Basquete" minimumPeople:14 maximumPeople:16 AndActivityId:nil];
	
	self.activities = @[futebas, volei, tenis, golf, basquete];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	SAActivityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"buttonCell" forIndexPath:indexPath];
	[cell configureWithActivity: self.activities[indexPath.row]];
	
	return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	
	NSInteger numberOfItems;
	switch (section) {
		case 0: numberOfItems = self.activities.count; break;
		default: numberOfItems = 0;
	}
	return numberOfItems;
}

@end
