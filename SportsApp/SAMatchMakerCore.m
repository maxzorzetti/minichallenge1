//
//  SAMatchMakerCore.m
//  SportsApp
//
//  Created by Bruno Scheltzke on 2017-04-23.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import <CloudKit/CloudKit.h>
#import "SAActivity.h"
#import "SAEvent.h"
#import "SAEventConnector.h"
#import "SAEventDAO.h"
#import "SAMatchMakerCore.h"
#import "SAPerson.h"
#import "SAParty.h"
@class PriorityQueue<T>;

@interface SAMatchMakerCore ()

//@property PriorityQueue<SAParty *> *partyQueue;
//@property NSArray<SAEvent *> *eventQueue;

@end

@implementation SAMatchMakerCore

- (void)startMatchmakingForParty:(SAParty *)party handler:(void (^)(SAEvent * _Nullable event, NSError * _Nullable error))handler { //return event?
	[self getEventQueueForActivity:party.activity completionHandler:^(NSArray<SAEvent *> *events, NSError *error){
		
		SAEvent * compatibleEvent = nil;
		for (SAEvent *event in events){
			if ([self matchParty:party withEvent:event]){
				compatibleEvent = event;
				break;
			}
		}
		
		if (compatibleEvent == nil) {
			
			compatibleEvent = [self createEventForParty:party];

			[self updateEvent:compatibleEvent];
			
		}//else [compatibleEvent addParticipant:party.creator];
		
		
		handler(compatibleEvent, nil);
	}];
}

- (BOOL)matchParty:(SAParty *)party withEvent:(SAEvent *)event{
	if (![party.activity.name isEqualToString:event.activity.name]) return NO;
	
	if (party.maxParticipants < (int)event.maxPeople) return NO;

	if (1 + party.invitedPeople.count + event.participants.count > event.activity.maximumPeople) return NO;
	
	if ([event.participants containsObject:party.creator]) return NO;
	
	if (![self compatibleSchedule:party.schedule withDate:event.date]) return NO;
	
	
	//if (![party.dates containsObject:event.date]) return NO;
	
	return YES;
}

- (SAEvent *)createEventForParty:(SAParty *)party{
	SAEvent* event = [SAEvent new];
	//NSSortDescriptor *dateDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeIntervalSinceReferenceDate" ascending:YES];
	event.activity =  party.activity;
	event.name = party.activity.name;
	event.date = [self createDateFromSchedule:party.schedule];
	
	switch (party.shift) {
		case 0: event.shift = @"Morning"; break;
		case 1: event.shift = @"Afternoon"; break;
		case 2: event.shift = @"Night"; break;
		case 3: event.shift = @"Error";
	}
	event.distance = party.locationRadius;
	event.name = party.eventName;
	
	switch (party.gender) {
		case 0:event.sex = @"Female";	break;
		case 1:	event.sex = @"Male";	break;
		case 2:	event.sex = @"Mixed";	break;
		case 3: event.sex = @"Error";
	}
	
	//event.sex = party.gender;
	event.owner = party.creator;
	event.date = [NSDate new];
	event.maxPeople = [NSNumber numberWithInt:party.maxParticipants];
	event.minPeople = [NSNumber numberWithInt:party.minParticipants];
	
	[event addParticipant:party.creator];
	[event addParticipants: party.invitedPeople.allObjects];
	
	return event;
}

- (void)updateEvent:(SAEvent *)event{
	SAEventDAO *eventDAO =  [SAEventDAO new];
	
	[eventDAO saveEvent:event];
}

- (void)getEventQueueForActivity:(SAActivity *)activity completionHandler: (void (^)(NSArray<SAEvent *> *, NSError *))handler{
	//SAEventConnector *eventDAO = [SAEventConnector new];
	[SAEventConnector getEventsByActivity:activity handler:^(NSArray *events, NSError *error) {
		if (!error) {
			NSArray* eventQueue = [events sortedArrayUsingComparator:^NSComparisonResult(SAEvent* _Nonnull event1, SAEvent*  _Nonnull event2) {
				if (event1.participants.count > event2.participants.count) return NSOrderedAscending;
				else return NSOrderedDescending;
			}];
			
			handler(eventQueue, error);
		} else {
			NSLog(@"Error on %s", __PRETTY_FUNCTION__);
		}
	}];
}

- (NSDate *)createDateFromSchedule:(NSString *)schedule {
	NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
	
	if ([schedule isEqualToString:@"Today"]) {
		
		dayComponent.day = 0;
		
	} else if ([schedule isEqualToString:@"Tomorrow"]) {
		
		dayComponent.day = 1;
		
	} else if ([schedule isEqualToString:@"This Week"]) {
		
		dayComponent.day = 3;
		
	} else if ([schedule isEqualToString:@"Next Week"]) {
		
		dayComponent.day = 7;
		
	} else if ([schedule isEqualToString:@"Next Month"]) {
		
		dayComponent.day = 30;
		
	} else if ([schedule isEqualToString:@"Any Day"]) {
		
		dayComponent.day = 0;
		
	}
	
	NSCalendar *theCalendar = [NSCalendar currentCalendar];
	
	NSDate *midnightToday = [theCalendar startOfDayForDate:[NSDate date]];
	
	NSDate *nextDate = [theCalendar dateByAddingComponents:dayComponent toDate:midnightToday options:0];
	
	return nextDate;
}

- (BOOL)compatibleSchedule:(NSString *)schedule withDate:(NSDate *)date {
	
	BOOL result = NO;
	NSCalendar *theCalendar = [NSCalendar currentCalendar];
	NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
	NSDate *midnightToday = [theCalendar startOfDayForDate:[NSDate date]];
	
	if ([schedule isEqualToString:@"Today"]) {

		if ([midnightToday isEqualToDate:date]) result = YES;
		
	} else if ([schedule isEqualToString:@"Tomorrow"]) {
		
		dayComponent.day = 1;
		NSDate *nextDate = [theCalendar dateByAddingComponents:dayComponent toDate:midnightToday options:0];
		
		if ([nextDate isEqualToDate:date]) result = YES;
		
	} else if ([schedule isEqualToString:@"This Week"]) {
		
		for (int i = 0; i < 7; i++) {
			dayComponent.day = i;
			NSDate *nextDate = [theCalendar dateByAddingComponents:dayComponent toDate:midnightToday options:0];
			if ([nextDate isEqualToDate:date]) {
				result = YES;
				break;
			}
		}
		
	} else if ([schedule isEqualToString:@"Next Week"]) {
		
		for (int i = 7; i < 14; i++) {
			dayComponent.day = i;
			NSDate *nextDate = [theCalendar dateByAddingComponents:dayComponent toDate:midnightToday options:0];
			if ([nextDate isEqualToDate:date]) {
				result = YES;
				break;
			}
		}
		
	} else if ([schedule isEqualToString:@"Next Month"]) {
		
		for (int i = 30; i < 60; i++) {
			dayComponent.day = i;
			NSDate *nextDate = [theCalendar dateByAddingComponents:dayComponent toDate:midnightToday options:0];
			if ([nextDate isEqualToDate:date]) {
				result = YES;
				break;
			}
		}
		
	} else if ([schedule isEqualToString:@"Any Day"]) {
		
		result = YES;
	}
	
	return result;
}

+ (void)registerParty:(SAParty *)party{
    CKContainer *container = [CKContainer defaultContainer];
    CKDatabase *publicDatabase = [container publicCloudDatabase];
    
    CKRecord *partyRecord = [[CKRecord alloc]initWithRecordType:@"SAParty"];
    
    for (SAPerson *person in party.people) {
        CKReference *ref = [[CKReference alloc]initWithRecordID:person.personId action:CKReferenceActionNone];
        [partyRecord setObject:ref forKey:@"people"];
    }
    
    partyRecord[@"minPeople"] = [NSNumber numberWithInt:party.minParticipants];
    partyRecord[@"maxPeople"] = [NSNumber numberWithInt:party.maxParticipants];
    partyRecord[@"activity"] = party.activity.name;
    
    [publicDatabase saveRecord:partyRecord completionHandler:^(CKRecord *artworkRecord, NSError *error){
        if (error) {
            NSLog(@"Record Party not created. Error: %@", error.description);
        }
        NSLog(@"Record Party created");
    }];
    
}
+ (void)removeParty:(SAParty *)party{
    
}

@end
