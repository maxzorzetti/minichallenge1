
//
//  SAProfileViewController.m
//  SportsApp
//
//  Created by Laura Corssac on 21/04/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "SAProfileViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <UIKit/UIKit.h>
#import "SAPerson.h"
#import "SAActivity.h"
#import "SACollectionButtonViewCell.h"

@interface SAProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profilePhoto;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UIImageView *genderIcon;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *viewToBorder;
@property (nonatomic) SAPerson *user;

@end

@implementation SAProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSData *userData = [[NSUserDefaults standardUserDefaults] dataForKey:@"user"];
    self.user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];

    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"SACollectionButtonViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    
    self.viewToBorder.layer.borderColor = [UIColor colorWithRed:119/255.0 green:90/255.0 blue:218/255.0 alpha:1.0].CGColor;
    self.viewToBorder.layer.borderWidth = 1.0;
    self.viewToBorder.layer.cornerRadius = 8.0;
    
    if (self.user.photo) {
        self.profilePhoto.image = [UIImage imageWithData:self.user.photo];
        self.profilePhoto.layer.cornerRadius = self.profilePhoto.frame.size.height/2;
        self.profilePhoto.layer.masksToBounds = YES;
        self.profilePhoto.layer.borderWidth = 0;
    }
    self.userName.text = self.user.name;
    self.genderIcon.image = [UIImage imageNamed:@"icon_pin"];
    self.genderLabel.text = @"LocationGender";
    
    
    
    
    
    //TODO COMMENT THIS LINES ONCE INTERESTS ARE BEING SET
    NSMutableArray *arrayOfActivities = [[NSUserDefaults standardUserDefaults] mutableArrayValueForKey:@"ArrayOfDictionariesContainingTheActivities"];
    NSMutableArray<SAActivity *> *activities = [NSMutableArray new];
    for (NSDictionary *activityDic in arrayOfActivities) {
        SAActivity *activity = [NSKeyedUnarchiver unarchiveObjectWithData:activityDic[@"activityData"]];
        NSLog(@"ACTIVITY %@", activity);
        [activities addObject: activity];
    }
    
    self.user.interests = activities;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SACollectionButtonViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    SAActivity *activity = self.user.interests[indexPath.item];
    cell.iconImageView.image = [UIImage imageWithData:activity.picture];
    cell.titleLabel.text = activity.name;
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSInteger numberOfItems;
    switch (section) {
        case 0: numberOfItems = self.user.interests.count; break;
        default: numberOfItems = 0;
    }
    return numberOfItems;
}


@end
