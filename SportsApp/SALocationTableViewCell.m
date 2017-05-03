//
//  SALocationTableViewCell.m
//  SportsApp
//
//  Created by Max Zorzetti on 02/05/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "SALocationTableViewCell.h"

@implementation SALocationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
	if (selected) {
		[UIView animateWithDuration:1 animations:^{
			[self.selectionImageView setTransform:CGAffineTransformMakeRotation(M_PI/4)];
		} completion:^(BOOL finished) {
			//self.selectionImageView.image = [UIImage imageNamed:@"ic_tableCellRemove"];
		}];
		//self.selectionImageView.image = ;
	} else {
		self.selectionImageView.image = [UIImage imageNamed:@"ic_tableCellAdd"];
	}
}

@end
