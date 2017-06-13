//
//  SAFirstProfileViewController.h
//  SportsApp
//
//  Created by Bharbara Cechin on 25/04/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SAPerson;

@interface SAFirstProfileViewController : UIViewController <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>


@property NSString *email;
@property NSString *password;
@property NSString *previousView;
@property (nonatomic) SAPerson *user;





//- (NSString *)sha1:(NSString *)password;
@end
