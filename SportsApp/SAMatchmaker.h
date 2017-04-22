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

+ (void)enterMatchMakingWithParty:(SAParty *)party;

@end
