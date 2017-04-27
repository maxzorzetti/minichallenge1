//
//  SAEventConnector.m
//  SportsApp
//
//  Created by Bruno Scheltzke on 2017-04-25.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "SAEventConnector.h"
#import "SAEvent.h"
#import "SAEventDAO.h"
#import <CloudKit/CloudKit.h>
#import "SAActivity.h"
#import "SAPerson.h"

@implementation SAEventConnector

+ (void)getEventById:(CKRecordID *)eventId handler:(void (^)(SAEvent * _Nullable event, NSError * _Nullable error))handler{
	SAEventDAO *eventDAO = [SAEventDAO new];
    [eventDAO getEventById:(eventId) handler:^(CKRecord * eventRecord, NSError * erro) {
        if(erro){
            NSLog(@"%@", erro.description);
            handler(nil, erro);
        }
        else{
            SAEvent *eventFromDb = [self getEventFromRecord:eventRecord];
            
            handler(eventFromDb, erro);
        }
    }];
}

+ (void)getEventsByActivity:(SAActivity *_Nonnull)activity handler:(void (^ _Nonnull)(NSArray * _Nullable events, NSError *_Nullable error))handler{
    SAEventDAO *eventDAO = [SAEventDAO new];
    
    [eventDAO getAvailableEventsOfActivity:activity completionHandler:^(NSArray * _Nonnull events, NSError * _Nonnull error) {
        if(error){
            NSLog(@"%@", error.description);
            handler(nil, error);
        }else{
            NSMutableArray *arrayOfEvents = [NSMutableArray new];
            for (CKRecord *event in events) {
                SAEvent *eventFromDb = [self getEventFromRecord:event];
                [arrayOfEvents addObject:eventFromDb];
            }
            handler(arrayOfEvents, nil);
        }
    }];
}

+ (void)getComingEventsBasedOnFavoriteActivities:(NSArray<SAActivity *>*_Nonnull)activities AndCurrentLocation:(CLLocation *_Nonnull)location AndRadiusOfDistanceDesiredInMeters:(int)distance handler:(void (^_Nonnull)(NSArray<SAEvent *>* _Nullable events, NSError * _Nullable error))handler{
    
    NSMutableArray *arrayOfActivityReferences = [NSMutableArray new];
    
    for (SAActivity *activity in activities) {
        CKReference *ref = [[CKReference alloc]initWithRecordID:activity.activityId action:CKReferenceActionNone];
        [arrayOfActivityReferences addObject:ref];
    }
    
    SAEventDAO *eventDAO = [SAEventDAO new];
    [eventDAO getNext24hoursInterestedEventsWithActivities:arrayOfActivityReferences AndCurrentLocation:location andDistanceInMeters:distance handler:^(NSArray<CKRecord *> * _Nullable events, NSError * _Nullable error) {
        
        NSMutableArray *eventsFromRecord = [NSMutableArray new];
        if (!error) {
            for (CKRecord *recordEvent in events) {
                SAEvent *event = [self getEventFromRecord:recordEvent];
                [eventsFromRecord addObject:event];
            }
        }
        handler(eventsFromRecord, error);
    }];
}

+ (void)getSugestedEventsWithActivities:(NSArray<SAActivity *>*_Nullable)interestedReferencedActivities AndCurrentLocation:(CLLocation *_Nonnull)usersLocation andDistanceInMeters:(int)proximity AndFriends:(NSArray<SAPerson *>*_Nonnull)friends handler:(void (^_Nonnull)(NSArray<SAEvent *>* _Nullable events, NSError * _Nullable error))handler{
    SAEventDAO *dao = [SAEventDAO new];
    
    NSMutableArray *arrayOfPersonReferences = [NSMutableArray new];
    
    for (SAPerson *person in friends) {
        CKReference *ref = [[CKReference alloc]initWithRecordID:person.personId action:CKReferenceActionNone];
        [arrayOfPersonReferences addObject:ref];
    }
    
    [dao getSugestedEventsWithActivities:nil AndCurrentLocation:usersLocation andDistanceInMeters:proximity AndFriends:arrayOfPersonReferences handler:^(NSArray<CKRecord *> * _Nullable eventRecords, NSError * _Nullable error) {
        NSMutableArray *arrayOfEvents = [NSMutableArray new];
        if (!error) {
            for (CKRecord *eventRecord in eventRecords) {
                SAEvent *event = [self getEventFromRecord:eventRecord];
                [arrayOfEvents addObject:event];
            }
        }
        handler(arrayOfEvents, error);
    }];
}


+ (SAEvent *)getEventFromRecord:(CKRecord *)event{
    SAEvent *eventFromRecord = [[SAEvent alloc]initWithName:event[@"name"] andRequiredParticipants:(int)event[@"minPeople"] andMaxParticipants:(int)event[@"maxPeople"] andActivity:nil andId:event.recordID andCategory:event[@"category"] andSex:event[@"sex"] andDate:event[@"date"]];
    
    return eventFromRecord;
}



@end
