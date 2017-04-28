//
//  SANewsFeedTableViewController.h
//  SportsApp
//
//  Created by Laura Corssac on 27/04/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ConverteArrayCallback)(NSArray *coordinates);
@interface SANewsFeedTableViewController : UITableViewController
- (void)userFriendsFacebookIds:(NSString *)userFacebookid callback:(ConverteArrayCallback) callback;
@end
