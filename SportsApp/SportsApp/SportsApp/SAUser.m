//
//  SAUser.m
//  SportsApp
//
//  Created by Max Zorzetti on 22/04/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "SAUser.h"

@implementation SAUser

+ (instancetype)currentUser {
	static SAUser *sharedInstance = nil;
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken, ^{
		sharedInstance = [[SAUser alloc] init];
	});
	return sharedInstance;
}

- (id)init {
	if ( (self = [super init]) ) {
		// your custom initialization
	}
	return self;
}

- (void)setPreferredActivity:(SAActivity *)activity {
	// TODO NSUserDefaults something
}

- (id)copyWithZone:(NSZone *)zone {
	return self;
}

@end
