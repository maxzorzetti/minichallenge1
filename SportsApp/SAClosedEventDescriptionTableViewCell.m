//
//  SAClosedEventDescriptionTableViewCell.m
//  SportsApp
//
//  Created by Bruno Scheltzke on 03/05/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SAClosedEventDescriptionTableViewCell.h"
#import "SAPerson.h"

@implementation SAClosedEventDescriptionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setParticipant:(SAPerson *)participant{
    _participant = participant;
    
    
    self.participantPicture.layer.cornerRadius = self.participantPicture.frame.size.height/2;
    self.participantPicture.layer.masksToBounds = YES;
    self.participantPicture.layer.borderWidth = 0;
    
    self.participantName.text = participant.name;
    if (participant.photo) {
        self.participantPicture.image = [UIImage imageWithData:participant.photo];
    }else{
        self.participantPicture.image = [UIImage imageNamed:@"img_placeholder"];
    }
    self.participantPhoneNumber.text = participant.telephone;
}

@end
