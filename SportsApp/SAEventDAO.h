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
@class SAEvent;
@class CLLocation;
@class CKReference;

@interface SAEventDAO : NSObject

- (void)getEventById:(CKRecordID *_Nonnull)eventId handler:(void (^_Nonnull)(CKRecord * _Nullable record, NSError * _Nullable error))handler;

- (void)getEventsByUserReference:(CKReference *_Nonnull)userId handler:(void (^_Nonnull)(NSArray<CKRecord *>* _Nullable record, NSError * _Nullable error))handler;

- (void)getPastEventsByUserReference:(CKReference *_Nonnull)userId handler:(void (^_Nonnull)(NSArray<CKRecord *>* _Nullable record, NSError * _Nullable error))handler;

- (void)getAvailableEventsOfActivity:(SAActivity *_Nonnull)activity completionHandler:(void (^_Nonnull)(NSArray *_Nonnull, NSError *_Nonnull))handler;

- (void)getNext24hoursInterestedEventsWithActivities:(NSArray<CKReference *>*_Nonnull)interestedReferencedActivities AndCurrentLocation:(CLLocation *_Nonnull)usersLocation andDistanceInMeters:(int)proximity handler:(void (^_Nonnull)(NSArray<CKRecord *>* _Nullable events, NSError * _Nullable error))handler;

- (void)getSugestedEventsWithActivities:(NSArray<CKReference *>*_Nullable)interestedReferencedActivities AndCurrentLocation:(CLLocation *_Nonnull)usersLocation andDistanceInMeters:(int)proximity AndFriends:(NSArray<CKReference *>*_Nonnull)friends handler:(void (^_Nonnull)(NSArray<CKRecord *>* _Nullable events, NSError * _Nullable error))handler;

- (void)updateEvent:(CKRecord *_Nonnull)event handler:(void (^_Nonnull)(CKRecord * _Nullable event, NSError * _Nullable error))handler;

- (void)saveEvent:(SAEvent *_Nonnull)event handler:(void (^_Nonnull)(CKRecord * _Nullable event, NSError * _Nullable error))handler;

@end
