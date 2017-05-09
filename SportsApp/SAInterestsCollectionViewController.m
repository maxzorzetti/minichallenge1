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
@interface SAInterestsCollectionViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *viewOfCollectionView;

@property NSArray<SAActivity *> *activities;
@property NSString *reuseIdentifier;
@property NSMutableSet *interestedActivities;
@property NSMutableArray *activitiesRefs;

@end

@implementation SAInterestsCollectionViewController

- (IBAction)interestsSelected:(UIButton *)sender {
    _activitiesRefs = [[NSMutableArray alloc] init];
    CKContainer *container = [CKContainer defaultContainer];
    CKDatabase *publicDatabase = [container publicCloudDatabase];
    
    for (SAActivity *activity in _interestedActivities)
    {
        //SAActivity *Activity = [activities firstObject];
        CKReference *ref = [[CKReference alloc] initWithRecordID:activity.activityId action:CKReferenceActionNone];
        [_activitiesRefs addObject:ref];
        
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"email = %@", _email];
    CKQuery *query = [[CKQuery alloc] initWithRecordType:@"SAPerson" predicate:predicate];
    
    
    [publicDatabase performQuery:query inZoneWithID:nil completionHandler:^(NSArray *results, NSError *error) {
        if (error) {
            NSLog(@"error: %@",error.localizedDescription);
        }
        else {
            
            [results firstObject][@"interestedActivities"] = _activitiesRefs;
            [publicDatabase saveRecord:[results firstObject]  completionHandler:^(CKRecord *artworkRecord, NSError *error){
                if (error) {
                    NSLog(@"Telefone nao salvo. Error: %@", error.description);
                }
                else{
                    NSLog(@"Telephone salvo");
                    [self goToFeed];
                }
            }];
            
            
        }}];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewOfCollectionView.delegate = self;
    self.viewOfCollectionView.dataSource = self;
    
    _interestedActivities = [[NSMutableSet alloc] init];
    _activitiesRefs = [[NSMutableArray alloc]init];
    
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
