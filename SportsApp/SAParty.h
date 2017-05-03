//
//  SAParty.h
//  SportsApp
//
//  Created by Max Zorzetti on 19/04/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAPerson.h"
#import "SAActivity.h"

@interface SAParty : NSObject <NSCopying>

typedef NS_ENUM(NSInteger, SAShift) {
	SAMorningShift, SAAfternoonShift, SANightShift, SANoShift
};
typedef NS_ENUM(NSInteger, SAPeopleType) {
	SAMyFriendsPeopleType, SAAnyonePeopleType, SANoPeopleType
};
typedef NS_ENUM(NSInteger, SAGender) {
	SAFemaleGender, SAMaleGender, SAMixedGender, SANoGender
};

@property (nonatomic, readonly) NSUUID *partyId;
@property (nonatomic, readonly) NSSet *people;
@property (nonatomic) int maxParticipants, minParticipants;
@property (nonatomic) NSSet<NSDate *> *dates;

@property (nonatomic) SAPerson *creator;
@property (nonatomic) SAActivity *activity;
@property (nonatomic) NSString *schedule;
@property (nonatomic) SAShift shift;
@property (nonatomic) SAPeopleType peopleType;
@property (nonatomic) NSMutableSet<SAPerson *> *invitedPeople;
@property (nonatomic) NSNumber *locationRadius;
@property (nonatomic) SAGender gender;

- (void)addPerson:(SAPerson *)person;
- (void)removePerson:(SAPerson *)person;

- (instancetype) initWithPeople:(NSSet *)people dates:(NSSet<NSDate *> *)dates activity:(SAActivity *)activity maxParticipants:(int)maxParticipants AndminParticipants:(int)minParticipants;


@end
