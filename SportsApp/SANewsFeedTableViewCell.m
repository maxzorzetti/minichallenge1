//
//  SANewsFeedTableViewCell.m
//  SportsApp
//
//  Created by Laura Corssac on 27/04/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "SANewsFeedTableViewCell.h"

@implementation SANewsFeedTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}



- (void)initWithEvent:(SAEvent *)cellEvent
{
    _cellEvent = cellEvent;
    
}


@end
