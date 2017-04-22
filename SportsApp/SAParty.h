//
//  SAParty.h
//  SportsApp
//
//  Created by Max Zorzetti on 19/04/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SAPerson;

@interface SAParty : NSObject

@property (nonatomic) NSUUID *partyId;
@property (nonatomic, readonly) NSSet *people;
@property (nonatomic) int maxParticipants, minParticipants;

- (void)addPeople:(SAPerson *)person;
- (instancetype) initWithPeople:(NSSet *)people maxParticipants:(int)maxParticipants AndminParticipants:(int)minParticipants;


@end
