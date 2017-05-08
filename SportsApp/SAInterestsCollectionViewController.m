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

@interface SAInterestsCollectionViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *viewOfCollectionView;

@property NSArray<SAActivity *> *activities;
@property NSString *reuseIdentifier;
@property NSMutableSet *interestedActivities;

@end

@implementation SAInterestsCollectionViewController


- (IBAction)buttonPressed:(UIBarButtonItem *)sender {
    
    //printf("%s", __PRETTY_FUNCTION__);
    
    
    
    
    
}





- (void)viewDidLoad {
    printf("%s", __PRETTY_FUNCTION__);
    [super viewDidLoad];
    
    self.reuseIdentifier = @"cell";
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.viewOfCollectionView.allowsMultipleSelection = YES;
    
    // Register cell classes
    [self.viewOfCollectionView registerNib:[UINib nibWithNibName:@"SACollectionButtonViewCell" bundle:nil] forCellWithReuseIdentifier:self.reuseIdentifier];
    
    // App activities?
    
    NSMutableArray *arrayOfActivities = [[NSUserDefaults standardUserDefaults] mutableArrayValueForKey:@"ArrayOfDictionariesContainingTheActivities"];
    NSMutableArray<SAActivity *> *activities = [NSMutableArray new];
    for (NSDictionary *activityDic in arrayOfActivities) {
        SAActivity *activity = [NSKeyedUnarchiver unarchiveObjectWithData:activityDic[@"activityData"]];
        NSLog(@"ACTIVITY %@", activity);
        [activities addObject: activity];
    }
    
    [activities sortUsingComparator:^NSComparisonResult(SAActivity*  _Nonnull obj1, SAActivity*  _Nonnull obj2) {
        return [obj1.name compare:obj2.name];
    }];
    
    self.activities = activities;
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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _activities.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    printf("%s", __PRETTY_FUNCTION__);
    SACollectionButtonViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.reuseIdentifier forIndexPath:indexPath];
    
    SAActivity *activity = self.activities[indexPath.item];
    cell.iconImageView.image = [UIImage imageWithData:activity.picture];
    cell.titleLabel.text = activity.name;
    
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if(kind == UICollectionElementKindSectionHeader){
        SAInterestsCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"interestsHeaderView" forIndexPath:indexPath];
        
        return headerView;
    }
    
    return nil;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SAActivity *activity = self.activities[indexPath.item];
    [self.interestedActivities addObject:activity];
    NSLog(@"%@", activity.name);
    
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    SAActivity *activity = self.activities[indexPath.item];
    [self.interestedActivities removeObject:activity];
    NSLog(@"%@", activity.name);
}

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
