//
//  SAMatchMakerCore.h
//  SportsApp
//
//  Created by Bruno Scheltzke on 2017-04-23.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SAParty;

@interface SAMatchMakerCore : NSObject

- (void)startMatchmakingForParty:(SAParty *)party;
+ (void)registerParty:(SAParty *)party;
+ (void)removeParty:(SAParty *)party;

@end
