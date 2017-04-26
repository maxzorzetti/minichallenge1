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

@implementation SAEventConnector

+ (void)getEventById:(CKRecordID *)eventId handler:(void (^)(SAEvent * _Nullable event, NSError * _Nullable error))handler{
	SAEventDAO *eventDAO = [SAEventDAO new];
    [eventDAO getEventById:(eventId) handler:^(CKRecord * eventRecord, NSError * erro) {
        if(erro){
            NSLog(@"%@", erro.description);
            handler(nil, erro);
        }
        else{
            SAEvent *eventFromDb = [[SAEvent alloc]initWithName:eventRecord[@"name"] AndRequiredParticipants:eventRecord[@"minPeople"] AndMaxParticipants:eventRecord[@"maxPeople"] AndActivity:@"FALTA PEGAR A ACTIVITY" andId:eventRecord.recordID andCategory:eventRecord[@"category"] AndSex:eventRecord[@"sex"] AndDates:eventRecord[@"date"]];
            
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
                SAEvent *eventFromDb = [[SAEvent alloc]initWithName:event[@"name"] AndRequiredParticipants:event[@"minPeople"] AndMaxParticipants:event[@"maxPeople"] AndActivity:@"FALTA PEGAR A ACTIVITY" andId:event.recordID andCategory:event[@"category"] AndSex:event[@"sex"] AndDates:event[@"date"]];
                [arrayOfEvents addObject:eventFromDb];
            }
            handler(arrayOfEvents, nil);
        }
    }];
}


@end
