//
//  SAInterestsCollectionViewController.h
//  SportsApp
//
//  Created by Bharbara Cechin on 28/04/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SACollectionButtonViewCell.h"
@class SAPerson;

@interface SAInterestsCollectionViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>

@property NSString *email;
@property SAPerson *user;
@property NSString *previousView;
@end
