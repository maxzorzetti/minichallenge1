//
//  SAUser.h
//  SportsApp
//
//  Created by Max Zorzetti on 22/04/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SAPerson;
@class SAActivity;

@interface SAUser : NSObject

@property (nonatomic) SAPerson *person;

+ (SAUser *)currentUser;

- (void)loginWithCompletionHandler:(void (^_Nonnull)(int))handler;

-(void)setCurrentPerson:(SAPerson *)person;

- (void)setPreferredActivity:(SAActivity *) activity;

+ (void)saveToUserDefaults:(SAPerson *) person;


@end
