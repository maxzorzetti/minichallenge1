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

+ (void)getPeopleFromFacebookIds:(NSArray<NSString *> *_Nonnull)facebookIds handler:(void (^_Nonnull)(NSArray<SAPerson *> *_Nullable, NSError *_Nullable))handler;















+ (SAPerson *_Nonnull)getPersonFromRecord:(CKRecord *_Nonnull)personRecord andPicture:(NSData *_Nullable)photo;

@end
