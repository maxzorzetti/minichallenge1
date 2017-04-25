//
//  Event.m
//  SportsApp
//
//  Created by Bruno Scheltzke on 2017-04-19.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "SAEvent.h"
@class SAPerson;

@interface SAEvent ()
@property (nonatomic) NSMutableDictionary<SAPerson *, NSString *> *privateParticipantsRoles;
@end

@implementation SAEvent


- (instancetype)initWithName:(NSString *)name AndRequiredParticipants:(int)requiredParticipants AndMaxParticipants:(int)maxParticipants AndActivity:(SAActivity *)activity andId:(CKRecordID *)eventId andCategory:(NSString *)category AndSex:(NSString *)sex AndDates:(NSArray *)dates
{
    self = [super init];
    if (self) {
        _name = name;
        _requiredParticipants = requiredParticipants;
        _maxParticipants = maxParticipants;
        _activity = activity;
        _eventId = eventId;
        _category = category;
        _sex = sex;
        _dates = dates;
    }
    return self;
}

- (NSSet<SAPerson *> *)participants {
	NSSet* participants = [[NSSet alloc] initWithArray: self.participantsRoles.allKeys];
	return [participants copy];
}

- (void)addParticipant:(SAPerson *)person withRole:(NSString *)role{
	[self.privateParticipantsRoles setObject:role forKey:person]; //TODO implement NSCopying
}

- (void)addParticipants:(NSSet *)participants{
	for (SAPerson *person in participants) {
		[self.privateParticipantsRoles setObject:@"None" forKey:person];
	}
}

- (void)removeParticipant:(SAPerson *)person{
	[self.privateParticipantsRoles removeObjectForKey:person];
}


- (NSString *)getParticipantRole:(SAPerson *)person{
    return nil;
}


@end
