//
//  SAActivityCollectionViewCell.h
//  SportsApp
//
//  Created by Max Zorzetti on 27/04/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SAActivity;

@interface SAActivityCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *icon;

@property (weak, nonatomic) IBOutlet UITextField *title;

- (void)configureWithActivity:(SAActivity *)activity;

@end
