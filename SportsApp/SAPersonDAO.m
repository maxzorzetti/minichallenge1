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

- (void)getPeopleFromEmails:(NSArray<NSString *> *_Nonnull)emails handler:(void (^_Nonnull)(NSArray<CKRecord *> *_Nullable, NSError *_Nullable))handler{
    [self connectToPublicDatabase];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"email IN %@", emails];
    CKQuery *query = [[CKQuery alloc]initWithRecordType:@"SAPerson" predicate:predicate];
    
    [publicDatabase performQuery:query inZoneWithID:nil completionHandler:handler];
}

- (void)connectToPublicDatabase{
    if (container == nil) container = [CKContainer defaultContainer];
    if (publicDatabase == nil) publicDatabase = [container publicCloudDatabase];
}

@end
