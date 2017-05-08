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
#import "SAParty.h"
#import <CoreLocation/CoreLocation.h>

@interface SANewEvent4ViewController : UIViewController <CLLocationManagerDelegate>

@property (nonatomic) SAParty *party;
@end
