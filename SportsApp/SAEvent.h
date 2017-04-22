//
//  Event.h
//  SportsApp
//
//  Created by Bruno Scheltzke on 2017-04-19.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SAPerson;

@interface SAEvent : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) int requiredNumberPerson, currentNumberPerson;
@property (nonatomic) NSString *activity;
@property (nonatomic, readonly) NSSet<SAPerson *> *participants;
@property (nonatomic, readonly) NSDictionary<SAPerson *, NSString *> *participantsRoles;

- (void)addParticipant:(SAPerson *)person withRole:(NSString *)role;

- (void)removeParticipant:(SAPerson *)person;

- (NSString *)getParticipantRole:(SAPerson *)person;

@end
