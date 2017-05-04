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
#import "SAPersonDAO.h"
#import "SAPersonConnector.h"

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

+ (void)getEventsByPersonId:(CKRecordID *_Nonnull)userId handler:(void (^_Nonnull)(NSArray<SAEvent *>* _Nullable events, NSError * _Nullable error))handler{
    CKReference *ref = [[CKReference alloc]initWithRecordID:userId action:CKReferenceActionNone];
    
    SAEventDAO *dao = [SAEventDAO new];
    [dao getEventsByUserReference:ref handler:^(NSArray<CKRecord *> * _Nullable eventRecords, NSError * _Nullable error) {
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

+ (void)getPastEventsByPersonId:(CKRecordID *_Nonnull)userId handler:(void (^_Nonnull)(NSArray<SAEvent *>* _Nullable events, NSError * _Nullable error))handler{
    CKReference *ref = [[CKReference alloc]initWithRecordID:userId action:CKReferenceActionNone];
    
    SAEventDAO *dao = [SAEventDAO new];
    [dao getPastEventsByUserReference:ref handler:^(NSArray<CKRecord *> * _Nullable eventRecords, NSError * _Nullable error) {
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

+ (void)registerParticipant:(SAPerson *)participant inEvent:(SAEvent *)event handler:(void (^)(SAEvent * _Nullable, NSError * _Nullable))handler{
    [event addParticipant:participant];
    CKRecord *eventRecord = [SAEventConnector getEventRecordFromEvent:event];
    
    SAEventDAO *dao = [SAEventDAO new];
    [dao updateEvent:eventRecord handler:^(CKRecord * _Nullable eventAnswer, NSError * _Nullable error2) {
        if (!error2 && eventAnswer) {
            SAEvent *eventToReturnToHandler = [SAEventConnector getEventFromRecord:eventAnswer];
            
            handler(eventToReturnToHandler, error2);
        }else{
            handler(nil, error2);
        }
    }];
}

+ (void)removeParticipant:(SAPerson *)participant ofEvent:(SAEvent *)event handler:(void (^)(SAEvent * _Nullable, NSError * _Nullable))handler{
    [event removeParticipant:participant];
    CKRecord *eventRecord = [SAEventConnector getEventRecordFromEvent:event];
    
    SAEventDAO *dao = [SAEventDAO new];
    [dao updateEvent:eventRecord handler:^(CKRecord * _Nullable eventAnswer, NSError * _Nullable error2) {
        if (!error2 && eventAnswer) {
            SAEvent *eventToReturnToHandler = [SAEventConnector getEventFromRecord:eventAnswer];
            
            handler(eventToReturnToHandler, error2);
        }else{
            handler(nil, error2);
        }
    }];
}

+ (CKRecord *)getEventRecordFromEvent:(SAEvent *)event{
    CKRecord *eventRecord = [[CKRecord alloc]initWithRecordType:@"Event" recordID:event.eventId];
    CKReference *activityRef = [[CKReference alloc]initWithRecordID:event.activity.activityId action:CKReferenceActionNone];
    CKReference *ownerRef = [[CKReference alloc] initWithRecordID:event.owner.personId action:CKReferenceActionNone];
    NSMutableArray *participantsRef = [NSMutableArray new];
    
    for (SAPerson *participant in event.participants) {
        CKReference *participantRef = [[CKReference alloc]initWithRecordID:participant.personId action:CKReferenceActionNone];
        [participantsRef addObject:participantRef];
    }
    
    eventRecord[@"activity"] = activityRef;
    eventRecord[@"category"] = event.category;
    eventRecord[@"date"] = event.date;
    eventRecord[@"maxPeople"] = event.maxPeople;
    eventRecord[@"minPeople"] = event.minPeople;
    eventRecord[@"name"] = event.name;
    eventRecord[@"owner"] = ownerRef;
    eventRecord[@"participants"] = [NSArray arrayWithArray:participantsRef];
    eventRecord[@"sex"] = event.sex;
    eventRecord[@"shift"] = event.shift;
    eventRecord[@"location"] = event.location;
    eventRecord[@"distance"] = event.distance;
    
    return eventRecord;
}



+ (SAEvent *)getEventFromRecord:(CKRecord *)event{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    SAEvent *eventFromRecord = [[SAEvent alloc]initWithName:event[@"name"] andRequiredParticipants:event[@"minPeople"] andMaxParticipants:event[@"maxPeople"] andActivity:nil andId:event.recordID andCategory:event[@"category"] andSex:event[@"sex"] andDate:event[@"date"] andParticipants:nil andLocation:event[@"location"] andDistance:event[@"distance"]];

    //CHECK IF ACTIVITY IS IN NSUserdefaustao
    NSArray *arrayOfDictionaries = [userDefaults arrayForKey:@"ArrayOfDictionariesContainingTheActivities"];
    
    CKReference *activityRefence = event[@"activity"];
    CKRecordID *activityId = activityRefence.recordID;
    SAActivity *activityToSetToEvent;
    
    for (NSDictionary *activityDic in arrayOfDictionaries) {
        if ([[activityDic objectForKey:@"activityId"] isEqualToString:activityId.recordName]) {
            activityToSetToEvent = [NSKeyedUnarchiver unarchiveObjectWithData:activityDic[@"activityData"]];
        }
    }
    //USE placeholder activity picture
    if (activityToSetToEvent == nil) {
        activityToSetToEvent = [[SAActivity alloc]initWithName:nil minimumPeople:nil maximumPeople:nil picture:[NSData dataWithContentsOfFile:@"img_placeholder.png"] AndActivityId:activityId  andAuxiliarVerb:nil andPictureWhite:[NSData dataWithContentsOfFile:@"img_placeholder.png"]];
    }
    
    //CHECK IF OWNER IS IN NSUserdefaults
    NSArray *arrayOfUsers = [userDefaults arrayForKey:@"ArrayOfDictionariesContainingPeople"];
    
    CKReference *userRefence = event[@"owner"];
    CKRecordID *userId = userRefence.recordID;
    SAPerson *ownerToSetToEvent;
    
    for (NSDictionary *ownerDic in arrayOfUsers) {
        if ([[ownerDic objectForKey:@"personId"] isEqualToString:userId.recordName]) {
            ownerToSetToEvent = [NSKeyedUnarchiver unarchiveObjectWithData:ownerDic[@"personData"]];
        }
    }
    
    //USE placeholder profile picture
    if(ownerToSetToEvent==nil){
        CKReference *ref = event[@"owner"];
        ownerToSetToEvent = [[SAPerson alloc]initWithName:nil personId:ref.recordID email:nil telephone:nil facebookId:nil andPhoto:nil andEvents:nil andGender:nil];
    }
    
    //CHECK IF PARTICIPANTS IN NSUserdefaustao
    NSMutableArray *arrayOfParticipants = [NSMutableArray new];
    NSArray *arrayOfParticipantReferences = event[@"participants"];
    
    for (CKReference *participantRef in arrayOfParticipantReferences) {
        CKRecordID *participantId = participantRef.recordID;
        SAPerson *participantToAdd;
        
        for (NSDictionary *ownerDic in arrayOfUsers) {
            if ([[ownerDic objectForKey:@"personId"] isEqualToString:participantId.recordName]) {
                participantToAdd = [NSKeyedUnarchiver unarchiveObjectWithData:ownerDic[@"personData"]];
            }
        }
        
        //nothing found, add referenced person to fetch in database in event description view
        if (!participantToAdd) {
            participantToAdd = [[SAPerson alloc]initWithName:nil personId:participantId email:nil telephone:nil facebookId:nil andPhoto:nil andEvents:nil andGender:nil];
        }
        [arrayOfParticipants addObject:participantToAdd];
    }
    
    [eventFromRecord setOwner:ownerToSetToEvent];
    [eventFromRecord setActivity:activityToSetToEvent];
    [eventFromRecord addParticipants:arrayOfParticipants];
    
    return eventFromRecord;
}



@end
