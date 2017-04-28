//
//  SANewsFeedTableViewCell.h
//  SportsApp
//
//  Created by Laura Corssac on 27/04/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SAEvent.h"

@interface SANewsFeedTableViewCell : UITableViewCell


@property SAEvent *cellEvent;
- (void)initWithEvent:(SAEvent *)cellEvent;

@end
