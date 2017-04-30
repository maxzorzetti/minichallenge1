//
//  SANewEvent1ViewController.h
//  SportsApp
//
//  Created by Max Zorzetti on 27/04/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SAActivity.h"

@interface SANewEvent1ViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

+ (UIColor *)preferenceColor;

- (NSMutableAttributedString *)processPreferencesTextWithActivity:(SAActivity *)activity schedule:(NSString *)schedule people:(NSString *)people location:(NSString *)location ;

@end
