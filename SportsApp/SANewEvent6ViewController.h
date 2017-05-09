//
//  SANewEvent6ViewController.h
//  SportsApp
//
//  Created by Max Zorzetti on 02/05/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SAPerson.h"
#import "SAParty.h"
#import "SAEvent.h"

@interface SANewEvent6ViewController : UIViewController <UICollectionViewDataSource>

@property (nonatomic) SAParty *party;

@property (nonatomic) SAEvent *event;

@end
