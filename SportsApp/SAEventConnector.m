//
//  SAEventConnector.m
//  SportsApp
//
//  Created by Bruno Scheltzke on 2017-04-25.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "SAEventConnector.h"
#import "SAEvent.h"
#import "EventDAO.h"
#import <CloudKit/CloudKit.h>


@implementation SAEventConnector

+ (void)getEventById:(CKRecordID *)eventId handler:(void (^)(SAEvent * _Nullable event, NSError * _Nullable error))handler{
    [EventDAO getEventById:(eventId) handler:^(CKRecord * eventRecord, NSError * erro) {
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

@end
