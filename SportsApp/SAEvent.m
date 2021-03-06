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

@interface SAEvent ()
@property (nonatomic) NSMutableArray<SAPerson *> *privateParticipants;
@property (nonatomic) NSMutableArray<SAPerson *> *privateInvitees;
@property (nonatomic) NSMutableArray<SAPerson *> *privateNotGoing;
@property (nonatomic) NSMutableArray<SAPerson *> *privateInviteesNotConfirmed;

typedef enum
{
    Going = 1,
    NotGoing,
    NotDecided,
    NotAnInvitee
} ParticipantStatus;

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
        _privateInvitees = [NSMutableArray new];
        _privateNotGoing = [NSMutableArray new];
        _privateInviteesNotConfirmed = [NSMutableArray new];
		_category = nil;
		_shift = nil;
		_sex = nil;
		_date = nil;
		_owner = nil;
		_location = nil;
		_distance = nil;
        _eventDescription = nil;
	}
	return self;
}

- (instancetype)initWithName:(NSString *)name andRequiredParticipants:(NSNumber *)requiredParticipants andMaxParticipants:(NSNumber *)maxParticipants andActivity:(SAActivity *)activity andId:(CKRecordID *)eventId andCategory:(NSString *)category andSex:(NSString *)sex andDate:(NSDate *)date andParticipants:(NSArray<SAPerson *> *)participants andInvitees:(NSArray<SAPerson *> *)invitees andLocation:(CLLocation *)location andDistance:(NSNumber *)distance
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
        _privateInvitees = [NSMutableArray arrayWithArray:invitees];
        _privateNotGoing = [NSMutableArray new];
        _privateInviteesNotConfirmed = [NSMutableArray new];
        _eventDescription = nil;
    }
    return self;
}

- (instancetype)initWithParty:(SAParty *)party {
	self = [super init];
	if (self) {
		_eventId = nil;
		_name = party.eventName;
		_minPeople = [[NSNumber alloc] initWithInt: party.minParticipants];
		_maxPeople = [[NSNumber alloc] initWithInt: party.maxParticipants];
		_activity = party.activity;
		_category = nil;
		_shift = [SAParty createStringFromShift:party.shift];
		_sex = [SAParty createStringFromGender:party.gender];
		_date = [SAParty createDateFromSchedule:party.schedule];
		_date = [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitMinute value:party.fromTime toDate:_date options:0];
		NSLog(@"%d", party.fromTime);
		NSLog(@"%@", _date);
		_location = party.location;
		_distance = party.locationRadius;
		_owner = party.creator;
		_privateParticipants = [NSMutableArray arrayWithArray:@[party.creator]];
		_privateInvitees = [NSMutableArray new];
        _privateNotGoing = [NSMutableArray new];
		_privateInviteesNotConfirmed = [NSMutableArray arrayWithArray:((NSMutableSet *)[party.invitedPeople copy]).allObjects];
        _eventDescription = party.eventDescription;
	}
	return self;
}

- (NSSet<SAPerson *> *)inviteesNotConfirmed {
    NSSet* inviteesNotConfirmed = [[NSSet alloc] initWithArray:self.privateInviteesNotConfirmed];
    return [inviteesNotConfirmed copy];
}

- (NSSet<SAPerson *> *)participants {
	NSSet* participants = [[NSSet alloc] initWithArray:self.privateParticipants];
	return [participants copy];
}

- (void)addParticipant:(SAPerson *)person{
    
    if ([self wasPersonInvited:person]) {
        [self removeNotGoingPerson:person];
        [self removeNotConfirmedPerson:person];
        [self addInvitee:person];
    }
    
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
    
    if ([self wasPersonInvited:person]) {
        [self removeInvitee:person];
        [self addNotGoingPerson:person];
    }
    
    
    [self.privateParticipants removeObject:personToRemove];
}

- (NSString *)getParticipantRole:(SAPerson *)person{
    return nil;
}

- (NSSet<SAPerson *> *)invitees {
    NSSet* invitees = [[NSSet alloc] initWithArray:self.privateInvitees];
    return [invitees copy];
}

- (void)addInvitee:(SAPerson *)invitee{
    [self.privateInvitees addObject:invitee];
}

- (void)addInvitees:(NSArray *)invitees{
    for (SAPerson *invitee in invitees) {
        [self.privateInviteesNotConfirmed addObject:invitee];
    }
}

- (void)addInviteesThatAreParticipants:(NSArray *)invitees{
    for (SAPerson *invitee in invitees) {
        [self.privateInvitees addObject:invitee];
    }
}


- (void)removeInvitee:(SAPerson *)invitee{
    SAPerson *personToRemove;
    for (SAPerson *participant in self.privateInvitees) {
        if ([participant.personId.recordName isEqualToString:invitee.personId.recordName]) {
            personToRemove = participant;
        }
    }
    if (personToRemove) {
        [self.privateInvitees removeObject:personToRemove];
    }
}

- (void)replaceInvitees:(NSArray<SAPerson *>*)invitees{
    [self.privateInvitees setArray:invitees];
}

- (void)makeAnInviteeAParticipant:(SAPerson *)invitee{
    [self removeInvitee:invitee];
    [self addParticipant:invitee];
}

- (void)makeAnInviteeANotGoingPerson:(SAPerson *)invitee{
    [self removeInvitee:invitee];
    [self addNotGoingPerson:invitee];
}

- (NSSet<SAPerson *> *)notGoing {
    NSSet* notGoingPeople = [[NSSet alloc] initWithArray:self.privateNotGoing];
    return [notGoingPeople copy];
}

- (void)addNotGoingPerson:(SAPerson *)notGoingPerson{
    [self removeNotConfirmedPerson:notGoingPerson];
    [self removeInvitee:notGoingPerson];
    
    [self.privateNotGoing addObject:notGoingPerson];
}

- (void)addNotGoingPeople:(NSArray *)notGoingPeople{
    for (SAPerson *notGoingPerson in notGoingPeople) {
        [self.privateNotGoing addObject:notGoingPerson];
    }
}

- (BOOL)wasPersonInvited:(SAPerson *)person{
    //is person in not going list?
    for (SAPerson *participant in self.privateNotGoing) {
        if ([participant.personId.recordName isEqualToString:person.personId.recordName]) {
            return true;
        }
    }
    
    //is person in going list?
    for (SAPerson *participant in self.privateInvitees) {
        if ([participant.personId.recordName isEqualToString:person.personId.recordName]) {
            return true;
        }
    }
    
    //is person in not confirmed list?
    for (SAPerson *participant in self.privateInviteesNotConfirmed) {
        if ([participant.personId.recordName isEqualToString:person.personId.recordName]) {
            return true;
        }
    }
    
    return false;
}

- (void)removeNotGoingPerson:(SAPerson *)notGoingPerson{
    SAPerson *personToRemove;
    for (SAPerson *participant in self.privateNotGoing) {
        if ([participant.personId.recordName isEqualToString:notGoingPerson.personId.recordName]) {
            personToRemove = participant;
        }
    }
    if (personToRemove) {
        [self.privateNotGoing removeObject:personToRemove];
    }
}

- (void)removeNotConfirmedPerson:(SAPerson *)notConfirmedPerson{
    SAPerson *personToRemove;
    for (SAPerson *participant in self.privateInviteesNotConfirmed) {
        if ([participant.personId.recordName isEqualToString:notConfirmedPerson.personId.recordName]) {
            personToRemove = participant;
        }
    }
    if (personToRemove) {
        [self.privateInviteesNotConfirmed removeObject:personToRemove];
    }
}


- (void)replaceNotGoingPerson:(NSArray<SAPerson *>*)notGoingPeople{
    [self.privateNotGoing setArray:notGoingPeople];
}

- (NSString *)description {
	return [[NSString alloc] initWithFormat:@"%@ %@ %@", self.name, self.activity.name, self.owner];
}

#pragma NSCopying methods - to encode into a NSData

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
        _privateInvitees = [coder decodeObjectForKey:@"invitees"];
        _privateInviteesNotConfirmed = [coder decodeObjectForKey:@"inviteesNotConfirmed"];
        _sex = [coder decodeObjectForKey:@"gender"];
        _shift = [coder decodeObjectForKey:@"shift"];
        _eventDescription = [coder decodeObjectForKey:@"eventDescription"];
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
    [aCoder encodeObject:self.privateParticipants forKey:@"participants"];
    [aCoder encodeObject:self.privateInvitees forKey:@"invitees"];
    [aCoder encodeObject:self.privateInviteesNotConfirmed forKey:@"inviteesNotConfirmed"];
    [aCoder encodeObject:self.sex forKey:@"gender"];
    [aCoder encodeObject:self.shift forKey:@"shift"];
    [aCoder encodeObject:self.eventDescription forKey:@"eventDescription"];
}


#pragma UserDefaults methods

+ (NSArray<SAEvent *>*)getEventsForInvitedCategory{
    //need current user to check if user is a participant of the events in user defaults
    NSData *userData = [[NSUserDefaults standardUserDefaults] dataForKey:@"user"];
    SAPerson *currentUser = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    
    //get array of events in user defaults
    NSArray *arrayOfEvents = [[NSUserDefaults standardUserDefaults] arrayForKey:@"ArrayOfDictionariesContainingWithEvent"];
    
    //array to return containing the events in invited category
    NSMutableArray *arrayToReturn = [NSMutableArray new];
    
    for (NSDictionary *dict in arrayOfEvents) {
        NSData *eventData = dict[@"event"];
        SAEvent *eventToCompare = [NSKeyedUnarchiver unarchiveObjectWithData:eventData];
        NSComparisonResult result = [eventToCompare.date compare:[NSDate date]];
        
        //check if date of event is greater than todays
        if (result == NSOrderedDescending) {
            //check if current user is an invitee of the event
            for (SAPerson *invitee in eventToCompare.privateInviteesNotConfirmed) {
                if ([invitee.personId.recordName isEqualToString:currentUser.personId.recordName]) {
                    [arrayToReturn addObject:eventToCompare];
                }
            }
        }
    }
    
    return arrayToReturn;
}

+ (NSArray<SAEvent *> *)getEventsFromComingUpCategory{
    //need current user to check if user is a participant of the events in user defaults
    NSData *userData = [[NSUserDefaults standardUserDefaults] dataForKey:@"user"];
    SAPerson *currentUser = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    
    //get array of events in user defaults
    NSArray *arrayOfEvents = [[NSUserDefaults standardUserDefaults] arrayForKey:@"ArrayOfDictionariesContainingWithEvent"];
    
    //array to return containing the events in coming up section
    NSMutableArray *arrayToReturn = [NSMutableArray new];
    
    for (NSDictionary *dict in arrayOfEvents) {
        NSData *eventData = dict[@"event"];
        SAEvent *eventToCompare = [NSKeyedUnarchiver unarchiveObjectWithData:eventData];
        NSComparisonResult result = [eventToCompare.date compare:[NSDate date]];
        
        //check if date of event is greater than todays
        if (result == NSOrderedDescending) {
            //check if current user is a participant of the event
            for (SAPerson *participant in eventToCompare.privateParticipants) {
                if ([participant.personId.recordName isEqualToString:currentUser.personId.recordName]) {
                    [arrayToReturn addObject:eventToCompare];
                }
            }
        }
    }

    return arrayToReturn;
}

+ (NSArray<SAEvent *>*)getEventsForPastCategory{
    //need current user to check if user is a participant of the events in user defaults
    NSData *userData = [[NSUserDefaults standardUserDefaults] dataForKey:@"user"];
    SAPerson *currentUser = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    
    //get array of events in user defaults
    NSArray *arrayOfEvents = [[NSUserDefaults standardUserDefaults] arrayForKey:@"ArrayOfDictionariesContainingWithEvent"];
    
    //array to return containing the events in past section
    NSMutableArray *arrayToReturn = [NSMutableArray new];
    
    for (NSDictionary *dict in arrayOfEvents) {
        NSData *eventData = dict[@"event"];
        SAEvent *eventToCompare = [NSKeyedUnarchiver unarchiveObjectWithData:eventData];
        NSComparisonResult result = [eventToCompare.date compare:[NSDate date]];
        
        //check if date of event is lower than todays
        if (result == NSOrderedAscending) {
            //check if current user is a participant of the event
            for (SAPerson *participant in eventToCompare.privateParticipants) {
                if ([participant.personId.recordName isEqualToString:currentUser.personId.recordName]) {
                    [arrayToReturn addObject:eventToCompare];
                }
            }
        }
    }
    
    return arrayToReturn;
}

+ (NSArray<SAEvent *>*)getEventsForTodayCategory{
    //need current user to check if user is a participant of the events in user defaults
    NSData *userData = [[NSUserDefaults standardUserDefaults] dataForKey:@"user"];
    SAPerson *currentUser = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    
    //get array of events in user defaults
    NSArray *arrayOfEvents = [[NSUserDefaults standardUserDefaults] arrayForKey:@"ArrayOfDictionariesContainingWithEvent"];
    
    //array to return containing the events in today section
    NSMutableArray *arrayToReturn = [NSMutableArray new];
    
    for (NSDictionary *dict in arrayOfEvents) {
        NSData *eventData = dict[@"event"];
        SAEvent *eventToCompare = [NSKeyedUnarchiver unarchiveObjectWithData:eventData];
        NSComparisonResult isEventDateGreaterThanToday = [eventToCompare.date compare:[NSDate date]];
        NSComparisonResult isEventDateLowerThanTomorrow = [eventToCompare.date compare:[NSDate dateWithTimeInterval:(24*60*60) sinceDate:[NSDate date]]];
        
        //check if date of event is greater than todays and lower than tomorrows
        if (isEventDateGreaterThanToday == NSOrderedDescending && isEventDateLowerThanTomorrow == NSOrderedAscending) {
            //check if events activity is in user interests list
            for (int i=0; i<[currentUser.interests count]; i++) {
                SAActivity *interest = currentUser.interests[i];
                //if user is interested in activity of event
                if ([interest.activityId.recordName isEqualToString:eventToCompare.activity.activityId.recordName]) {
                    //add event to be returned
                    [arrayToReturn addObject:eventToCompare];
                    //stop checking in interests for the event
                    i = (int)[currentUser.interests count];
                }
            }
        }
    }
    return arrayToReturn;
}

//saves or updates events in userdefaults
+ (void)saveToDefaults:(SAEvent *)event{
    NSMutableArray *arrayOfEvents = [[NSUserDefaults standardUserDefaults] mutableArrayValueForKey:@"ArrayOfDictionariesContainingWithEvent"];
    
    //check if event is already in user defaults
    for (int i=0; i<arrayOfEvents.count;i++){
        NSDictionary *eventDict = arrayOfEvents[i];
        
        //if event is already in user defaults, just update it
        if ([eventDict[@"eventId"] isEqualToString:event.eventId.recordName]) {
            NSData *eventData = [NSKeyedArchiver archivedDataWithRootObject:event];
            NSDictionary *eventToUpdateInDb = @{
                                                @"eventId" : event.eventId.recordName,
                                                @"event" : eventData
                                                };
            
            [arrayOfEvents replaceObjectAtIndex:i withObject:eventToUpdateInDb];
            
            [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithArray:arrayOfEvents] forKey:@"ArrayOfDictionariesContainingWithEvent"];
            return;
        }
    }
    
    //if not in defaults, just add it to user defaults
    NSData *eventData = [NSKeyedArchiver archivedDataWithRootObject:event];
    NSDictionary *eventToSaveInDb = @{
                                        @"event" : eventData,
                                        @"eventId" : event.eventId.recordName
                                        };
    [arrayOfEvents addObject:eventToSaveInDb];
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithArray:arrayOfEvents] forKey:@"ArrayOfDictionariesContainingWithEvent"];
}

@end
