//
//  SANewsFeedTableViewController.h
//  SportsApp
//
//  Created by Laura Corssac on 27/04/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SANewsFeedTableViewCell.h"
#import <CoreLocation/CoreLocation.h>

@interface SANewsFeedTableViewController : UITableViewController <CLLocationManagerDelegate, UIViewControllerPreviewingDelegate>

-(void) updateEventsWithUserDefaults;

@end
