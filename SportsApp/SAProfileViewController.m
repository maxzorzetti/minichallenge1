
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
#import <CoreLocation/CLGeocoder.h>
#import <CoreLocation/CLPlacemark.h>
#import "SAGenderSelectionViewController.h"

@interface SAProfileViewController ()


@property FBSDKProfilePictureView *profPhoto2;

@property (weak, nonatomic) IBOutlet UIImageView *profilePhoto;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UIImageView *genderIcon;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *viewToBorder;
@property (nonatomic) SAPerson *user;
@property (nonatomic) CLLocationManager *locationManager;

@end

@implementation SAProfileViewController

- (void)viewDidDisappear:(BOOL)animated{
    [self.locationManager stopUpdatingLocation];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.allowsSelection = NO;

    NSData *userData = [[NSUserDefaults standardUserDefaults] dataForKey:@"user"];
    self.user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    
    switch ([CLLocationManager authorizationStatus]) {
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            self.locationManager = [[CLLocationManager alloc]init];
            [self startStandartUpdates];
            self.user.locationManager = self.locationManager;
            [self.locationManager requestLocation];
            break;
            //        case kCLAuthorizationStatusNotDetermined:
            //            self.locationManager = [[CLLocationManager alloc]init];
            //            [self startStandartUpdates];
            //
            //            self.user.locationManager = self.locationManager;
            //            [self.locationManager requestWhenInUseAuthorization];
            //            [self.locationManager requestLocation];
            //            break;
        default:
            break;
    }
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"SACollectionButtonViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    
    self.viewToBorder.layer.borderColor = [UIColor colorWithRed:119/255.0 green:90/255.0 blue:218/255.0 alpha:1.0].CGColor;
    self.viewToBorder.layer.borderWidth = 1.0;
    self.viewToBorder.layer.cornerRadius = 8.0;
    
    if (self.user.photo) {
//        self.profilePhoto.image = [UIImage imageWithData:self.user.photo];
        //self.profilePhoto.layer.cornerRadius = self.profilePhoto.frame.size.height/2;
      //  self.profilePhoto.layer.masksToBounds = YES;
       // self.profilePhoto.layer.borderWidth = 0;
        
        
       //self.profPhoto2.profileID.
        
       
        
      self.profPhoto2  = [[FBSDKProfilePictureView alloc]initWithFrame:CGRectMake(self.profilePhoto.frame.origin.x - 20, _profilePhoto.frame.origin.y, _profilePhoto.frame.size.width, _profilePhoto.frame.size.height)];
        
        
        
        if (self.user.facebookId){
            self.profPhoto2.profileID = self.user.facebookId;
        }
        [self.profilePhoto addSubview:_profPhoto2];
        
        self.profPhoto2.layer.cornerRadius = self.profPhoto2.frame.size.height/2;
        self.profPhoto2.layer.masksToBounds = YES;
        self.profPhoto2.layer.borderWidth = 0;
        
        
        
        
        
        
    }
    self.userName.text = self.user.name;
    
    if (self.user.gender) {
        self.genderLabel.text = self.user.gender;
        
        if ([self.user.gender isEqualToString:@"Female"]) {
            self.genderIcon.image = [UIImage imageNamed:@"Icon_Female"];
        }else{
            self.genderIcon.image = [UIImage imageNamed:@"Icon_Male"];
        }
    }
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //do nothing;
    SACollectionButtonViewCell *cell = (SACollectionButtonViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell setCustomSelection:NO];
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    //do nothing;
    SACollectionButtonViewCell *cell = (SACollectionButtonViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell setCustomSelection:NO];
}

#pragma location methods
- (void)startStandartUpdates{
    if (self.locationManager == nil) {
        self.locationManager = [[CLLocationManager alloc]init];
    }
    
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = 1000;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    NSArray *sortedArray;
    
    sortedArray = [locations sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        CLLocation *loc1 = obj1;
        CLLocation *loc2 = obj2;
        
        return [loc1.timestamp compare:loc2.timestamp];
    }];
    
    [self.user setLocation:[sortedArray firstObject]];
    
    //make locationReadable
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:self.user.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (!error) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            self.locationLabel.text = [NSString stringWithFormat:@"%@",placemark.locality.capitalizedString];
        }
    }];
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    if (error) {
        NSLog(@"Error when fetching location: %@", error.description);
    }
}

#pragma Finish Profile customization
- (IBAction)goToCustomizeProfile:(UIBarButtonItem *)sender {
    
    //right now it shows part of the sign up proccess, TODO create a view for modifying profile
    UIStoryboard *secondary = [UIStoryboard storyboardWithName:@"Secondary" bundle:nil];
    SAGenderSelectionViewController *genderSelection = [secondary instantiateViewControllerWithIdentifier:@"genderSelectionView"];
    
    genderSelection.user = self.user;
    genderSelection.previousView = @"profile";
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:genderSelection animated:YES completion:^{
            
        }];
    });
}



@end
