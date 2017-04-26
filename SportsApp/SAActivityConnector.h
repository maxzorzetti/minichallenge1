//
//  ActivityConnector.h
//  SportsApp
//
//  Created by Bruno Scheltzke on 2017-04-25.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SAActivity;
@class CKRecordID;

@interface SAActivityConnector : NSObject

+ (void)getAllActivities:(void (^_Nonnull)(NSArray *_Nullable, NSError *_Nullable))handler;

+ (void)getActivityById:(CKRecordID *_Nonnull)activityId handler:(void (^ _Nonnull)(SAActivity * _Nullable activity, NSError *_Nullable error))handler;

@end
