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

@interface SAEventConnector : NSObject

+ (void)getEventById:(CKRecordID *_Nonnull)eventId handler:(void (^_Nonnull)(SAEvent * _Nullable event, NSError * _Nullable error))handler;

@end
