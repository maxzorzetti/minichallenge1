//
//  SAEventConnector.h
//  SportsApp
//
//  Created by Bruno Scheltzke on 2017-04-25.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SAEvent;
@class CKRecord;
@class CKRecordID;
@class SAActivity;
@class CLLocation;
@class CKReference;
@class SAPerson;

@interface SAEventConnector : NSObject

+ (void)getEventById:(CKRecordID *_Nonnull)eventId handler:(void (^_Nonnull)(SAEvent * _Nullable event, NSError * _Nullable error))handler;

+ (void)getEventsByActivity:(SAActivity *_Nonnull)activity handler:(void (^_Nonnull)(NSArray * _Nullable events, NSError *_Nullable error))handler;

+ (void)getComingEventsBasedOnFavoriteActivities:(NSArray<SAActivity *>*_Nonnull)activities AndCurrentLocation:(CLLocation *_Nonnull)location AndRadiusOfDistanceDesiredInMeters:(int)distance handler:(void (^_Nonnull)(NSArray<SAEvent *>* _Nullable events, NSError * _Nullable error))handler;

+ (void)getSugestedEventsWithActivities:(NSArray<SAActivity *>*_Nullable)interestedReferencedActivities AndCurrentLocation:(CLLocation *_Nonnull)usersLocation andDistanceInMeters:(int)proximity AndFriends:(NSArray<SAPerson *>*_Nonnull)friends handler:(void (^_Nonnull)(NSArray<SAEvent *>* _Nullable events, NSError * _Nullable error))handler;

+ (void)getEventsByPersonId:(CKRecordID *_Nonnull)userId handler:(void (^_Nonnull)(NSArray<SAEvent *>* _Nullable events, NSError * _Nullable error))handler;

+ (void)getPastEventsByPersonId:(CKRecordID *_Nonnull)userId handler:(void (^_Nonnull)(NSArray<SAEvent *>* _Nullable events, NSError * _Nullable error))handler;

+ (void)registerParticipant:(SAPerson *_Nonnull)participant inEvent:(SAEvent *_Nonnull)event handler:(void (^_Nonnull)(SAEvent * _Nullable event, NSError * _Nullable error))handler;

+ (void)removeParticipant:(SAPerson *_Nonnull)participant ofEvent:(SAEvent *_Nonnull)event handler:(void (^_Nonnull)(SAEvent * _Nullable event, NSError * _Nullable error))handler;

+ (SAEvent *_Nullable)getEventFromRecord:(CKRecord *_Nonnull)event;

+ (void)getEventsWhereUserIsAnInvitee:(CKRecordID *_Nonnull)userId handler:(void (^_Nonnull)(NSArray<SAEvent *>* _Nullable events, NSError * _Nullable error))handler;

+ (void)denyInvite:(SAPerson * _Nonnull)participant ofEvent:(SAEvent * _Nonnull)event handler:(void (^ _Nonnull)(SAEvent * _Nullable, NSError * _Nullable))handler;


//THIS SHOULD BE IN ANOTHER CLASS
+ (void)fetchRecordByRecordId:(CKRecordID *_Nonnull)recordId handler:(void (^_Nonnull)(CKRecord * _Nullable record, NSError * _Nullable error))handler;


@end
