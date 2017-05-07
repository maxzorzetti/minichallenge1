//
//  SAEventDescriptionViewController.h
//  SportsApp
//
//  Created by Laura Corssac on 02/05/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SAEvent.h"
#import "SAPerson.h"
#import "SAActivity.h"
#import "SAEventConnector.h"


@interface SAEventDescriptionViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>


@property (weak, nonatomic) IBOutlet UIImageView *eventImage;

@property (weak, nonatomic) IBOutlet UILabel *ownerName;

@property (weak, nonatomic) IBOutlet UIImageView *ownerPhoto;

@property (weak, nonatomic) IBOutlet UILabel *eventName;

@property (weak, nonatomic) IBOutlet UILabel *eventDate;

@property (weak, nonatomic) IBOutlet UILabel *eventLocation;

@property (weak, nonatomic) IBOutlet UILabel *eventGender;
@property (weak, nonatomic) IBOutlet UILabel *eventCapacity;

@property (weak, nonatomic) IBOutlet UILabel *shiftLabel;

@property (weak, nonatomic) IBOutlet UIImageView *genderIcon;

@property (weak, nonatomic) IBOutlet UIButton *joinButton;

@property SAEvent *currentEvent;

@property (weak, nonatomic) IBOutlet UIView *mainView;

@property (weak, nonatomic) IBOutlet UIView *progressBar;

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@end
