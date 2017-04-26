//
//  SAPersonCore.h
//  SportsApp
//
//  Created by Bruno Scheltzke on 2017-04-23.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SAPerson;

@interface SAPersonDAO : NSObject

+ (void)registerPerson:(SAPerson *)person;

@end
