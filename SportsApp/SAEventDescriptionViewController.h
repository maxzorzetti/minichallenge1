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


@interface SAEventDescriptionViewController : UIViewController


@property (weak, nonatomic) IBOutlet UIImageView *eventImage;

@property (weak, nonatomic) IBOutlet UILabel *ownerName;


@property (weak, nonatomic) IBOutlet UIImageView *ownerPhoto;

@property (weak, nonatomic) IBOutlet UILabel *eventName;

@property (weak, nonatomic) IBOutlet UILabel *eventDate;

@property (weak, nonatomic) IBOutlet UILabel *eventLocation;

@property (weak, nonatomic) IBOutlet UILabel *eventGender;
@property (weak, nonatomic) IBOutlet UILabel *eventNumberParticipants;

@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@property (weak, nonatomic) IBOutlet UIButton *joinButton;

@property SAEvent *currentEvent;

@property (weak, nonatomic) IBOutlet UIView *mainView;


@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@end
