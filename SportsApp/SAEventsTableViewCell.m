//
//  SAEventsTableViewCell.m
//  SportsApp
//
//  Created by Bruno Scheltzke on 27/04/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "SAEventsTableViewCell.h"
#import "SAEvent.h"

@implementation SAEventsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setEvent:(SAEvent *)event{
    _event = event;
    
    self.eventName.text = event.name;
}

@end