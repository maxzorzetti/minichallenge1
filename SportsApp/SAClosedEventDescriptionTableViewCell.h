//
//  SAClosedEventDescriptionTableViewCell.h
//  SportsApp
//
//  Created by Bruno Scheltzke on 03/05/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SAPerson;

@interface SAClosedEventDescriptionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *participantPicture;
@property (weak, nonatomic) IBOutlet UILabel *participantName;
@property (weak, nonatomic) IBOutlet UILabel *participantPhoneNumber;

@property (nonatomic) SAPerson *participant;

@end
