//
//  SAActivity.h
//  SportsApp
//
//  Created by Bruno Scheltzke on 2017-04-23.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CKRecordID;

@interface SAActivity : NSObject

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) int minimumPeople, maximumPeople;
@property (nonatomic, readonly) CKRecordID *activityId;

-(instancetype)initWithName:(NSString *)name minimumPeople:(int)minimumPeople maximumPeople:(int)maximumPeople AndActivityId:(CKRecordID *)activityId;

@end
