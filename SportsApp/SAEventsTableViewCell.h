
//  SAEventsTableViewCell.h
//  SportsApp
//
//  Created by Bruno Scheltzke on 27/04/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SAEvent;

@interface SAEventsTableViewCell : UITableViewCell

@property (nonatomic) SAEvent *event;

@property (weak, nonatomic) IBOutlet UILabel *eventName;

@end
