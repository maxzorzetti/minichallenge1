//
//  SAPersonConnector.h
//  SportsApp
//
//  Created by Bruno Scheltzke on 26/04/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CKRecord;
@class SAPerson;

@interface SAPersonConnector : NSObject

+ (void)getPeopleFromEmails:(NSArray<NSString *> *_Nonnull)emails handler:(void (^_Nonnull)(NSArray<SAPerson *> *_Nullable, NSError *_Nullable))handler;

@end
