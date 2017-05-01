//
//  SANewsFeedTableViewController.h
//  SportsApp
//
//  Created by Laura Corssac on 27/04/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SANewsFeedTableViewCell.h"

@interface SANewsFeedTableViewController : UITableViewController
- (void)updateTableWithEventList:(NSArray<SAEvent *>*)events AndArray:(NSMutableArray *)array;

@end
