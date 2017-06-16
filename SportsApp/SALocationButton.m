//
//  UILocationButton.m
//  SportsApp
//
//  Created by Max Zorzetti on 14/06/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "SALocationButton.h"

@interface SALocationButton ()

//@property (nonatomic) UIView* background;
//@property (nonatomic) BOOL toggled;

@property (nonatomic) UIColor* deselectedColor;
@property (nonatomic) UIColor* selectedColor;

@end

@implementation SALocationButton

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		_deselectedColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
		_selectedColor = [UIColor colorWithRed:216.0/255 green:216.0/255 blue:216.0/255 alpha:1];

		self.layer.masksToBounds = YES;
	}
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		//_background = [[UIView alloc] initWithFrame:self.frame];
		//_background.layer.cornerRadius = self.bounds.size.height/2;
		//_background.layer.masksToBounds = YES;
		
		_deselectedColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
		_selectedColor = [UIColor colorWithRed:216.0/255 green:216.0/255 blue:216.0/255 alpha:1];
		
		//_toggled = NO;
		
		//self.layer.cornerRadius = self.bounds.size.width/2;
		self.layer.masksToBounds = YES;
		self.layer.borderColor = [[UIColor colorWithRed:50.0/255 green:226.0/255 blue:196.0/255 alpha:1] CGColor];
	}
	return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
	self.layer.borderWidth = 1;
	self.layer.cornerRadius = self.bounds.size.width/2;
	
}

- (void)setSelected:(BOOL)selected {
	[super setSelected:selected];
	/*
	if (selected) {
		self.backgroundColor = self.selectedColor;
		self.layer.borderColor = [[UIColor colorWithRed:50.0/255 green:226.0/255 blue:196.0/255 alpha:0.2] CGColor];
	} else {
		self.backgroundColor = self.deselectedColor;
		self.layer.borderColor = [[UIColor colorWithRed:50.0/255 green:226.0/255 blue:196.0/255 alpha:1] CGColor];
	}*/
}

// Make it so that only the circle is clickable, not the whole view.
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
	CGFloat radius = self.bounds.size.height / 2;
	//
	CGFloat x = radius - point.x;
	CGFloat y = radius - point.y;
	//
	if (x*x + y*y < radius*radius)
		return [super pointInside:point withEvent:event];
	else
		return NO;
}

//- (void)layoutSubviews {
//	
//}

@end
