//
//  SAFriendTableViewCell.m
//  
//
//  Created by Max Zorzetti on 02/05/17.
//
//

#import "SAFriendTableViewCell.h"

@implementation SAFriendTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

	self.profilePictureImageView.layer.cornerRadius = self.profilePictureImageView.frame.size.height/2;
	self.profilePictureImageView.layer.masksToBounds = YES;
	self.profilePictureImageView.layer.borderWidth = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
	if (selected) {
		[UIView animateWithDuration:0.2 animations:^{
			//[self.selectionImageView setTransform:CGAffineTransformMakeRotation(M_PI_4)];
		} completion:^(BOOL finished) {
			self.selectionImageView.image = [UIImage imageNamed:@"ic_tableCellRemove"];
		}];
	} else {
		[UIView animateWithDuration:0.2 animations:^{
			//[self.selectionImageView setTransform:CGAffineTransformMakeRotation(-M_PI_4)];
		} completion:^(BOOL finished) {
			self.selectionImageView.image = [UIImage imageNamed:@"ic_tableCellAdd"];
		}];
	}
}

@end
