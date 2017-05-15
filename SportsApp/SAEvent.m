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

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        _activity = [coder decodeObjectForKey:@"activity"];
        _category = [coder decodeObjectForKey:@"category"];
        _date = [coder decodeObjectForKey:@"date"];
        _distance = [coder decodeObjectForKey:@"distance"];
        _eventId = [coder decodeObjectForKey:@"eventId"];
        _location = [coder decodeObjectForKey:@"location"];
        _maxPeople = [coder decodeObjectForKey:@"maxPeople"];
        _minPeople = [coder decodeObjectForKey:@"minPeople"];
        _name = [coder decodeObjectForKey:@"name"];
        _owner = [coder decodeObjectForKey:@"owner"];
        _privateParticipants = [coder decodeObjectForKey:@"participants"];
        _sex = [coder decodeObjectForKey:@"gender"];
        _shift = [coder decodeObjectForKey:@"shift"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.activity forKey:@"activity"];
    [aCoder encodeObject:self.category forKey:@"category"];
    [aCoder encodeObject:self.date forKey:@"date"];
    [aCoder encodeObject:self.distance forKey:@"distance"];
    [aCoder encodeObject:self.eventId forKey:@"eventId"];
    [aCoder encodeObject:self.location forKey:@"location"];
    [aCoder encodeObject:self.maxPeople forKey:@"maxPeople"];
    [aCoder encodeObject:self.minPeople forKey:@"minPeople"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.owner forKey:@"owner"];
    [aCoder encodeObject:self.participants forKey:@"participants"];
    [aCoder encodeObject:self.sex forKey:@"gender"];
    [aCoder encodeObject:self.shift forKey:@"shift"];
}


//saves or updates events in userdefaults
+ (void)saveToDefaults:(SAEvent *)event{
    NSMutableArray *arrayOfEvents = [[NSUserDefaults standardUserDefaults] mutableArrayValueForKey:@"ArrayOfDictionariesContainingWithEvent"];
    
    //check if event is already in user defaults
    for (int i=0; i<arrayOfEvents.count;i++){
        NSDictionary *eventDict = arrayOfEvents[i];
        
        //if event is already in user defaults, just update it
        if ([eventDict[@"eventId"] isEqualToString:event.eventId.recordName]) {
            NSDictionary *eventToUpdateInDb = @{
                                                @"eventId" : event.eventId.recordName,
                                                @"event" : [NSKeyedArchiver archivedDataWithRootObject:event]
                                                };
            
            [arrayOfEvents replaceObjectAtIndex:i withObject:eventToUpdateInDb];
            
            [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithArray:arrayOfEvents] forKey:@"ArrayOfDictionariesContainingWithEvent"];
            return;
        }
    }
    
    //if not in defaults, just add it to user defaults
    NSDictionary *eventToSaveInDb = @{
                                        @"eventId" : event.eventId.recordName,
                                        @"event" : [NSKeyedArchiver archivedDataWithRootObject:event]
                                        };
    [arrayOfEvents addObject:eventToSaveInDb];
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithArray:arrayOfEvents] forKey:@"ArrayOfDictionariesContainingWithEvent"];
}

@end
