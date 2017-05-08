//
//  Event.m
//  SportsApp
//
//  Created by Bruno Scheltzke on 2017-04-19.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "SAEvent.h"
#import <CloudKit/CloudKit.h>
#import "SAPerson.h"
#import "SAActivity.h"
@class SAPerson;

@interface SAEvent ()
@property (nonatomic) NSMutableArray<SAPerson *> *privateParticipants;
@end

@implementation SAEvent

- (instancetype)init
{
	self = [super init];
	if (self) {
		_eventId = nil;
		_name = nil;
		_minPeople = nil;
		_maxPeople = nil;
		_activity = nil;
		_privateParticipants = [NSMutableArray new];
		_category = nil;
		_shift = nil;
		_sex = nil;
		_date = nil;
		_owner = nil;
		_location = nil;
		_distance = nil;
	}
	return self;
}

- (instancetype)initWithName:(NSString *)name andRequiredParticipants:(NSNumber *)requiredParticipants andMaxParticipants:(NSNumber *)maxParticipants andActivity:(SAActivity *)activity andId:(CKRecordID *)eventId andCategory:(NSString *)category andSex:(NSString *)sex andDate:(NSDate *)date andParticipants:(NSArray<SAPerson *> *)participants andLocation:(CLLocation *)location andDistance:(NSNumber *)distance
{
    self = [super init];
    if (self) {
        _name = name;
        _minPeople = requiredParticipants;
        _maxPeople = maxParticipants;
        _activity = activity;
        _eventId = eventId;
        _category = category;
        _sex = sex;
        _date = date;
        _location = location;
        _distance = distance;
        _privateParticipants = [NSMutableArray arrayWithArray:participants];
    }
    return self;
}

- (NSSet<SAPerson *> *)participants {
	NSSet* participants = [[NSSet alloc] initWithArray:self.privateParticipants];
	return [participants copy];
}

- (void)addParticipant:(SAPerson *)person{
    [self.privateParticipants addObject:person];
}

- (void)addParticipants:(NSArray *)participants{
	for (SAPerson *person in participants) {
        [self.privateParticipants addObject:person];
	}
}

- (void)replaceParticipants:(NSArray<SAPerson *>*)participants{
    [self.privateParticipants setArray:participants];
}

- (void)removeParticipant:(SAPerson *)person{
    SAPerson *personToRemove;
    for (SAPerson *participant in self.privateParticipants) {
        if ([participant.personId.recordName isEqualToString:person.personId.recordName]) {
            personToRemove = participant;
        }
    }
    
    [self.privateParticipants removeObject:personToRemove];
}

- (NSString *)getParticipantRole:(SAPerson *)person{
    return nil;
}

- (NSString *)description {
	return [[NSString alloc] initWithFormat:@"%@ %@ %@", self.name, self.activity.name, self.owner];
}

@end
