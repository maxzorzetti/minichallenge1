//
//  SAPersonConnector.h
//  SportsApp
//
//  Created by Bruno Scheltzke on 26/04/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CKRecord;
@class CKRecordID;
@class SAPerson;

@interface SAPersonConnector : NSObject

+ (void)getPeopleFromFacebookIds:(NSArray<NSString *> *_Nonnull)facebookIds handler:(void (^_Nonnull)(NSArray<SAPerson *> *_Nullable, NSError *_Nullable))handler;

+ (void)getPeopleFromIds:(NSArray<CKRecordID *> *_Nonnull)peopleIds handler:(void (^_Nonnull)(NSArray<SAPerson *> *_Nullable, NSError *_Nullable))handler;

+ (void)getPersonFromId:(CKRecordID *_Nonnull)personId handler:(void (^_Nonnull)(SAPerson *_Nullable, NSError *_Nullable))handler;

+ (SAPerson *_Nonnull)getPersonFromRecord:(CKRecord *_Nonnull)personRecord andPicture:(NSData *_Nullable)photo;

+ (void)loginWithUsername:(NSString *_Nonnull)username andPassword:(NSString *_Nonnull)password handler:(void (^_Nonnull)(SAPerson *_Nullable, NSError *_Nullable))handler;

@end
