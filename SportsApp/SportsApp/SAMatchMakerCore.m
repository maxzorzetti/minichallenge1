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

- (void)startMatchmakingForParty:(SAParty *)party{ //return event?
	[self getEventQueueForActivity:party.activity completionHandler:^(NSArray<SAEvent *> *events, NSError *error){
		
		SAEvent * compatibleEvent = nil;
		for (SAEvent *event in events){
			if ([self matchParty:party withEvent:event]){
				compatibleEvent = event;
				break;
			}
		}
		
		if (compatibleEvent == nil) compatibleEvent = [self createEventForParty:party];
		else [compatibleEvent addParticipants:party.people];
		
		[self updateEvent:compatibleEvent];
		
	}];
}

- (BOOL)matchParty:(SAParty *)party withEvent:(SAEvent *)event{
	if (![party.activity.name isEqualToString:event.activity.name]) return NO;
	
	if (party.maxParticipants < event.maxParticipants) return NO;

	if (party.people.count + event.participants.count > event.activity.maximumPeople) return NO;
	
	return YES;
}

- (SAEvent *)createEventForParty:(SAParty *)party{
	SAEvent* event = [SAEvent new];
	event.activity = [party.activity copy];
	event.maxParticipants = party.maxParticipants;
	event.requiredParticipants = party.minParticipants;
	[event addParticipants:party.people];
	return event;
}

- (void)updateEvent:(SAEvent *)event{
	SAEventDAO *eventDAO =  [SAEventDAO new];
	//[eventDAO save: event];
	//send event to cloudkit
}

- (void)getEventQueueForActivity:(SAActivity *)activity completionHandler: (void (^)(NSArray<SAEvent *> *, NSError *))handler{
	SAEventDAO *eventDAO = [SAEventDAO new];
	[eventDAO getAvailableEventsOfActivity:activity completionHandler:^(NSArray *events, NSError *error) {
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

+ (void)registerParty:(SAParty *)party{
    CKContainer *container = [CKContainer defaultContainer];
    CKDatabase *publicDatabase = [container publicCloudDatabase];
    
    CKRecord *partyRecord = [[CKRecord alloc]initWithRecordType:@"SAParty"];
    
    for (SAPerson *person in party.people) {
        CKReference *ref = [[CKReference alloc]initWithRecordID:person.id action:CKReferenceActionNone];
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
