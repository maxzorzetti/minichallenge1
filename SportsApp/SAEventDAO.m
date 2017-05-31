//
//  EventDAO.m
//  SportsApp
//
//  Created by Bruno Scheltzke on 24/04/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "SAEventDAO.h"
#import "SAActivity.h"
#import "SAPerson.h"
#import <CloudKit/CloudKit.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import "SAEvent.h"

@implementation SAEventDAO

CKContainer *container;
CKDatabase *publicDatabase;

- (void)getEventById:(CKRecordID *)eventId handler:(void (^)(CKRecord * _Nullable record, NSError * _Nullable error))handler{
	[self connectToPublicDatabase];
    
    [publicDatabase fetchRecordWithID:eventId completionHandler:^(CKRecord *eventRecord, NSError *error) {
        handler(eventRecord,error);
    }];
}

- (void)getEventsByUserReference:(CKReference *)userId handler:(void (^)(NSArray<CKRecord *>* _Nullable record, NSError * _Nullable error))handler{
    [self connectToPublicDatabase];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%@ IN participants AND date > %@", userId, [NSDate date]];
    
    CKQuery *query = [[CKQuery alloc]initWithRecordType:@"Event" predicate:predicate];
    
    [publicDatabase performQuery:query inZoneWithID:nil completionHandler:handler];
}

- (void)getPastEventsByUserReference:(CKReference *)userId handler:(void (^)(NSArray<CKRecord *>* _Nullable record, NSError * _Nullable error))handler{
    [self connectToPublicDatabase];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%@ IN participants AND date < %@", userId, [NSDate date]];
    
    CKQuery *query = [[CKQuery alloc]initWithRecordType:@"Event" predicate:predicate];
    
    [publicDatabase performQuery:query inZoneWithID:nil completionHandler:handler];
}

- (void)getAvailableEventsOfActivity:(SAActivity *)activity completionHandler:(void (^)(NSArray *, NSError *))handler{
	[self connectToPublicDatabase];
    
    CKReference *activityRef = [[CKReference alloc]initWithRecordID:activity.activityId action:CKReferenceActionNone];
	
	NSPredicate *activityPredicate = [NSPredicate predicateWithFormat:@"activity = %@", activityRef];
	CKQuery *activitiesQuery = [[CKQuery alloc]initWithRecordType:@"Event" predicate:activityPredicate];
	
	[publicDatabase performQuery:activitiesQuery inZoneWithID:nil completionHandler:handler];
}


- (void)getNext24hoursInterestedEventsWithActivities:(NSArray<CKReference *>*_Nonnull)interestedReferencedActivities AndCurrentLocation:(CLLocation *)usersLocation andDistanceInMeters:(int)proximity handler:(void (^_Nonnull)(NSArray<CKRecord *>* _Nullable events, NSError * _Nullable error))handler{
    
    [self connectToPublicDatabase];
    
    NSDate *now = [NSDate date];
    NSDate *oneDayFromNow = [NSDate dateWithTimeIntervalSinceNow:86400];
    
    CGFloat distanceAllowed = proximity;
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K IN %@ AND distanceToLocation:fromLocation:(location, %@) < %f AND %K > %@ AND %K <%@", @"activity", interestedReferencedActivities, usersLocation, distanceAllowed, @"date", now, @"date", oneDayFromNow];
    CKQuery *query = [[CKQuery alloc]initWithRecordType:@"Event" predicate:predicate];
    
    [publicDatabase performQuery:query inZoneWithID:nil completionHandler:handler];
}

- (void)getSugestedEventsWithActivities:(NSArray<CKReference *>*_Nullable)interestedReferencedActivities AndCurrentLocation:(CLLocation *)usersLocation andDistanceInMeters:(int)proximity AndFriends:(NSArray<CKReference *>*_Nonnull)friends handler:(void (^_Nonnull)(NSArray<CKRecord *>* _Nullable events, NSError * _Nullable error))handler{
    [self connectToPublicDatabase];
    
    NSDate *now = [NSDate date];
    
    CGFloat distanceAllowed = proximity;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY %K IN %@ AND distanceToLocation:fromLocation:(location, %@) < %f AND %K > %@", @"participants", friends, usersLocation, distanceAllowed, @"date", now];
    
    CKQuery *query = [[CKQuery alloc]initWithRecordType:@"Event" predicate:predicate];
    
    [publicDatabase performQuery:query inZoneWithID:nil completionHandler:handler];
}

- (void)getEventsWhereUserIsAnInvitee:(CKReference *_Nonnull)userRef handler:(void (^_Nonnull)(NSArray<CKRecord *>* _Nullable events, NSError * _Nullable error))handler{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%@ IN inviteesNotConfirmed AND date > %@", userRef, [NSDate date]];
    
    CKQuery *query = [[CKQuery alloc]initWithRecordType:@"Event" predicate:predicate];
    
    //i dont know why but the call to the database next to this one only works after this is called WTF!!!!!!!!!
    [self fetchRecordByRecordId:userRef.recordID handler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
        if (!error) {
            
        }
    }];
    
    
    [publicDatabase performQuery:query inZoneWithID:nil completionHandler:^(NSArray<CKRecord *> * _Nullable results, NSError * _Nullable errorFetched) {
        if (!errorFetched) {
            handler(results, errorFetched);
        }
    }];
}

- (void)updateEvent:(CKRecord *)event handler:(void (^_Nonnull)(CKRecord * _Nullable event, NSError * _Nullable error))handler{
    [self connectToPublicDatabase];
    
    NSArray<CKRecord*> *groupRecordArray = [[NSArray alloc] initWithObjects:event, nil];
    CKModifyRecordsOperation *updatedGroup = [[CKModifyRecordsOperation alloc] initWithRecordsToSave:groupRecordArray recordIDsToDelete:nil];
    updatedGroup.savePolicy = CKRecordSaveAllKeys;
    updatedGroup.qualityOfService = NSQualityOfServiceUserInitiated;
    updatedGroup.modifyRecordsCompletionBlock=
    ^(NSArray * savedRecords, NSArray * deletedRecordIDs, NSError * operationError){
        handler([savedRecords firstObject], operationError);
    };
    
    [publicDatabase addOperation:updatedGroup];
    
//    [publicDatabase saveRecord:event completionHandler:^(CKRecord * _Nullable eventRecord, NSError * _Nullable errorAnswer) {
//        handler(eventRecord, errorAnswer);
//    }];
}

- (void)saveEvent:(SAEvent *)event handler: (void (^_Nonnull)(CKRecord * _Nullable event, NSError * _Nullable error))handler {
	[self connectToPublicDatabase];
	// Create event record
	CKRecord *eventRecord = [[CKRecord alloc]initWithRecordType:@"Event"];
	
	// Create the activity reference
	CKReference *activityReference = [[CKReference alloc] initWithRecordID:event.activity.activityId action:CKReferenceActionNone];
	
	// Create event owner reference
	CKReference *ownerReference = [[CKReference alloc] initWithRecordID:event.owner.personId action:CKReferenceActionNone];
	
	// Create participants references
	NSMutableArray<CKReference *>  *participantsReferenceList= [NSMutableArray new];
	for (SAPerson *person in event.participants) {
		[participantsReferenceList addObject: [[CKReference alloc]initWithRecordID:person.personId action:CKReferenceActionNone]];
	}
    
    // Create invitees references
    NSMutableArray<CKReference *>  *inviteesReferenceList = [NSMutableArray new];
    for (SAPerson *person in event.invitees) {
        [inviteesReferenceList addObject: [[CKReference alloc]initWithRecordID:person.personId action:CKReferenceActionNone]];
    }
	
    // Create notConfirmed references
    NSMutableArray<CKReference *>  *inviteesNotConfirmedRef = [NSMutableArray new];
    for (SAPerson *person in event.inviteesNotConfirmed) {
        [inviteesNotConfirmedRef addObject: [[CKReference alloc]initWithRecordID:person.personId action:CKReferenceActionNone]];
    }
    
    // Create not going references
    NSMutableArray<CKReference *>  *inviteeNotGoingRef = [NSMutableArray new];
    for (SAPerson *person in event.notGoing) {
        [inviteeNotGoingRef addObject: [[CKReference alloc]initWithRecordID:person.personId action:CKReferenceActionNone]];
    }
    
	// Insert data into event record
	eventRecord[@"name"] = event.name;
	eventRecord[@"owner"] = ownerReference;
	eventRecord[@"participants"] = participantsReferenceList;
	eventRecord[@"activity"] = activityReference;
	eventRecord[@"location"] = event.location;
	eventRecord[@"minPeople"] = event.minPeople;
	eventRecord[@"maxPeople"] = event.maxPeople;
	eventRecord[@"category"] = event.category;
	eventRecord[@"date"] = event.date;
	eventRecord[@"shift"] = event.shift;
	eventRecord[@"sex"] = event.sex;
    eventRecord[@"invitees"] = inviteesReferenceList;
    eventRecord[@"inviteesNotConfirmed"] = inviteesNotConfirmedRef;
    eventRecord[@"notGoing"] = inviteeNotGoingRef;
	 
	// Atempt to save event record
	[publicDatabase saveRecord:eventRecord completionHandler:^(CKRecord *eventFetchedFromDb, NSError *error){
		if (error) {
			NSLog(@"Record Party not created. Error: %@", error.description);
		}
		NSLog(@"Event record created");
		handler(eventFetchedFromDb, error);
	}];
	
}

- (void)connectToPublicDatabase{
	if (container == nil) container = [CKContainer defaultContainer];
	if (publicDatabase == nil) publicDatabase = [container publicCloudDatabase];
}




//THIS SHOULD BE IN ANOTHER CLASS
- (void)fetchRecordByRecordId:(CKRecordID *_Nonnull)recordId handler:(void (^_Nonnull)(CKRecord * _Nullable record, NSError * _Nullable error))handler{
    [self connectToPublicDatabase];
    
    [publicDatabase fetchRecordWithID:recordId completionHandler:^(CKRecord * _Nullable recordFetched, NSError * _Nullable errorFetched) {
        handler(recordFetched, errorFetched);
    }];
}

@end
