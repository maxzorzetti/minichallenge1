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
@class SAPerson;

@interface SAEvent ()
@property (nonatomic) NSMutableArray<SAPerson *> *privateParticipants;
@end

@implementation SAEvent


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

- (void)removeParticipant:(SAPerson *)person{
    for (SAPerson *participant in self.privateParticipants) {
        if ([participant.personId.recordName isEqualToString:person.personId.recordName]) {
            [self.privateParticipants removeObject:participant];
        }
    }
}

- (NSString *)getParticipantRole:(SAPerson *)person{
    return nil;
}


@end
