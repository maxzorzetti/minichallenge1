//
//  SAPersonConnector.m
//  SportsApp
//
//  Created by Bruno Scheltzke on 26/04/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "SAPersonConnector.h"
#import "SAPersonDAO.h"
#import "SAPerson.h"

@implementation SAPersonConnector

+ (void)getPeopleFromEmails:(NSArray<NSString *> *_Nonnull)emails handler:(void (^_Nonnull)(NSArray<SAPerson *> *_Nullable, NSError *_Nullable))handler{
    SAPersonDAO *personDAO = [SAPersonDAO new];
    
    [personDAO getPeopleFromEmails:emails handler:^(NSArray<CKRecord *> * _Nullable personRecords, NSError * _Nullable error) {
        if (!error) {
            NSMutableArray *arrayOfPeople = [NSMutableArray new];
            for (CKRecord *personRecord in personRecords) {
                SAPerson *person = [self getPersonFromRecord:personRecord];
                [arrayOfPeople addObject:person];
            }
            handler(arrayOfPeople, error);
        }
    }];
}

+ (SAPerson *)getPersonFromRecord:(CKRecord *)personRecord{
    SAPerson *person = [[SAPerson alloc]initWithName:personRecord[@"name"] personId:personRecord.recordID email:personRecord[@"email"] telephone:personRecord[@"telephone"] andEvents:nil];
    return person;
}



@end
