//
//  Matchmaker.m
//  SportsApp
//
//  Created by Max Zorzetti on 19/04/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import <CloudKit/CloudKit.h>
#import "SAMatchmaker.h"
#import "SAMatchMakerCore.h"
#import "SAPerson.h"
#import "SAParty.h"

@implementation SAMatchmaker

+ (void)enterMatchmakingWithParty:(SAParty *)party handler:(void (^)(SAEvent * _Nullable event, NSError * _Nullable error))handler {
	SAMatchMakerCore *core = [SAMatchMakerCore new];
	
	[core startMatchmakingForParty:party handler:handler];
}

+ (void)leaveMatchmakingWithParty:(SAParty *)party{
	
}

@end
