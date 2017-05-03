//
//  SANewEvent6ViewController.h
//  SportsApp
//
//  Created by Max Zorzetti on 02/05/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SAPerson.h"

@interface SANewEvent6ViewController : UIViewController <UICollectionViewDataSource>

@property (nonatomic) SAActivity *selectedActivity;
@property (nonatomic) NSString *selectedSchedule;
@property (nonatomic) NSString *selectedPeopleType;
@property (nonatomic) NSSet<SAPerson *> *selectedFriends;
@property (nonatomic) NSString *selectedLocation;
@property (nonatomic) NSString *selectedGender;


@end
