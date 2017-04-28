//
//  SAFacebookIdDAO.h
//  SportsApp
//
//  Created by Laura Corssac on 27/04/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CloudKit/CloudKit.h>


@interface SAFacebookIdDAO : NSObject
- (void)getFacebookIdsFromId:(NSString *_Nonnull)facebookId handler:(void (^_Nonnull)(NSArray<NSString *> *_Nullable, NSError *_Nullable))handler;
- (void)getFacebookIdsFromIdHandler:(void (^_Nonnull)(NSArray *_Nullable, NSError *_Nullable))handler;
- (void)connectToPublicDatabase;
@end
