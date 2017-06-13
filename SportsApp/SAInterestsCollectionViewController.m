//
//  SAInterestsCollectionViewController.m
//  SportsApp
//
//  Created by Bharbara Cechin on 28/04/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "SAInterestsCollectionViewController.h"
#import "SAInterestsCollectionReusableView.h"
#import "SAActivity.h"
#import <CloudKit/CloudKit.h>
#import "SAPersonConnector.h"
#import "SAPerson.h"
@interface SAInterestsCollectionViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *viewOfCollectionView;

@property NSArray<SAActivity *> *activities;
@property NSString *reuseIdentifier;
@property NSMutableSet *interestedActivities;

@end

@implementation SAInterestsCollectionViewController

- (IBAction)interestsSelected:(UIButton *)sender {
    [self.user setInterests: [NSMutableArray arrayWithArray:[self.interestedActivities allObjects]]];
    
    [SAPersonConnector savePerson:self.user handler:^(SAPerson * _Nullable person, NSError * _Nullable error) {
        if (!error) {
            NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:person];
            [[NSUserDefaults standardUserDefaults] setObject:userData forKey:@"user"];
            
            if ([_previousView  isEqual: @"profile"])
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                [self goToProfile];
                });
            }
        
            
            else {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                [self goToFeed];
                });
            }
            
            
        
    }
        
        
        else{
        
        }
        
        
        
    }
     
        
        ];
    
    
    
    
    
    
}






- (void)  goToProfile{
    
    
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *destination = [main instantiateViewControllerWithIdentifier:@"view2"];
    [destination setSelectedViewController:[destination.viewControllers objectAtIndex:2]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:destination animated:YES completion:^{
            
        }];
    });
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewOfCollectionView.delegate = self;
    self.viewOfCollectionView.dataSource = self;
    
    self.interestedActivities = [NSMutableSet new];
    
    
    self.reuseIdentifier = @"activityCell";
    self.viewOfCollectionView.allowsMultipleSelection = YES;
    
    // Register cell classes
    [self.viewOfCollectionView registerNib:[UINib nibWithNibName:@"SACollectionButtonViewCell" bundle:nil] forCellWithReuseIdentifier:self.reuseIdentifier];

    
    NSMutableArray *arrayOfActivities = [[NSUserDefaults standardUserDefaults] mutableArrayValueForKey:@"ArrayOfDictionariesContainingTheActivities"];
    NSMutableArray<SAActivity *> *activities = [NSMutableArray new];
    
    
    for (NSDictionary *activityDic in arrayOfActivities) {
        SAActivity *activity = [NSKeyedUnarchiver unarchiveObjectWithData:activityDic[@"activityData"]];
        [activities addObject: activity];
    }
    
    [activities sortUsingComparator:^NSComparisonResult(SAActivity*  _Nonnull obj1, SAActivity*  _Nonnull obj2) {
        return [obj1.name compare:obj2.name];
    }];
    
    self.activities = activities;
    
    //add existing interests to array of interests so it is shown selected later
    for (SAActivity *activity in self.user.interests) {
        for (SAActivity *activityInDb in self.activities) {
            if ([activity.activityId.recordName isEqualToString:activityInDb.activityId.recordName]) {
                [self.interestedActivities addObject:activityInDb];
            }
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)goToFeed{
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *destination = [main instantiateViewControllerWithIdentifier:@"view2"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:destination animated:YES completion:^{
            
        }];
    });
}
#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.activities count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SACollectionButtonViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.reuseIdentifier forIndexPath:indexPath];
    
    SAActivity *activity = self.activities[indexPath.item];
    cell.iconImageView.image = [UIImage imageWithData:activity.picture];
    cell.selectedImage = [UIImage imageWithData:activity.pictureWhite];
    cell.unselectedImage = [UIImage imageWithData:activity.picture];
    cell.titleLabel.text = activity.name;
    
    for (SAActivity *activityInterested in self.user.interests) {
        if ([activity.activityId.recordName isEqualToString:activityInterested.activityId.recordName]) {
            [cell setCustomSelection:YES];
        }
    }
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SAActivity *activity = self.activities[indexPath.item];
    [self.interestedActivities addObject:activity];
    
    SACollectionButtonViewCell *cell = (SACollectionButtonViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell setCustomSelection:YES];
}

- (void) collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    SAActivity *activity = self.activities[indexPath.item];
    [self.interestedActivities removeObject:activity];
    
    SACollectionButtonViewCell *cell = (SACollectionButtonViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell setCustomSelection:NO];
}

@end
