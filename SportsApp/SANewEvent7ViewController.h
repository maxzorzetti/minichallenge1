//
//  SANewEvent7ViewController.h
//  SportsApp
//
//  Created by Max Zorzetti on 12/05/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import "SAParty.h"

@interface SANewEvent7ViewController : UIViewController <CLLocationManagerDelegate>

@property (nonatomic) SAParty *party;

@end
