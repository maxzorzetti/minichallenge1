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

@property (nonatomic) NSString *name;
@property (nonatomic) int requiredParticipants, maxParticipants;
@property (nonatomic) SAActivity *activity;
@property (nonatomic, readonly) NSSet<SAPerson *> *participants;
@property (nonatomic, readonly) CKRecordID *eventId;
@property (nonatomic) NSString *category;
@property (nonatomic) NSString *sex;
@property (nonatomic) NSArray *dates;
@property (nonatomic, readonly) NSDictionary<SAPerson *, NSString *> *participantsRoles;

- (instancetype)initWithName:(NSString *)name AndRequiredParticipants:(int)requiredParticipants AndMaxParticipants:(int)maxParticipants AndActivity:(SAActivity *)activity andId:(CKRecordID *)eventId andCategory:(NSString *)category AndSex:(NSString *)sex AndDates:(NSArray *)dates;

- (void)addParticipant:(SAPerson *)person withRole:(NSString *)role;

- (void)addParticipants:(NSSet *)participants;

- (void)removeParticipant:(SAPerson *)person;

- (NSString *)getParticipantRole:(SAPerson *)person;

@end
