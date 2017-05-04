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
                SAActivity *activityFromRecord = [self activityFromRecord:activity];
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
    CKAsset *assetPhoto = activityRecord[@"icon"];
    
    NSData *icon = [NSData dataWithContentsOfURL:[assetPhoto fileURL]];
    
    SAActivity *activity = [[SAActivity alloc]initWithName:activityRecord[@"name"] minimumPeople:(int)activityRecord[@"minimumPeople"] maximumPeople:(int)activityRecord[@"maximumPeople"] picture:icon AndActivityId:activityRecord.recordID  andAuxiliarVerb:activityRecord[@"auxiliarVerb"]];
    return activity;
}


@end
