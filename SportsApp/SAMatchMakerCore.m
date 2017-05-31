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

- (void)startMatchmakingForParty:(SAParty *)party handler:(void (^)(SAEvent * _Nullable event, NSError * _Nullable error))handler {
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

			[self updateEvent:compatibleEvent handler:^(CKRecord *record, NSError *error) {
				compatibleEvent.eventId = record.recordID;
				handler(compatibleEvent, error);
			}];
			
		}//else [compatibleEvent addParticipant:party.creator];
		
	}];
}

- (BOOL)matchParty:(SAParty *)party withEvent:(SAEvent *)event{
	if (![party.activity.name isEqualToString:event.activity.name]) return NO;
	
	if (party.maxParticipants < (int)event.maxPeople) return NO;

	if (1 + party.invitedPeople.count + event.participants.count > event.activity.maximumPeople) return NO;
	
	if ([event.participants containsObject:party.creator]) return NO;
	
	if (![self compatibleSchedule:party.schedule withDate:event.date]) return NO;
	
	if ([party.location distanceFromLocation: event.location] > party.locationRadius.integerValue * 1000) return NO;
	
	
	//if (![party.dates containsObject:event.date]) return NO;
	
	return YES;
}

- (SAEvent *)createEventForParty:(SAParty *)party{
	SAEvent* event = [SAEvent new];
	//NSSortDescriptor *dateDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeIntervalSinceReferenceDate" ascending:YES];
	event.activity =  party.activity;
	event.name = party.activity.name;
	event.date = [SAParty createDateFromSchedule:party.schedule];
	
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
	event.maxPeople = [NSNumber numberWithInt:party.maxParticipants];
	event.minPeople = [NSNumber numberWithInt:party.minParticipants];
	
	event.location = party.location;
	
	[event addParticipant:party.creator];
	[event addInvitees: party.invitedPeople.allObjects];
	
	return event;
}

- (void)updateEvent:(SAEvent *)event handler:(void (^ _Nonnull)(CKRecord * _Nullable, NSError * _Nullable))handler{
	SAEventDAO *eventDAO =  [SAEventDAO new];
	
	[eventDAO saveEvent:event handler:^(CKRecord * _Nullable event, NSError * _Nullable error) {
		handler(event, error);
	}];
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

- (BOOL)compatibleSchedule:(SASchedule)schedule withDate:(NSDate *)date {
	
	BOOL compatible = NO;
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDate *today = [calendar startOfDayForDate:[NSDate date]];
	
	switch (schedule) {
		case SAToday:
			if ([calendar isDateInToday:date]) compatible = YES;
		break;
			
		case SATomorrow:
			if ([calendar isDateInTomorrow:date]) compatible = YES;
		break;
			
		case SAThisWeek:
			// Check if its sunday, if not, check rest of the week (until it gets to the next sunday)
			do {
				if ([today isEqualToDate:date]) {
					compatible = YES;
					break;
				}
				today = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:today options:0];
			} while ([calendar component:NSCalendarUnitWeekday fromDate:today] != 1);
		break;
			
		case SAThisSaturday:
			if ([calendar component:NSCalendarUnitWeekday fromDate:date] == 7) compatible = YES;
		break;
			
		case SAThisSunday:
			if ([calendar component:NSCalendarUnitWeekday fromDate:date] == 1) compatible = YES;
		break;
			
		case SAAnyDay:
			compatible = YES;
		break;
	}
	
	return compatible;
}


/* UNUSED
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
    
}*/

@end
