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
        if(!erro){
            SAEvent *eventFromDb = [self getEventFromRecord:eventRecord];
            
            if (eventFromDb) {
                //save or update event to user defaults
                [SAEvent saveToDefaults:eventFromDb];
            }
            
            handler(eventFromDb, erro);
        }
    }];
}

+ (void)getEventsByActivity:(SAActivity *_Nonnull)activity handler:(void (^ _Nonnull)(NSArray * _Nullable events, NSError *_Nullable error))handler{
    SAEventDAO *eventDAO = [SAEventDAO new];
    
    [eventDAO getAvailableEventsOfActivity:activity completionHandler:^(NSArray * _Nonnull events, NSError * _Nonnull error) {
        if(!error){
            NSMutableArray *arrayOfEvents = [NSMutableArray new];
            for (CKRecord *event in events) {
                SAEvent *eventFromDb = [self getEventFromRecord:event];
                
                //save or update event to user defaults
                [SAEvent saveToDefaults:eventFromDb];
                
                [arrayOfEvents addObject:eventFromDb];
            }
            handler(arrayOfEvents, error);
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
                
                //save or update event to user defaults
                [SAEvent saveToDefaults:event];
                
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
                
                //save or update event to user defaults
                [SAEvent saveToDefaults:event];
                
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
                
                //save or update event to user defaults
                [SAEvent saveToDefaults:event];
                
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
                
                //save or update event to user defaults
                [SAEvent saveToDefaults:event];
                
                [arrayOfEvents addObject:event];
            }
        }
        handler(arrayOfEvents, error);
    }];
}

+ (void)getEventsWhereUserIsAnInvitee:(CKRecordID *_Nonnull)userId handler:(void (^_Nonnull)(NSArray<SAEvent *>* _Nullable events, NSError * _Nullable error))handler{
    SAEventDAO *eventDAO = [SAEventDAO new];
    CKReference *userRef = [[CKReference alloc]initWithRecordID:userId action:CKReferenceActionNone];
    [eventDAO getEventsWhereUserIsAnInvitee:userRef handler:^(NSArray<CKRecord *> * _Nullable events, NSError * _Nullable error) {
        if(!error){
            NSMutableArray *arrayOfEvents = [NSMutableArray new];
            for (CKRecord *event in events) {
                SAEvent *eventFromDb = [self getEventFromRecord:event];
                
                //save or update event to user defaults
                [SAEvent saveToDefaults:eventFromDb];
                
                [arrayOfEvents addObject:eventFromDb];
            }
            handler(arrayOfEvents, error);
        }
    }];
}

+ (void)registerParticipant:(SAPerson *)participant inEvent:(SAEvent *)event handler:(void (^)(SAEvent * _Nullable, NSError * _Nullable))handler{
    [event addParticipant:participant];
    
    CKRecord *eventRecord = [SAEventConnector getEventRecordFromEvent:event];
    
    SAEventDAO *dao = [SAEventDAO new];
    [dao updateEvent:eventRecord handler:^(CKRecord * _Nullable eventAnswer, NSError * _Nullable error2) {
        if (!error2 && eventAnswer) {
            SAEvent *eventToReturnToHandler = [SAEventConnector getEventFromRecord:eventAnswer];
            
            //save or update event to user defaults
            [SAEvent saveToDefaults:eventToReturnToHandler];
            
            handler(eventToReturnToHandler, error2);
        }else{
            handler(nil, error2);
        }
    }];
}

+ (void)denyInvite:(SAPerson *)participant ofEvent:(SAEvent *)event handler:(void (^)(SAEvent * _Nullable, NSError * _Nullable))handler{
    [event addNotGoingPerson:participant];
    
    CKRecord *eventRecord = [SAEventConnector getEventRecordFromEvent:event];
    
    SAEventDAO *dao = [SAEventDAO new];
    [dao updateEvent:eventRecord handler:^(CKRecord * _Nullable eventAnswer, NSError * _Nullable error2) {
        if (!error2 && eventAnswer) {
            SAEvent *eventToReturnToHandler = [SAEventConnector getEventFromRecord:eventAnswer];
            
            //save or update event to user defaults
            [SAEvent saveToDefaults:eventToReturnToHandler];
            
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
            
            //save or update event to user defaults
            [SAEvent saveToDefaults:eventToReturnToHandler];
            
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
    NSMutableArray *inviteesRef = [NSMutableArray new];
    NSMutableArray *notGoingPeopleRef = [NSMutableArray new];
    NSMutableArray *notConfirmedInviteesRef = [NSMutableArray new];
    
    for (SAPerson *participant in event.participants) {
        CKReference *participantRef = [[CKReference alloc]initWithRecordID:participant.personId action:CKReferenceActionNone];
        [participantsRef addObject:participantRef];
    }
    for (SAPerson *invitee in event.invitees) {
        CKReference *inviteeRef = [[CKReference alloc]initWithRecordID:invitee.personId action:CKReferenceActionNone];
        [inviteesRef addObject:inviteeRef];
    }
    for (SAPerson *notGoingPerson in event.notGoing) {
        CKReference *notGoingPersonRef = [[CKReference alloc]initWithRecordID:notGoingPerson.personId action:CKReferenceActionNone];
        [notGoingPeopleRef addObject:notGoingPersonRef];
    }
    for (SAPerson *notConfirmedInvitee in event.inviteesNotConfirmed) {
        CKReference *notConfirmedInviteeRef = [[CKReference alloc]initWithRecordID:notConfirmedInvitee.personId action:CKReferenceActionNone];
        [notConfirmedInviteesRef addObject:notConfirmedInviteeRef];
    }
    
    eventRecord[@"invitees"] = [NSArray arrayWithArray:inviteesRef];
    eventRecord[@"activity"] = activityRef;
    eventRecord[@"category"] = event.category;
    eventRecord[@"date"] = event.date;
    eventRecord[@"maxPeople"] = event.maxPeople;
    eventRecord[@"minPeople"] = event.minPeople;
    eventRecord[@"name"] = event.name;
    eventRecord[@"owner"] = ownerRef;
    eventRecord[@"participants"] = [NSArray arrayWithArray:participantsRef];
    eventRecord[@"notGoing"] = [NSArray arrayWithArray:notGoingPeopleRef];
    eventRecord[@"inviteesNotConfirmed"] = [NSArray arrayWithArray:notConfirmedInviteesRef];
    eventRecord[@"sex"] = event.sex;
    eventRecord[@"shift"] = event.shift;
    eventRecord[@"location"] = event.location;
    eventRecord[@"distance"] = event.distance;
    eventRecord[@"eventDescription"] = event.eventDescription;
    
    return eventRecord;
}



+ (SAEvent *)getEventFromRecord:(CKRecord *)event{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    SAEvent *eventFromRecord = [[SAEvent alloc]initWithName:event[@"name"] andRequiredParticipants:event[@"minPeople"] andMaxParticipants:event[@"maxPeople"] andActivity:nil andId:event.recordID andCategory:event[@"category"] andSex:event[@"sex"] andDate:event[@"date"] andParticipants:nil andInvitees:nil andLocation:event[@"location"] andDistance:event[@"distance"]];

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
    
    //CHECK IF INVITEES IN NSUserdefaustao
    NSMutableArray *arrayOfInvitees = [NSMutableArray new];
    NSArray *arrayOfInviteeReferences = event[@"invitees"];
    
    for (CKReference *inviteeRef in arrayOfInviteeReferences) {
        CKRecordID *inviteeId = inviteeRef.recordID;
        SAPerson *inviteeToAdd;
        
        for (NSDictionary *ownerDic in arrayOfUsers) {
            if ([[ownerDic objectForKey:@"personId"] isEqualToString:inviteeId.recordName]) {
                inviteeToAdd = [NSKeyedUnarchiver unarchiveObjectWithData:ownerDic[@"personData"]];
            }
        }
        
        //nothing found, add referenced person to fetch in database in event description view
        if (!inviteeToAdd) {
            inviteeToAdd = [[SAPerson alloc]initWithName:nil personId:inviteeId email:nil telephone:nil facebookId:nil andPhoto:nil andEvents:nil andGender:nil];
        }
        [arrayOfInvitees addObject:inviteeToAdd];
    }
    
    //CHECK IF NOT GOING PEOPLE IN NSUserdefaustao
    NSMutableArray *arrayOfNotGoingPeople = [NSMutableArray new];
    NSArray *arrayOfNotGoingPeopleReferences = event[@"notGoing"];
    
    for (CKReference *notGoingRef in arrayOfNotGoingPeopleReferences) {
        CKRecordID *notGoingId = notGoingRef.recordID;
        SAPerson *notGoingToAdd;
        
        for (NSDictionary *ownerDic in arrayOfUsers) {
            if ([[ownerDic objectForKey:@"personId"] isEqualToString:notGoingId.recordName]) {
                notGoingToAdd = [NSKeyedUnarchiver unarchiveObjectWithData:ownerDic[@"personData"]];
            }
        }
        
        //nothing found, add referenced person to fetch in database in event description view
        if (!notGoingToAdd) {
            notGoingToAdd = [[SAPerson alloc]initWithName:nil personId:notGoingId email:nil telephone:nil facebookId:nil andPhoto:nil andEvents:nil andGender:nil];
        }
        [arrayOfNotGoingPeople addObject:notGoingToAdd];
    }
    
    
    //CHECK IF NOT CONFIRMED PEOPLE IN NSUserdefaustao
    NSMutableArray *arrayOfNotConfirmedInvitees = [NSMutableArray new];
    NSArray *arrayOfNotConfirmedInviteesReferences = event[@"inviteesNotConfirmed"];
    
    for (CKReference *notConfirmedRef in arrayOfNotConfirmedInviteesReferences) {
        CKRecordID *notConfirmedId = notConfirmedRef.recordID;
        SAPerson *notConfirmedToAdd;
        
        for (NSDictionary *ownerDic in arrayOfUsers) {
            if ([[ownerDic objectForKey:@"personId"] isEqualToString:notConfirmedId.recordName]) {
                notConfirmedToAdd = [NSKeyedUnarchiver unarchiveObjectWithData:ownerDic[@"personData"]];
            }
        }
        
        //nothing found, add referenced person to fetch in database in event description view
        if (!notConfirmedToAdd) {
            notConfirmedToAdd = [[SAPerson alloc]initWithName:nil personId:notConfirmedId email:nil telephone:nil facebookId:nil andPhoto:nil andEvents:nil andGender:nil];
        }
        [arrayOfNotConfirmedInvitees addObject:notConfirmedToAdd];
    }
    [eventFromRecord setEventDescription:event[@"eventDescription"]];
    [eventFromRecord addInvitees:arrayOfNotConfirmedInvitees];
    [eventFromRecord addNotGoingPeople:arrayOfNotGoingPeople];
    [eventFromRecord addInviteesThatAreParticipants:arrayOfInvitees];
    [eventFromRecord setOwner:ownerToSetToEvent];
    [eventFromRecord setActivity:activityToSetToEvent];
    [eventFromRecord addParticipants:arrayOfParticipants];
    
    return eventFromRecord;
}




//THIS SHOULD BE IN ANOTHER CLASS
+ (void)fetchRecordByRecordId:(CKRecordID *_Nonnull)recordId handler:(void (^_Nonnull)(CKRecord * _Nullable record, NSError * _Nullable error))handler{
    SAEventDAO *dao = [SAEventDAO new];
    
    [dao fetchRecordByRecordId:recordId handler:^(CKRecord * _Nullable recordFetched, NSError * _Nullable errorFetched) {
        handler(recordFetched, errorFetched);
    }];
}


@end
