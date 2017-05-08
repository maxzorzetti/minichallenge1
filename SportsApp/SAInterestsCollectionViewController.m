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


- (IBAction)buttonPressed:(UIBarButtonItem *)sender {
    
    _activitiesRefs = [[NSMutableArray alloc] init];
    //printf("%s", __PRETTY_FUNCTION__);
    CKContainer *container = [CKContainer defaultContainer];
    CKDatabase *publicDatabase = [container publicCloudDatabase];
    
   for (SAActivity *activity in _interestedActivities)
   {
       //SAActivity *Activity = [activities firstObject];
       CKReference *ref = [[CKReference alloc] initWithRecordID:activity.activityId action:CKReferenceActionNone];
       [_activitiesRefs addObject:ref];
       
   }
   
    
    //NSLog(@"%@", _email);
    
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
    printf("%s", __PRETTY_FUNCTION__);
    [super viewDidLoad];
    
    _interestedActivities = [[NSMutableSet alloc] init];
    //_activities = [[NSMutableArray alloc]init];
    _activitiesRefs = [[NSMutableArray alloc]init];
    
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


- (void)goToFeed{
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *destination = [main instantiateViewControllerWithIdentifier:@"view2"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:destination animated:YES completion:^{
            
        }];
    });
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
