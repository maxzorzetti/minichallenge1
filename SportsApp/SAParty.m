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

- (instancetype)init
{
	self = [super init];
	if (self) {
		_shift = SANoShift;
		_peopleType = SANoPeopleType;
		_gender = SANoGender;
		_invitedPeople = [NSMutableSet new];
	}
	return self;
}

- (instancetype) initWithPeople:(NSSet *)people dates:(NSSet<NSDate *> *)dates activity:(SAActivity *)activity  maxParticipants:(int)maxParticipants AndminParticipants:(int)minParticipants{
    self = [super init];
    if (self) {
        _privatePeople = [[NSMutableSet alloc]initWithSet:people];
        _maxParticipants = maxParticipants;
        _minParticipants = minParticipants;
        _activity = activity;
        _dates = dates;
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

- (id)copyWithZone:(NSZone *)zone {
	SAParty *newParty = [SAParty new];
	
//	@property (nonatomic, readonly) NSUUID *partyId;
//	@property (nonatomic, readonly) NSSet *people;
//	@property (nonatomic) int maxParticipants, minParticipants;
//	@property (nonatomic) NSSet<NSDate *> *dates;
//	
//	@property (nonatomic) SAPerson *creator;
//	@property (nonatomic) SAActivity *activity;
//	@property (nonatomic) NSString *schedule;
//	@property (nonatomic) SAShift shift;
//	@property (nonatomic) SAPeopleType peopleType;
//	@property (nonatomic) NSSet<SAPerson *> *invitedPeople;
//	@property (nonatomic) NSNumber *locationRadius;
//	@property (nonatomic) SAGender gender;
	
	//newParty.people = [self.people copy];
	newParty.creator = self.creator;
	newParty.activity = self.activity;
	newParty.schedule = [self.schedule copyWithZone:zone];
	newParty.shift = self.shift;
	newParty.peopleType = self.peopleType;
	newParty.invitedPeople = self.invitedPeople;
	newParty.locationRadius = [self.locationRadius copyWithZone:zone];
	newParty.gender = self.gender;
	newParty.eventName = [self.eventName copy];
	newParty.minParticipants = self.minParticipants;
	newParty.maxParticipants = self.maxParticipants;
	
	return newParty;
}

@end
