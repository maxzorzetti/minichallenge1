//
//  SAActivityCollectionViewCell.m
//  SportsApp
//
//  Created by Max Zorzetti on 27/04/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "SAActivityCollectionViewCell.h"
#import "SAActivity.h"

@interface SAActivityCollectionViewCell ()

@end

@implementation SAActivityCollectionViewCell

- (void)configureWithActivity:(SAActivity *)activity{
	self.title.text = activity.name;
	self.icon.image = [UIImage imageNamed:@"ic_favorite"];//activity.icon;
}

@end
