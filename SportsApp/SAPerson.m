//
//  Person.m
//  SportsApp
//
//  Created by Bruno Scheltzke on 2017-04-19.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "SAPerson.h"
#import <CloudKit/CloudKit.h>

@implementation SAPerson //	TODO implement NSCopying

- (void)addInterest:(SAActivity *)interest{
	
}

- (void)removeInterest:(SAActivity *)interest{
	
}

- (void)addEvent:(SAEvent *)event{
	
}

- (void)removeEvent:(SAEvent *)event{
	
}


- (instancetype)initWithName:(NSString *)name personId:(CKRecordID *)personId email:(NSString *)email telephone:(NSString *)telephone andPhoto:(NSData *)photo andEvents:(NSArray<SAEvent *> *)events
{
    self = [super init];
    if (self) {
        _name = name;
        _personId = personId;
        _email = email;
        _telephone = telephone;
        _events = [[NSMutableArray alloc]initWithArray:events];
        _photo = photo;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        _name = [aDecoder decodeObjectForKey:@"name"];
        _personId = [aDecoder decodeObjectForKey:@"personId"];
        _email = [aDecoder decodeObjectForKey:@"email"];
        _telephone = [aDecoder decodeObjectForKey:@"telephone"];
        _events = [aDecoder decodeObjectForKey:@"events"];
        _photo = [aDecoder decodeObjectForKey:@"photo"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.personId forKey:@"personId"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.telephone forKey:@"telephone"];
    [aCoder encodeObject:self.events forKey:@"events"];
    [aCoder encodeObject:self.photo forKey:@"photo"];
}

+ (void)saveToUserDefaults:(SAPerson *)person{
    NSMutableArray *arrayOfPeople = [[NSUserDefaults standardUserDefaults] mutableArrayValueForKey:@"ArrayOfDictionariesContainingPeople"];
    
    NSData *personData = [NSKeyedArchiver archivedDataWithRootObject:person];
    NSDictionary *personDic = @{
                                  @"personId" : person.personId.recordName,
                                  @"personData" : personData
                                  };
    
    [arrayOfPeople addObject:personDic];
    
    [[NSUserDefaults standardUserDefaults] setObject:arrayOfPeople forKey:@"ArrayOfDictionariesContainingPeople"];
}

@end
