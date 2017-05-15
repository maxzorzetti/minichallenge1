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
@property (nonatomic) NSString *category;
@property (nonatomic) NSString *shift;
@property (nonatomic) NSString *sex;
@property (nonatomic) NSDate *date;
@property (atomic) SAPerson *owner;
@property (nonatomic) CLLocation *location;
@property (nonatomic) NSNumber *distance;

- (instancetype)initWithName:(NSString *)name andRequiredParticipants:(NSNumber *)requiredParticipants andMaxParticipants:(NSNumber *)maxParticipants andActivity:(SAActivity *)activity andId:(CKRecordID *)eventId andCategory:(NSString *)category andSex:(NSString *)sex andDate:(NSDate *)date andParticipants:(NSArray<SAPerson *> *)participants andLocation:(CLLocation *)location andDistance:(NSNumber *)distance;

- (void)encodeWithCoder:(NSCoder *)aCoder;

- (id)initWithCoder:(NSCoder *)aDecoder;

- (void)addParticipant:(SAPerson *)person;

- (void)addParticipants:(NSArray *)participants;

- (void)removeParticipant:(SAPerson *)person;

- (NSString *)getParticipantRole:(SAPerson *)person;

- (void)replaceParticipants:(NSArray<SAPerson *>*)participants;

+ (void)saveToDefaults:(SAEvent *)event;

@end
