//
//  SANewsFeedTableViewCell.m
//  SportsApp
//
//  Created by Laura Corssac on 27/04/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "SANewsFeedTableViewCell.h"
#import "SAPerson.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "SAActivity.h"
#import "SAActivityConnector.h"
#import "SAPersonConnector.h"

@implementation SANewsFeedTableViewCell



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}



- (void)initWithEvent:(SAEvent *)event
{
    
    _myView.layer.masksToBounds = FALSE;
    _myView.layer.cornerRadius = 5.0;
    _myView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    _myView.layer.borderColor = [UIColor clearColor].CGColor;
    UIColor *grayish = [UIColor colorWithRed:217.0/255.0 green:226.0/255.0 blue:233.0/255.0 alpha:0.5];
    _myView.layer.shadowColor = grayish.CGColor;
    //_myView.layer.shadowColor = [UIColor colorWithRed:217 green:226 blue:233 alpha:0.5 ].CGColor;
    _myView.layer.shadowOffset = CGSizeMake(0.0, 5.0);
    _myView.layer.shadowOpacity = 1.0;
    _myView.layer.shadowRadius = 11.0;
    
    self.cellEvent = event;
    
    self.ownerProfilePicture.layer.cornerRadius = self.ownerProfilePicture.frame.size.height /2;
    self.ownerProfilePicture.layer.masksToBounds = YES;
    self.ownerProfilePicture.layer.borderWidth = 0;
    
    
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    self.eventDate.text= [dateFormat stringFromDate:event.date];
    
    self.eventName.text = event.name;
    self.ownerName.text = event.owner.name;
    //self.eventDate.text = [NSString stringWithFormat:@"%@",event.date];
    
    
    self.eventImage.image = [UIImage imageWithData:event.activity.picture];
    
    if (event.owner.photo==nil) {
        self.ownerProfilePicture.image = [UIImage imageNamed:@"img_placeholder.png"];
    }else{
        self.ownerProfilePicture.image = [UIImage imageWithData:event.owner.photo];
    }
    
    //case activity was not already loaded from the userdefaults, download from db and save to userdefaults
    
    if ([event.activity.name length]==0) {
        [SAActivityConnector getActivityById:event.activity.activityId handler:^(SAActivity * _Nullable activity, NSError * _Nullable error) {
            if (!error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.eventImage.image = [UIImage imageWithData:activity.picture];
                });
                
                [event setActivity:activity];
                [SAActivity saveToUserDefaults:activity];
            }
        }];
    }
    
//    //case owner was not already loaded from the userdefaults, download from db and save to userdefaults (actually decide if person will be stored in userdefaults)
    if ([event.owner.name length] == 0) {
        [SAPersonConnector getPersonFromId:event.owner.personId handler:^(SAPerson * _Nullable owner, NSError * _Nullable error) {
            if (!error && owner) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (owner.photo==nil) {
                        self.ownerProfilePicture.image = [UIImage imageNamed:@"img_placeholder.png"];
                    }else{
                        self.ownerProfilePicture.image = [UIImage imageWithData:owner.photo];
                    }
                    self.ownerName.text = owner.name;
                });
                
                [event setOwner:owner];
                [SAPerson saveToUserDefaults:owner];
                
            }
            else{
                NSLog(@"%@", error.description);
            }
        }];
    }

}



@end
