//
//  SACollectionButtonViewCell.m
//  SportsApp
//
//  Created by Bharbara Cechin on 28/04/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "SACollectionButtonViewCell.h"

@implementation SACollectionButtonViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
	
	self.bgView.layer.cornerRadius = 3.6;
	self.bgView.layer.masksToBounds = YES;
	self.bgView.layer.borderWidth = 0;
}

- (void)setSelected:(BOOL)selected {
	if (selected) {
		self.bgView.backgroundColor = [UIColor colorWithRed:119/255.0 green:90/255.0 blue:218/255.0 alpha:1];
		self.titleLabel.textColor = [UIColor whiteColor];
	} else {
		self.bgView.backgroundColor = [UIColor clearColor];
		self.titleLabel.textColor = [UIColor colorWithRed:35/255.0 green:31/255.0 blue:32/255.0 alpha:1];
	}
}

@end
