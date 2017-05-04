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

@property (weak, nonatomic) IBOutlet UIView *myView;

@property (weak, nonatomic) IBOutlet UIImageView *ownerProfilePicture;

@property (weak, nonatomic) IBOutlet UILabel *ownerName;

@property (weak, nonatomic) IBOutlet UILabel *eventStatus;
@property (weak, nonatomic) IBOutlet UIImageView *eventImage;


@property (weak, nonatomic) IBOutlet UILabel *eventDate;

@property (weak, nonatomic) IBOutlet UITextField *eventName;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@end
