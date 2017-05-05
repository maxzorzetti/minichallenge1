//
//  SAFriendCollectionViewCell.m
//  SportsApp
//
//  Created by Max Zorzetti on 02/05/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "SAFriendCollectionViewCell.h"

@implementation SAFriendCollectionViewCell

- (void)awakeFromNib {
	[super awakeFromNib];
	
    
    
    if (self.profilePictureImageView) {
        // Making it circular!
        self.profilePictureImageView.layer.cornerRadius = self.profilePictureImageView.frame.size.height/2;
        self.profilePictureImageView.layer.masksToBounds = YES;
        self.profilePictureImageView.layer.borderWidth = 0;
    }
    if (self.profileImageBruno) {
        // Making it circular!
        self.profileImageBruno.layer.cornerRadius = self.profileImageBruno.frame.size.height/2;
        self.profileImageBruno.layer.masksToBounds = YES;
        self.profileImageBruno.layer.borderWidth = 0;

    }
	
}

@end
