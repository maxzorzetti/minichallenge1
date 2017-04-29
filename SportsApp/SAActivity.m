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

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.minimumPeople] forKey:@"minimumPeople"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.maximumPeople] forKey:@"maximumPeople"];
    [aCoder encodeObject:self.activityId forKey:@"activityId"];
    [aCoder encodeObject:self.picture forKey:@"picture"];
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        _name = [aDecoder decodeObjectForKey:@"name"];
        _minimumPeople = (int)[aDecoder decodeObjectForKey:@"minimumPeople"];
        _maximumPeople = (int)[aDecoder decodeObjectForKey:@"maximumPeople"];
        _activityId = [aDecoder decodeObjectForKey:@"activityId"];
        _picture = [aDecoder decodeObjectForKey:@"picture"];
    }
    return self;
}


@end
