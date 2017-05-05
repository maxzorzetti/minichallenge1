//
//  SAAskPhoneViewController.h
//  SportsApp
//
//  Created by Laura Corssac on 04/05/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CloudKit/CloudKit.h>
@interface SAAskPhoneViewController : UIViewController <UITextFieldDelegate>
@property CKRecord *personRecord;
@end
