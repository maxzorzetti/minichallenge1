//
//  Matchmaker.h
//  SportsApp
//
//  Created by Max Zorzetti on 19/04/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SAParty;
@class SAEvent;

@interface SAMatchmaker : NSObject

+ (void)enterMatchmakingWithParty:(SAParty *)party handler:(void (^)(SAEvent * _Nullable event, NSError * _Nullable error))handler;

+ (void)leaveMatchmakingWithParty:(SAParty *)party;

@end
