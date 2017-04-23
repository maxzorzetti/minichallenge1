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

+ (void)enterMatchmakingWithParty:(SAParty *)party{
    [SAMatchMakerCore registerParty:party];
}

+ (void)leaveMatchmakingWithParty:(SAParty *)party{
	
}

@end
