//
//  SAMatchMakerCore.h
//  SportsApp
//
//  Created by Bruno Scheltzke on 2017-04-23.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SAParty;
@class SAEvent;

@interface SAMatchMakerCore : NSObject

- (void)startMatchmakingForParty:(SAParty *_Nonnull)party handler:(void (^_Nonnull)(SAEvent * _Nullable event, NSError * _Nullable error))handler ;
+ (void)registerParty:(SAParty *)party;
+ (void)removeParty:(SAParty *)party;

@end
