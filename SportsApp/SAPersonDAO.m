//
//  SAPersonCore.m
//  SportsApp
//
//  Created by Bruno Scheltzke on 2017-04-23.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "SAPersonDAO.h"
#import <CloudKit/CloudKit.h>


@implementation SAPersonDAO
CKContainer *container;
CKDatabase *publicDatabase;

- (void)loginWithUsername:(NSString *_Nonnull)username andPassword:(NSString *_Nonnull)password handler:(void (^_Nonnull)(CKRecord *_Nullable, NSError *_Nullable))handler{
    [self connectToPublicDatabase];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"email =%@", username];
    CKQuery *query = [[CKQuery alloc]initWithRecordType:@"SAPerson" predicate:predicate];
    
    [publicDatabase performQuery:query inZoneWithID:nil completionHandler:^(NSArray<CKRecord *> * _Nullable results, NSError * _Nullable error) {
        if(!error && !results){
            CKRecord *personRecord = [results firstObject];
            CKReference *ref = [[CKReference alloc]initWithRecordID:personRecord.recordID action:CKReferenceActionNone];
            NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"userId = %@ AND hash = %@", ref, password];
            CKQuery *query2 = [[CKQuery alloc]initWithRecordType:@"SAIdentity" predicate:predicate2];
            
            [publicDatabase performQuery:query2 inZoneWithID:nil completionHandler:^(NSArray<CKRecord *> * _Nullable results2, NSError * _Nullable error2) {
                if(!error2 && !results2){
                    handler([results2 firstObject], error2);
                }else{
                    handler(nil, error2);
                }
            }];
        }else{
            handler(nil, error);
        }
    }];
}


- (void)getPeopleFromFacebookIds:(NSArray<NSString *> *_Nonnull)facebookIds handler:(void (^_Nonnull)(NSArray<CKRecord *> *_Nullable, NSError *_Nullable))handler{
    [self connectToPublicDatabase];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"facebookId IN %@", facebookIds];
    CKQuery *query = [[CKQuery alloc]initWithRecordType:@"SAPerson" predicate:predicate];
    
    [publicDatabase performQuery:query inZoneWithID:nil completionHandler:handler];
}

- (void)getPersonFromId:(CKRecordID *_Nonnull)personId handler:(void (^_Nonnull)(CKRecord *_Nullable, NSError *_Nullable))handler{
    [self connectToPublicDatabase];
    
    [publicDatabase fetchRecordWithID:personId completionHandler:handler];
}

- (void)getPeopleFromIds:(NSArray<CKRecordID *> *_Nonnull)personIds handler:(void (^_Nonnull)(NSArray<CKRecord *> *_Nullable, NSError *_Nullable))handler{
    [self connectToPublicDatabase];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"recordID IN %@", personIds];
    CKQuery *query = [[CKQuery alloc]initWithRecordType:@"SAPerson" predicate:predicate];
    
    [publicDatabase performQuery:query inZoneWithID:nil completionHandler:handler];
}

- (void) savePerson:(CKRecord *)user handler:(void (^)(CKRecord * _Nullable, NSError * _Nullable))handler{
    [self connectToPublicDatabase];
    
    NSArray<CKRecord*> *groupRecordArray = [[NSArray alloc] initWithObjects:user, nil];
    CKModifyRecordsOperation *updatedGroup = [[CKModifyRecordsOperation alloc] initWithRecordsToSave:groupRecordArray recordIDsToDelete:nil];
    updatedGroup.savePolicy = CKRecordSaveAllKeys;
    updatedGroup.qualityOfService = NSQualityOfServiceUserInitiated;
    updatedGroup.modifyRecordsCompletionBlock=
    ^(NSArray * savedRecords, NSArray * deletedRecordIDs, NSError * operationError){
        handler([savedRecords firstObject], operationError);
    };
    
    [publicDatabase addOperation:updatedGroup];
}

- (void)connectToPublicDatabase{
    if (container == nil) container = [CKContainer defaultContainer];
    if (publicDatabase == nil) publicDatabase = [container publicCloudDatabase];
}

@end
