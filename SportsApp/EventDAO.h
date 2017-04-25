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

@interface EventDAO : NSObject

+ (void)getEventById:(CKRecordID *_Nonnull)eventId handler:(void (^_Nonnull)(CKRecord * _Nullable record, NSError * _Nullable error))handler;

@end
