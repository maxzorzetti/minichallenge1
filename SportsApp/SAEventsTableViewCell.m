//
//  SAEventsTableViewCell.m
//  SportsApp
//
//  Created by Bruno Scheltzke on 27/04/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "SAEventsTableViewCell.h"
#import "SAEvent.h"
#import "SAActivity.h"
#import "SAActivityConnector.h"
#import "SAPerson.h"
#import "SAPersonConnector.h"

@implementation SAEventsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setEvent:(SAEvent *)event{
    _event = event;
    
    self.eventName.text = event.name;
    self.activityIcon.image = [UIImage imageWithData:event.activity.picture];
    self.activityName.text = event.activity.name;
    self.ownerName.text = event.owner.name;
    if (event.owner.photo==nil) {
        self.ownerPicture.image = [UIImage imageNamed:@"img_placeholder.png"];
    }else{
        self.ownerPicture.image = [UIImage imageWithData:event.owner.photo];
    }
    
    //case activity was not already loaded from the userdefaults, download from db and save to userdefaults
    if ([event.activity.name length]==0) {
        [SAActivityConnector getActivityById:event.activity.activityId handler:^(SAActivity * _Nullable activity, NSError * _Nullable error) {
            if (!error) {
                self.activityIcon.image = [UIImage imageWithData:activity.picture];
                
                [event setActivity:activity];
                [SAActivity saveToUserDefaults:activity];
            }
        }];
    }
    
    //case owner was not already loaded from the userdefaults, download from db and save to userdefaults (actually decide if person will be stored in userdefaults)
    if ([event.owner.name length] == 0) {
        [SAPersonConnector getPersonFromId:event.owner.personId handler:^(SAPerson * _Nullable owner, NSError * _Nullable error) {
            if (!error) {
                [event setOwner:owner];
                [SAPerson saveToUserDefaults:owner];
                
                self.ownerPicture.image = [UIImage imageWithData:owner.photo];
            }
            else{
                NSLog(@"%@", error.description);
            }
        }];
    }
}

@end
