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
                [eventsFromRecord addObject:events];
            }
        }
        handler(eventsFromRecord, error);
    }];
}


+ (SAEvent *)getEventFromRecord:(CKRecord *)event{
    SAEvent *eventFromRecord = [[SAEvent alloc]initWithName:event[@"name"] andRequiredParticipants:event[@"minPeople"] andMaxParticipants:event[@"maxPeople"] andActivity:@"FALTA PEGAR A ACTIVITY" andId:event.recordID andCategory:event[@"category"] andSex:event[@"sex"] andDate:event[@"date"]];
    
    return eventFromRecord;
}



@end
