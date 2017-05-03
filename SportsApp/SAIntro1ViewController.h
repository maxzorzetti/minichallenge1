//
//  SAIntro1ViewController.h
//  SportsApp
//
//  Created by Bharbara Cechin on 01/05/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SAIntro1ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *txtTitle;
@property (weak, nonatomic) IBOutlet UILabel *txtSubtitle;
@property (weak, nonatomic) IBOutlet UIButton *btnSignUp;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;

@property NSUInteger pageNumber;
@property NSString *imageFile;
@property NSString *titleText;
@property NSString *subtitleText;

- (IBAction)actionSignUp:(id)sender;

- (IBAction)actionLogin:(id)sender;

@end
