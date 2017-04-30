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

- (instancetype)init
{
	self = [super init];
	if (self) {
		self.layer.borderWidth = 5.0;
	}
	return self;
}

- (void)configureWithActivity:(SAActivity *)activity{
	self.title.text = activity.name;
	self.icon.image = [UIImage imageNamed:@"ic_favorite"];//activity.icon;
}

- (void)setSelected:(BOOL)selected {
	super.selected = selected;
	
	UIColor *color;
	
	if (selected) color = [UIColor redColor];
	else color = [UIColor clearColor];
	[UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
		self.icon.backgroundColor = color;
	} completion:^(BOOL finished) {
		//
	}];
	/*
	[UIView animateWithDuration:1 animations:^{
		self.layer.borderColor = [[UIColor redColor] CGColor];
		self.layer.borderWidth = 5.0;
	}];*/
	NSLog(@"iojiajiaej");
}

- (void)select:(id)sender {
	NSLog(@"AYYYYYYYYY");
	
}

@end
