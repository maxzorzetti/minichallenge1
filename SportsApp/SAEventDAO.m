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
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K IN %@ AND distanceToLocation:fromLocation:(location, %@) < %f AND %K BETWEEN %@ AND %@", @"activity", interestedReferencedActivities, usersLocation, distanceAllowed, @"date", now, oneDayFromNow];
    
    CKQuery *query = [[CKQuery alloc]initWithRecordType:@"Event" predicate:predicate];
    
    [publicDatabase performQuery:query inZoneWithID:nil completionHandler:handler];
}

- (void)saveEvent:(SAEvent *)event{
	[self connectToPublicDatabase];
	
	CKRecord *eventRecord = [[CKRecord alloc]initWithRecordType:@"SAEvent"];

	CKReference *activityRef = [[CKReference alloc]initWithRecordID:event.activity.activityId action:CKReferenceActionNone];
	NSMutableArray *personList = [NSMutableArray new];
	for (SAPerson *person in event.participants) {
		[personList addObject: [[CKReference alloc]initWithRecordID:person.id action:CKReferenceActionNone]];
	}
	
	eventRecord[@"name"] = event.name;
	eventRecord[@"participants"] = personList;
	eventRecord[@"activity"] = activityRef;
	eventRecord[@"minPeople"] = [NSNumber numberWithInt:event.requiredParticipants];
	eventRecord[@"maxPeople"] = [NSNumber numberWithInt:event.maxParticipants];
	eventRecord[@"category"] = event.category;
	eventRecord[@"date"] = event.date;
	eventRecord[@"shift"] = event.shift;
	eventRecord[@"sex"] = event.sex;
	
	[publicDatabase saveRecord:eventRecord completionHandler:^(CKRecord *eventRecord, NSError *error){
		if (error) {
			NSLog(@"Record Party not created. Error: %@", error.description);
		}
		NSLog(@"Event record created");
	}];
	
}

- (void)connectToPublicDatabase{
	if (container == nil) container = [CKContainer defaultContainer];
	if (publicDatabase == nil) publicDatabase = [container publicCloudDatabase];
}

@end
