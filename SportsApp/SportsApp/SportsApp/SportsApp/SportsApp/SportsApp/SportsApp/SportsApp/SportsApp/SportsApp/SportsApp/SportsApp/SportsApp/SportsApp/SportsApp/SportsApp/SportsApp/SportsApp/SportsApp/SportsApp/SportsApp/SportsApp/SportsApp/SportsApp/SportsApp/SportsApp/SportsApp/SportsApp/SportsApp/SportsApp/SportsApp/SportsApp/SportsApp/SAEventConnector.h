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

@interface SAEventConnector : NSObject

+ (void)getEventById:(CKRecordID *_Nonnull)eventId handler:(void (^_Nonnull)(SAEvent * _Nullable event, NSError * _Nullable error))handler;

+ (void)getEventsByActivity:(SAActivity *_Nonnull)activity handler:(void (^ _Nonnull)(NSArray * _Nullable events, NSError *_Nullable error))handler;

@end
