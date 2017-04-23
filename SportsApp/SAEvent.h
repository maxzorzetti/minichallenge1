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
@property (nonatomic, readonly) NSDictionary<SAPerson *, NSString *> *participantsRoles;

- (void)addParticipant:(SAPerson *)person withRole:(NSString *)role;

- (void)addParticipants:(NSSet *)participants;

- (void)removeParticipant:(SAPerson *)person;

- (NSString *)getParticipantRole:(SAPerson *)person;

@end
