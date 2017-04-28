//
//  SAActivity.m
//  SportsApp
//
//  Created by Bruno Scheltzke on 2017-04-23.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "SAActivity.h"

@implementation SAActivity

- (instancetype)initWithName:(NSString *)name minimumPeople:(int)minimumPeople maximumPeople:(int)maximumPeople picture:(NSData *)picture AndActivityId:(CKRecordID *)activityId
{
    self = [super init];
    if (self) {
        _name = name;
        _minimumPeople = minimumPeople;
        _maximumPeople = maximumPeople;
        _activityId = activityId;
        _picture = picture;
    }
    return self;
}

@end
