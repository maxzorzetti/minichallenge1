//
//  SANewEvent3ViewController.h
//  SportsApp
//
//  Created by Max Zorzetti on 27/04/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SAActivity.h"

@interface SANewEvent3ViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic) SAActivity *selectedActivity;

@property (nonatomic) NSString *selectedSchedule;

@end
