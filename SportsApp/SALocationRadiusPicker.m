//
//  SALocationRadiusPicker.m
//  SportsApp
//
//  Created by Max Zorzetti on 16/06/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "SALocationRadiusPicker.h"
#import "SALocationButton.h"

@interface SALocationRadiusPicker ()

@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet SALocationButton *outerCircle;
@property (weak, nonatomic) IBOutlet SALocationButton *middleCircle;
@property (weak, nonatomic) IBOutlet SALocationButton *innerCircle;

@property (weak, nonatomic) IBOutlet UILabel *innerLabel;
@property (weak, nonatomic) IBOutlet UILabel *middleLabel;
@property (weak, nonatomic) IBOutlet UILabel *outerLabel;

@property (nonatomic) UIColor* deselectedColor;
@property (nonatomic) UIColor* selectedColor;
@property (nonatomic) UIColor* selectedBorderColor;
@property (nonatomic) UIColor* deselectedBorderColor;

@end

@implementation SALocationRadiusPicker

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		[self customInit];
	}
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self customInit];
	}
	return self;
}

- (void)customInit {
	NSBundle *bundle = [NSBundle mainBundle];
	UINib *nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle: bundle];
	self.view = [nib instantiateWithOwner:self options:nil][0];
	
	[self addSubview: self.view];
	self.view.frame = self.bounds;
	
	_deselectedColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
	//_selectedColor = [UIColor colorWithRed:216.0/255 green:216.0/255 blue:216.0/255 alpha:0.2];
	_selectedColor = [UIColor colorWithRed:119.0/255 green:90.0/255 blue:218.0/255 alpha:0.2];
	
	_deselectedBorderColor = [UIColor colorWithRed:119.0/255 green:90.0/255 blue:218.0/255 alpha:0.2];
	_selectedBorderColor = [UIColor colorWithRed:119.0/255 green:90.0/255 blue:218.0/255 alpha:0];

	[self circleTouchedUpInside: self.innerCircle];
}

- (double)selectedRadius {
	if (self.outerCircle.selected) return 20;
	if (self.middleCircle.selected) return 10;
	if (self.innerCircle.selected) return 5;
	return -1;
}

- (IBAction)circleTouchedUpInside:(UIButton *)sender {
	self.outerCircle.selected = NO;
	self.middleCircle.selected = NO;
	self.innerCircle.selected = NO;
	
	self.outerLabel.hidden = YES;
	self.middleLabel.hidden = YES;
	self.innerLabel.hidden = YES;
	
	sender.selected = YES;
	
	// Pig oriented programming - yoink yoink
	if (sender == self.outerCircle) {
		[self selectCircle: self.outerCircle];
		[self selectCircle: self.middleCircle];
		[self selectCircle: self.innerCircle];
		
		self.outerLabel.hidden = NO;
	} else if (sender == self.middleCircle) {
		[self deselectCircle: self.outerCircle];
		[self selectCircle: self.middleCircle];
		[self selectCircle: self.innerCircle];
		
		self.middleLabel.hidden = NO;
	} else if (sender == self.innerCircle) {
		[self deselectCircle: self.outerCircle];
		[self deselectCircle: self.middleCircle];
		[self selectCircle: self.innerCircle];
		
		self.innerLabel.hidden = NO;
	}
	
	sender.layer.borderColor = [[UIColor colorWithRed:119.0/255 green:90.0/255 blue:218.0/255 alpha:1] CGColor];
}

- (void)selectCircle:(SALocationButton *)circle {
	circle.backgroundColor = self.selectedColor;
	circle.layer.borderColor = [self.selectedBorderColor CGColor];
}

- (void)deselectCircle:(SALocationButton *)circle {
	circle.backgroundColor = self.deselectedColor;
	circle.layer.borderColor = [self.deselectedBorderColor CGColor];
}

@end
