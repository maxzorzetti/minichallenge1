//
//  EventDAO.m
//  SportsApp
//
//  Created by Bruno Scheltzke on 24/04/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "EventDAO.h"
#import "SAEvent.h"
#import <CloudKit/CloudKit.h>

@implementation EventDAO

+ (SAEvent *)getEventById:(CKRecordID *)eventId{
    CKContainer *container = [CKContainer defaultContainer];
    CKDatabase *publicDatabase = [container publicCloudDatabase];
    
    [publicDatabase fetchRecordWithID:eventId completionHandler:^(CKRecord *eventRecord, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error.description);
        }
        else {
            SAEvent *event = [[SAEvent alloc]initWithName:eventRecord[@"name"] AndRequiredParticipants:eventRecord[@"minPeople"] AndMaxParticipants:eventRecord[@"maxPeople"] AndActivity:@"FALTA PEGAR A ACTIVITY" andId:eventRecord.recordID andCategory:eventRecord[@"category"] AndSex:eventRecord[@"sex"] AndDates:eventRecord[@"date"]];
            //return event;
        }
    }];

    
    
    
    
    return nil;
}

@end
