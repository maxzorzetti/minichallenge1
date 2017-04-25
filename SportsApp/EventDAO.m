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

+ (void)getEventById:(CKRecordID *)eventId handler:(void (^)(CKRecord * _Nullable record, NSError * _Nullable error))handler{
    CKContainer *container = [CKContainer defaultContainer];
    CKDatabase *publicDatabase = [container publicCloudDatabase];
    
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

@end
