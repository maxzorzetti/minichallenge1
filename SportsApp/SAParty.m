//
//  SAParty.m
//  SportsApp
//
//  Created by Max Zorzetti on 19/04/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "SAParty.h"
#import "SAPerson.h"
#import <CloudKit/CloudKit.h>

@interface SAParty()
@property (nonatomic) NSMutableSet *privatePeople;
@end

@implementation SAParty

- (instancetype)init
{
	self = [super init];
	if (self) {
		_shift = SANoShift;
		_peopleType = SANoPeopleType;
		_gender = SANoGender;
		_invitedPeople = [NSMutableSet new];
	}
	return self;
}

- (instancetype) initWithPeople:(NSSet *)people dates:(NSSet<NSDate *> *)dates activity:(SAActivity *)activity  maxParticipants:(int)maxParticipants AndminParticipants:(int)minParticipants{
    self = [super init];
    if (self) {
        _privatePeople = [[NSMutableSet alloc]initWithSet:people];
        _maxParticipants = maxParticipants;
        _minParticipants = minParticipants;
        _activity = activity;
        _dates = dates;
    }
    return self;
}

- (void)addPerson:(SAPerson *)person{
    [self.privatePeople addObject:person];
}

- (void)removePerson:(SAPerson *)person{
	[self.privatePeople removeObject:person];
}

- (NSSet *)people{
    return [self.privatePeople copy];
}

- (id)copyWithZone:(NSZone *)zone {
	SAParty *newParty = [SAParty new];
	newParty.creator = self.creator;
	newParty.activity = self.activity;
	//newParty.schedule = [self.schedule copyWithZone:zone]; // Used when schedule was a string, revert if necessary
	newParty.schedule = self.schedule;
	newParty.fromTime = self.fromTime;
	newParty.toTime = self.toTime;
	newParty.shift = self.shift;
	newParty.peopleType = self.peopleType;
	newParty.invitedPeople = self.invitedPeople;
	newParty.locationRadius = [self.locationRadius copyWithZone:zone];
	newParty.gender = self.gender;
	newParty.eventName = [self.eventName copy];
	newParty.minParticipants = self.minParticipants;
	newParty.maxParticipants = self.maxParticipants;
    newParty.eventDescription = self.eventDescription;
	return newParty;
}

#pragma mark Enum utilities

+ (NSString *)createStringFromGender:(SAGender)gender {
	
	NSString *genderString;
	switch (gender) {
		case SAFemaleGender: genderString = @"Female";	break;
		case SAMaleGender:	genderString = @"Male";		break;
		case SAMixedGender:	genderString = @"Mixed";	break;
		case SANoGender: genderString = @"Error";
	}
	
	return genderString;
}

+ (NSString *)createStringFromSchedule:(SASchedule)schedule {
	
	NSString *scheduleString;
	switch (schedule) {
		case SAToday:
			scheduleString = @"Today";
			break;
		case SATomorrow:
			scheduleString = @"Tomorrow";
			break;
		case SAThisWeek:
			scheduleString = @"This Week";
			break;
		case SAThisSaturday:
			scheduleString = @"This Saturday";
			break;
		case SAThisSunday:
			scheduleString = @"This Sunday";
			break;
		case SAAnyDay:
			scheduleString = @"Any day";
			break;
		case SANoDay:
			scheduleString = @"No day selected";
	}
	return scheduleString;
}

+ (NSString *)createStringFromShift:(SAShift)shift {
	NSString *shiftString;
	switch (shift) {
		case SAMorningShift:
			shiftString = @"Morning";
			break;
		case SAAfternoonShift:
			shiftString = @"Afternoon";
			break;
		case SANightShift:
			shiftString = @"Night";
			break;
		case SANoShift:
			shiftString = @"No shift selected";
	}
	return shiftString;
}

+ (NSDate *)createDateFromSchedule:(SASchedule)schedule {
	// Used when creating an event from scratch
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDate *midnightToday = [calendar startOfDayForDate:[NSDate date]];
	
	NSDate *date = midnightToday;
	
	switch (schedule) {
		case SAToday:
			// midnightToday
			break;
		case SATomorrow:
			date = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:date options:0];
			break;
		case SAThisWeek:
			date = [calendar dateByAddingUnit:NSCalendarUnitDay value:3 toDate:date options:0]; // Temporary solution - we need a screen to set this
			break;
		case SAThisSunday:
			while ([calendar component:NSCalendarUnitWeekday fromDate:date] != 1) {
				date = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:date options:0];
			}
			break;
		case SAThisSaturday:
			while ([calendar component:NSCalendarUnitWeekday fromDate:date] != 7) {
				date = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:date options:0];
			}
			break;
		case SAAnyDay:
			date = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:date options:0]; // See ThisWeek
			break;
		case SANoDay:
			date = nil;
	}

	return date;
}

@end
