//
//  Matchmaker.m
//  SportsApp
//
//  Created by Max Zorzetti on 19/04/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "SAMatchmaker.h"
#import <CloudKit/CloudKit.h>
#import "SAParty.h"
#import "SAPerson.h"
#import "SAMatchMakerCore.h"

@implementation SAMatchmaker

+ (void)enterMatchmakingWithParty:(SAParty *)party{
    [SAMatchMakerCore registerPary:party];
}

+ (void)leaveMatchmakingWithParty:(SAParty *)party{
	
}

@end
