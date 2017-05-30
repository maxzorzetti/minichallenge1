//
//  Event.h
//  SportsApp
//
//  Created by Bruno Scheltzke on 2017-04-19.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SAPerson;
@class SAActivity;
@class CKRecordID;
@class CLLocation;

@interface SAEvent : NSObject <NSCoding>

@property (nonatomic) CKRecordID *eventId;
@property (nonatomic) NSString *name;
@property (nonatomic) NSNumber *minPeople, *maxPeople;
@property (atomic) SAActivity *activity;
@property (nonatomic, readonly) NSSet<SAPerson *> *participants;
@property (nonatomic, readonly) NSSet<SAPerson *> *invitees;
@property (nonatomic, readonly) NSSet<SAPerson *> *notGoing;
@property (nonatomic, readonly) NSSet<SAPerson *> *inviteesNotConfirmed;
@property (nonatomic) NSString *category;
@property (nonatomic) NSString *shift;
@property (nonatomic) NSString *sex;
@property (nonatomic) NSDate *date;
@property (atomic) SAPerson *owner;
@property (nonatomic) CLLocation *location;
@property (nonatomic) NSNumber *distance;

- (instancetype)initWithName:(NSString *)name andRequiredParticipants:(NSNumber *)requiredParticipants andMaxParticipants:(NSNumber *)maxParticipants andActivity:(SAActivity *)activity andId:(CKRecordID *)eventId andCategory:(NSString *)category andSex:(NSString *)sex andDate:(NSDate *)date andParticipants:(NSArray<SAPerson *> *)participants andInvitees:(NSArray<SAPerson *> *)invitees andLocation:(CLLocation *)location andDistance:(NSNumber *)distance;

- (void)encodeWithCoder:(NSCoder *)aCoder;

- (id)initWithCoder:(NSCoder *)aDecoder;

- (NSSet<SAPerson *> *)inviteesNotConfirmed;

- (void)addInviteesThatAreParticipants:(NSArray *)invitees;

- (void)addParticipant:(SAPerson *)person;

- (void)addParticipants:(NSArray *)participants;

- (void)removeParticipant:(SAPerson *)person;

- (void)replaceParticipants:(NSArray<SAPerson *>*)participants;

- (void)addInvitee:(SAPerson *)invitee;

- (void)addInvitees:(NSArray *)invitees;

- (void)removeInvitee:(SAPerson *)invitee;

- (void)replaceInvitees:(NSArray<SAPerson *>*)invitees;

- (void)makeAnInviteeAParticipant:(SAPerson *)invitee;

- (NSString *)getParticipantRole:(SAPerson *)person;

- (void)makeAnInviteeANotGoingPerson:(SAPerson *)invitee;

- (NSSet<SAPerson *> *)notGoing;

- (void)addNotGoingPerson:(SAPerson *)notGoingPerson;

- (void)addNotGoingPeople:(NSArray *)notGoingPeople;

- (void)removeNotGoingPerson:(SAPerson *)notGoingPerson;

- (void)replaceNotGoingPerson:(NSArray<SAPerson *>*)notGoingPeople;

+ (void)saveToDefaults:(SAEvent *)event;

+ (NSArray<SAEvent *>*)getEventsFromComingUpCategory;

+ (NSArray<SAEvent *>*)getEventsForTodayCategory;

+ (NSArray<SAEvent *>*)getEventsForPastCategory;

+ (NSArray<SAEvent *>*)getEventsForInvitedCategory;

@end
