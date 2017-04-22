//
//  Matchmaker.m
//  SportsApp
//
//  Created by Max Zorzetti on 19/04/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "SAMatchmaker.h"
#import <CloudKit/CloudKit.h>
#import "SAParty.h"
#import "SAPerson.h"

@implementation SAMatchmaker

+ (void)enterMatchMakingWithParty:(SAParty *)party{
    CKContainer *container = [CKContainer defaultContainer];
    CKDatabase *publicDatabase = [container publicCloudDatabase];
    
    CKRecord *partyRecord = [[CKRecord alloc]initWithRecordType:@"SAParty"];
    
    for (SAPerson *person in party.people) {
        CKReference *ref = [[CKReference alloc]initWithRecordID:person.id action:CKReferenceActionNone];
        [partyRecord setObject:ref forKey:@"people"];
    }
    
    partyRecord[@"minPeople"] = [NSNumber numberWithInt:party.minParticipants];
    partyRecord[@"maxPeople"] = [NSNumber numberWithInt:party.maxParticipants];
    partyRecord[@"activity"] = party.activity;
    
    [publicDatabase saveRecord:partyRecord completionHandler:^(CKRecord *artworkRecord, NSError *error){
        if (error) {
            NSLog(@"Record Party not created. Error: %@", error.description);
        }
        NSLog(@"Record Party created");
    }];
    
    
}

@end
