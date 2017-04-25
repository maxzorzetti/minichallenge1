//
//  EventDAO.m
//  SportsApp
//
//  Created by Bruno Scheltzke on 24/04/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "SAEventDAO.h"
#import "SAActivity.h"
#import "SAEvent.h"
#import <CloudKit/CloudKit.h>

@implementation SAEventDAO

CKContainer *container;
CKDatabase *publicDatabase;

- (void)getEventById:(CKRecordID *)eventId handler:(void (^)(CKRecord * _Nullable record, NSError * _Nullable error))handler{
	[self connectToDefaultDatabase];
    
    [publicDatabase fetchRecordWithID:eventId completionHandler:^(CKRecord *eventRecord, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error.description);
            handler(nil, error);
        }
        else {
            handler(eventRecord,error);
        }
    }];
}

- (void)getAvailableEventsOfActivity:(SAActivity *)activity completionHandler:(void (^)(NSArray *, NSError *))handler{
	[self connectToDefaultDatabase];
	
	NSPredicate *activityPredicate = [NSPredicate predicateWithFormat:@"activity.name = %@", activity.name];
	CKQuery *activitiesQuery = [[CKQuery alloc]initWithRecordType:@"SAEvent" predicate:activityPredicate];
	
	[publicDatabase performQuery:activitiesQuery inZoneWithID:nil completionHandler:handler];
}

- (SAEvent *)getEventFromRecord:(CKRecord *)record{
	SAEvent *event ;//= [[SAEvent alloc] initWithName:<#(NSString *)#> AndRequiredParticipants:<#(int)#> AndMaxParticipants:<#(int)#> AndActivity:<#(SAActivity *)#> andId:<#(CKRecordID *)#> andCategory:<#(NSString *)#> AndSex:<#(NSString *)#> AndDates:<#(NSArray *)#>];
	NSString *name = (NSString *)record[@"name"];
	int maxPeople = (int)record[@"maxPeople"];
	int minPeople = (int)record[@"minPeople"];
	NSDate *date = (NSDate *)record[@"date"];
	NSString *category = (NSString *)record[@"category"];
	
	CKReference *activityReference = (CKReference *)record[@"activity"];
	//event.activity = record[@""];
	
	return event;
}

- (void)connectToDefaultDatabase{
	if (container == nil) container = [CKContainer defaultContainer];
	if (publicDatabase == nil) publicDatabase = [container publicCloudDatabase];
}

@end
