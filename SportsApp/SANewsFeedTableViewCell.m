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

@implementation SANewsFeedTableViewCell



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}



- (void)initWithEvent:(SAEvent *)cellEvent
{
    /*
    // corner radius
    _myView.layer.cornerRadius = 10;
    
    // border
    _myView.layer.borderWidth = 0.01;
    _myView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    // shadow
    
    _myView.layer.shadowOffset = CGSizeMake(5, 5);
    _myView.layer.shadowOpacity = 0.7;
    _myView.layer.shadowRadius = 11.0;
    //[_myView.layer setShadowColor:[UIColor colorWithRed:217 green:226 blue:233 alpha:0.5].CGColor];
    _myView.layer.shadowColor = [UIColor blackColor].CGColor;
    _myView.layer.masksToBounds = YES;*/
    
    //_myView.borderStyle = none;
    _myView.layer.masksToBounds = FALSE;
    _myView.layer.cornerRadius = 5.0;
    _myView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    _myView.layer.borderColor = [UIColor clearColor].CGColor;
    _myView.layer.shadowColor = [UIColor blackColor ].CGColor;
    _myView.layer.shadowOffset = CGSizeMake(0.0, 5.0);
    _myView.layer.shadowOpacity = 0.2;
    _myView.layer.shadowRadius = 11.0;
    
    
    
    _cellEvent = cellEvent;
    _eventName.text = _cellEvent.name;
    _ownerName.text = _cellEvent.owner.name;
    _eventDate.text = [NSString stringWithFormat:@"%@",_cellEvent.date];
    
    
    
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:@"/_cellEvent.owner.facebookId"
                                  parameters:@{ @"fields": @"name, picture, friends",}
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        
        if (!error)
        {

            NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:[[[result objectForKey:@"picture"]objectForKey:@"data"]objectForKey:@"url"]]];
            _ownerProfilePicture.image = [UIImage imageWithData: imageData];
        }}];

}



@end
