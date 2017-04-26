//
//  ActivityDAO.h
//  SportsApp
//
//  Created by Bruno Scheltzke on 2017-04-25.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CKRecord;
@class CKRecordID;

@interface SAActivityDAO : NSObject

- (void)getAllActivitiesHandler:(void (^_Nonnull)(NSArray *_Nullable, NSError *_Nullable))handler;

- (void)getActivityByActivityId:(CKRecordID *_Nonnull)activityId handler:(void (^_Nonnull)(CKRecord *_Nullable, NSError *_Nullable))handler;

@end
