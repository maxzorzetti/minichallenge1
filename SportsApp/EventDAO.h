//
//  EventDAO.h
//  SportsApp
//
//  Created by Bruno Scheltzke on 24/04/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SAEvent;
@class CKRecordID;

@interface EventDAO : NSObject

+ (SAEvent *)getEventById:(CKRecordID *)eventId;

@end
