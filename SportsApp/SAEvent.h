//
//  Event.h
//  SportsApp
//
//  Created by Bruno Scheltzke on 2017-04-19.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SAEvent : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) int requiredNumberPerson, currentNumberPerson;
@property (nonatomic) NSString *activity;
@property (nonatomic) NSMutableArray *participants;


@end
