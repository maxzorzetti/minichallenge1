//
//  SACollectionButtonViewCell.h
//  SportsApp
//
//  Created by Bharbara Cechin on 28/04/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SACollectionButtonViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (nonatomic) UIImage *selectedImage;
@property (nonatomic) UIImage *unselectedImage;

- (void)setCustomSelection:(BOOL)selected;

@end
