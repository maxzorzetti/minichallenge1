//
//  SAParty.m
//  SportsApp
//
//  Created by Max Zorzetti on 19/04/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "SAParty.h"
#import "SAPerson.h"
#import <CloudKit/CloudKit.h>

@interface SAParty()
@property (nonatomic) NSMutableSet *privatePeople;
@end

@implementation SAParty


- (instancetype) initWithPeople:(NSSet *)people date:(NSDate *)date activity:(SAActivity *)activity  maxParticipants:(int)maxParticipants AndminParticipants:(int)minParticipants{
    self = [super init];
    if (self) {
        _privatePeople = [[NSMutableSet alloc]initWithSet:people];
        _maxParticipants = maxParticipants;
        _minParticipants = minParticipants;
        _activity = activity;
        _date = date;
    }
    return self;
}

- (void)addPerson:(SAPerson *)person{
    [self.privatePeople addObject:person];
}

- (void)removePerson:(SAPerson *)person{
	[self.privatePeople removeObject:person];
}

- (NSSet *)people{
    return [self.privatePeople copy];
}

@end
