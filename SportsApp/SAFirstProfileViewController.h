//
//  SAFirstProfileViewController.h
//  SportsApp
//
//  Created by Bharbara Cechin on 25/04/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SAPerson;

@interface SAFirstProfileViewController : UIViewController


@property NSString *email;
@property NSString *password;

@property (nonatomic) SAPerson *user;





//- (NSString *)sha1:(NSString *)password;
@end
