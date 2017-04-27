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

@interface SAEvent : NSObject

@property (nonatomic, readonly) CKRecordID *eventId;
@property (nonatomic) NSString *name;
@property (nonatomic) int minPeople, maxPeople;
@property (nonatomic) SAActivity *activity;
@property (nonatomic, readonly) NSSet<SAPerson *> *participants;
@property (nonatomic) NSString *category;
@property (nonatomic) NSString *shift;
@property (nonatomic) NSString *sex;
@property (nonatomic) NSDate *date;
@property (nonatomic, readonly) NSDictionary<SAPerson *, NSString *> *participantsRoles;

- (instancetype)initWithName:(NSString *)name andRequiredParticipants:(int)requiredParticipants andMaxParticipants:(int)maxParticipants andActivity:(SAActivity *)activity andId:(CKRecordID *)eventId andCategory:(NSString *)category andSex:(NSString *)sex andDate:(NSDate *)date;

- (void)addParticipant:(SAPerson *)person withRole:(NSString *)role;

- (void)addParticipants:(NSSet *)participants;

- (void)removeParticipant:(SAPerson *)person;

- (NSString *)getParticipantRole:(SAPerson *)person;

@end
