//
//  ActivityConnector.h
//  SportsApp
//
//  Created by Bruno Scheltzke on 2017-04-25.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SAActivity;

@interface SAActivityConnector : NSObject

+ (void)getAllActivities:(void (^_Nonnull)(NSArray *_Nullable, NSError *_Nullable))handler;

@end
