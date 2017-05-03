//
//  SAFriendCollectionViewCell.m
//  SportsApp
//
//  Created by Max Zorzetti on 02/05/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "SAFriendCollectionViewCell.h"

@implementation SAFriendCollectionViewCell

- (instancetype)init
{
	self = [super init];
	if (self) {
		self.profilePictureImageView.layer.cornerRadius = self.profilePictureImageView.frame.size.height/2;
		self.profilePictureImageView.layer.masksToBounds = YES;
		self.profilePictureImageView.layer.borderWidth = 0;
	}
	return self;
}

@end
