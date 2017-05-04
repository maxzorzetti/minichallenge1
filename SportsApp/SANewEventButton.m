//
//  SANewEventButton.m
//  SportsApp
//
//  Created by Max Zorzetti on 04/05/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "SANewEventButton.h"

@implementation SANewEventButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setEnabled:(BOOL)enabled {
	[super setEnabled:enabled];
	if (enabled) {
		self.backgroundColor = self.backgroundColor = [UIColor colorWithRed:119/255.0 green:90/255.0 blue:218/255.0 alpha:1];
	} else {
		self.backgroundColor = self.backgroundColor = [UIColor colorWithRed:201/255.0 green:189/255.0 blue:240/255.0 alpha:1];
	}
	
}

@end
