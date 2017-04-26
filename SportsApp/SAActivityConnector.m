//
//  ActivityConnector.m
//  SportsApp
//
//  Created by Bruno Scheltzke on 2017-04-25.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "SAActivityConnector.h"
#import "SAActivityDAO.h"
#import "SAActivity.h"
#import <CloudKit/CloudKit.h>

@implementation SAActivityConnector

+ (void)getAllActivities:(void (^_Nonnull)(NSArray *_Nullable, NSError *_Nullable))handler{
    SAActivityDAO *activityDAO = [SAActivityDAO new];
    
    [activityDAO getAllActivitiesHandler:^(NSArray * _Nullable activities, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error.description);
            handler(nil, error);
        }else{
            NSMutableArray *arrayOfActivities = [NSMutableArray new];
            for (CKRecord *activity in activities) {
                SAActivity *activityFromRecord = [[SAActivity alloc]initWithName:activity[@"name"] minimumPeople:activity[@"minimumPeople"] maximumPeople:activity[@"maximumPeople"] AndActivityId:activity.recordID];
                [arrayOfActivities addObject:activityFromRecord];
            }
            handler(arrayOfActivities, nil);
        }
    }];
}

+ (void)getActivityById:(CKRecordID *)activityId handler:(void (^)(SAActivity * _Nullable, NSError * _Nullable))handler{
    SAActivityDAO *activityDAO = [SAActivityDAO new];
    [activityDAO getActivityByActivityId:activityId handler:^(CKRecord * _Nullable activityRecord, NSError * _Nullable error) {
        SAActivity *activity = [SAActivity new];
        if (!error) {
            activity = [self activityFromRecord:activityRecord];
        }
        handler(activity, nil);
    }];
}


+ (SAActivity *)activityFromRecord:(CKRecord *)activityRecord{
    SAActivity *activity = [[SAActivity alloc]initWithName:activityRecord[@"name"] minimumPeople:activityRecord[@"minimumPeople"] maximumPeople:activityRecord[@"maximumPeople"] AndActivityId:activityRecord.recordID];
    return activity;
}


@end
