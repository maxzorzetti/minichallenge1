//
//  SAPersonCore.h
//  SportsApp
//
//  Created by Bruno Scheltzke on 2017-04-23.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SAPerson;
@class CKRecord;
@class CKRecordID;

@interface SAPersonDAO : NSObject

- (void)getPeopleFromFacebookIds:(NSArray<NSString *> *_Nonnull)facebookIds handler:(void (^_Nonnull)(NSArray<CKRecord *> *_Nullable, NSError *_Nullable))handler;

- (void)getPeopleFromIds:(NSArray<CKRecordID *> *_Nonnull)personIds handler:(void (^_Nonnull)(NSArray<CKRecord *> *_Nullable, NSError *_Nullable))handler;

- (void)getPersonFromId:(CKRecordID *_Nonnull)personId handler:(void (^_Nonnull)(CKRecord *_Nullable, NSError *_Nullable))handler;

@end
