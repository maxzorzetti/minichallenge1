//
//  EventDAO.h
//  SportsApp
//
//  Created by Bruno Scheltzke on 24/04/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CKRecordID;
@class CKRecord;
@class SAActivity;
@class CLLocation;
@class CKReference;

@interface SAEventDAO : NSObject

- (void)getEventById:(CKRecordID *_Nonnull)eventId handler:(void (^_Nonnull)(CKRecord * _Nullable record, NSError * _Nullable error))handler;

- (void)getAvailableEventsOfActivity:(SAActivity *_Nonnull)activity completionHandler:(void (^_Nonnull)(NSArray *_Nonnull, NSError *_Nonnull))handler;

- (void)getNext24hoursInterestedEventsWithActivities:(NSArray<CKReference *>*_Nonnull)interestedReferencedActivities AndCurrentLocation:(CLLocation *)usersLocation andDistanceInMeters:(int)proximity handler:(void (^_Nonnull)(NSArray<CKRecord *>* _Nullable events, NSError * _Nullable error))handler;

@end
