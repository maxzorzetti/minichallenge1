//
//  SAActivity.h
//  SportsApp
//
//  Created by Bruno Scheltzke on 2017-04-23.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SAActivity : NSObject

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) int minimumPeople, maximumPeople;

@end
