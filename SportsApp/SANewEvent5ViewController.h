//
//  SANewEvent5ViewController.h
//  SportsApp
//
//  Created by Max Zorzetti on 02/05/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SAActivity.h"
#import "SAPerson.h"
#import "SAParty.h"

@interface SANewEvent5ViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate>

@property (nonatomic) SAParty *party;

@end
