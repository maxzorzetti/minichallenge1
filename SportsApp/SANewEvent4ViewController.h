//
//  SANewEvent4ViewController.h
//  SportsApp
//
//  Created by Max Zorzetti on 27/04/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SAActivity.h"
#import "SAPerson.h"

@interface SANewEvent4ViewController : UIViewController

@property (nonatomic) SAActivity *selectedActivity;

@property (nonatomic) NSString *selectedSchedule;

@property (nonatomic) NSString *selectedPeopleType;

@property (nonatomic) NSSet<SAPerson *> *selectedFriends;

@end
