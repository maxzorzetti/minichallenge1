//
//  SAShiftCollectionViewCell.m
//  SportsApp
//
//  Created by Max Zorzetti on 03/05/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "SAShiftCollectionViewCell.h"

@implementation SAShiftCollectionViewCell

- (void)setSelected:(BOOL)selected {
	if (selected) {
		self.shiftLabel.textColor = [UIColor colorWithRed:119/255.0 green:90/255.0 blue:218/255.0 alpha:1];
	} else {
		self.shiftLabel.textColor = [UIColor colorWithRed:35/255.0 green:31/255.0 blue:32/255.0 alpha:1];
	}
}

@end
