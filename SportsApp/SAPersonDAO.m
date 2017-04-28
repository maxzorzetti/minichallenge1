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

- (void)connectToPublicDatabase{
    if (container == nil) container = [CKContainer defaultContainer];
    if (publicDatabase == nil) publicDatabase = [container publicCloudDatabase];
}

@end
