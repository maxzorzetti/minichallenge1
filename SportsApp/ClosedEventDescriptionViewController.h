//
//  ClosedEventDescriptionViewController.h
//  SportsApp
//
//  Created by Bruno Scheltzke on 03/05/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SAEvent;

@interface ClosedEventDescriptionViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) SAEvent *event;

@property (weak, nonatomic) IBOutlet UILabel *eventName;

@property (weak, nonatomic) IBOutlet UIImageView *activityIcon;

@property (weak, nonatomic) IBOutlet UIView *toBorderView;

@end
