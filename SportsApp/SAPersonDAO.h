//
//  SAPersonCore.h
//  SportsApp
//
//  Created by Bruno Scheltzke on 2017-04-23.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SAPerson;
@class CKRecord;

@interface SAPersonDAO : NSObject

- (void)getPeopleFromEmails:(NSArray<NSString *> *_Nonnull)emails handler:(void (^_Nonnull)(NSArray<CKRecord *> *_Nullable, NSError *_Nullable))handler;

@end
