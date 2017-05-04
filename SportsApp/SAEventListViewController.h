//
//  SAEventListViewController.h
//  SportsApp
//
//  Created by Bruno Scheltzke on 27/04/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SAEventListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIViewControllerPreviewingDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@end
