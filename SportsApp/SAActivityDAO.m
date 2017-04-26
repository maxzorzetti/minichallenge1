//
//  ActivityDAO.m
//  SportsApp
//
//  Created by Bruno Scheltzke on 2017-04-25.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "SAActivityDAO.h"
#import <CloudKit/CloudKit.h>

@implementation SAActivityDAO

CKContainer *container;
CKDatabase *publicDatabase;

- (void)getAllActivitiesHandler:(void (^_Nonnull)(NSArray *_Nullable, NSError *_Nullable))handler{
    [self connectToPublicDatabase];
    
    NSPredicate *predicate = [NSPredicate predicateWithValue:YES];
    CKQuery *activitiesQuery = [[CKQuery alloc]initWithRecordType:@"SAActivity" predicate:predicate];
    
    [publicDatabase performQuery:activitiesQuery inZoneWithID:nil completionHandler:handler];
}


- (void)getActivityByActivityId:(CKRecordID *_Nonnull)activityId handler:(void (^_Nonnull)(CKRecord *_Nullable, NSError *_Nullable))handler{
    [self connectToPublicDatabase];
    
    [publicDatabase fetchRecordWithID:activityId completionHandler:^(CKRecord *activityRecord, NSError *error) {
        handler(activityRecord, error);
    }];
}



- (void)connectToPublicDatabase{
    if (container == nil) container = [CKContainer defaultContainer];
    if (publicDatabase == nil) publicDatabase = [container publicCloudDatabase];
}

@end
