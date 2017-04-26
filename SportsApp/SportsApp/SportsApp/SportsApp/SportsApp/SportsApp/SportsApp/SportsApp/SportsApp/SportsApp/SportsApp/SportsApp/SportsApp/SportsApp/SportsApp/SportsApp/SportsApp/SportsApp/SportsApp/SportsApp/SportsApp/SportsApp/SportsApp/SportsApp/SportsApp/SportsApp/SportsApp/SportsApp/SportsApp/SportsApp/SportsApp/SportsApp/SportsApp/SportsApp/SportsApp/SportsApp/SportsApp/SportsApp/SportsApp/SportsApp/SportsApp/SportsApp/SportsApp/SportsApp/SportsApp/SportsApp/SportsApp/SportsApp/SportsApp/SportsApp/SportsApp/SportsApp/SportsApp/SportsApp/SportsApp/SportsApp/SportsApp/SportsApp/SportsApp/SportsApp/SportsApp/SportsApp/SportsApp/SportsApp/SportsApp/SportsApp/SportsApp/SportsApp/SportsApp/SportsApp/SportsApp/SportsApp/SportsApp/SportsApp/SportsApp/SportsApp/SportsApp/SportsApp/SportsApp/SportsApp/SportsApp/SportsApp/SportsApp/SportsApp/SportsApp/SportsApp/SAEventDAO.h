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

@interface SAEventDAO : NSObject

- (void)getEventById:(CKRecordID *_Nonnull)eventId handler:(void (^_Nonnull)(CKRecord * _Nullable record, NSError * _Nullable error))handler;

- (void)getAvailableEventsOfActivity:(SAActivity *_Nonnull)activity completionHandler:(void (^_Nonnull)(NSArray *_Nonnull, NSError *_Nonnull))handler;

@end
