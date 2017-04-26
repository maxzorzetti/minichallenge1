//
//  Person.m
//  SportsApp
//
//  Created by Bruno Scheltzke on 2017-04-19.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "SAPerson.h"

@implementation SAPerson //	TODO implement NSCopying

- (void)addInterest:(SAActivity *)interest{
	
}

- (void)removeInterest:(SAActivity *)interest{
	
}

- (void)addEvent:(SAEvent *)event{
	
}

- (void)removeEvent:(SAEvent *)event{
	
}


- (instancetype)initWithName:(NSString *)name personId:(CKRecordID *)personId email:(NSString *)email telephone:(NSString *)telephone andEvents:(NSArray<SAEvent *> *)events
{
    self = [super init];
    if (self) {
        _name = name;
        _personId = personId;
        _email = email;
        _telephone = telephone;
        _events = [[NSMutableArray alloc]initWithArray:events];
    }
    return self;
}

@end
