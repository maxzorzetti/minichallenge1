//
//  SAParty.h
//  SportsApp
//
//  Created by Max Zorzetti on 19/04/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SAPerson;
@class SAActivity;

@interface SAParty : NSObject

@property (nonatomic, readonly) NSUUID *partyId;
@property (nonatomic, readonly) NSSet *people;
@property (nonatomic) int maxParticipants, minParticipants;
@property (nonatomic) SAActivity *activity;
@property (nonatomic) NSSet<NSDate *> *dates;

- (void)addPerson:(SAPerson *)person;
- (void)removePerson:(SAPerson *)person;

- (instancetype) initWithPeople:(NSSet *)people dates:(NSSet<NSDate *> *)dates activity:(SAActivity *)activity maxParticipants:(int)maxParticipants AndminParticipants:(int)minParticipants;


@end
