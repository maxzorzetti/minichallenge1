//
//  Matchmaker.h
//  SportsApp
//
//  Created by Max Zorzetti on 19/04/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SAParty;

@interface SAMatchmaker : NSObject

+ (void)enterMatchmakingWithParty:(SAParty *)party;

+ (void)leaveMatchmakingWithParty:(SAParty *)party;

@end
