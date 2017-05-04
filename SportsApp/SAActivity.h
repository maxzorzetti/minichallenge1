//
//  SAActivity.h
//  SportsApp
//
//  Created by Bruno Scheltzke on 2017-04-23.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CKRecordID;

@interface SAActivity : NSObject <NSCoding>

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) int minimumPeople, maximumPeople;
@property (nonatomic, readonly) CKRecordID *activityId;
@property (nonatomic) NSData *picture;
@property (nonatomic) NSData *pictureWhite;
@property (nonatomic) NSString *auxiliarVerb;

-(instancetype)initWithName:(NSString *)name minimumPeople:(int)minimumPeople maximumPeople:(int)maximumPeople picture:(NSData *)picture AndActivityId:(CKRecordID *)activityId andAuxiliarVerb:(NSString *)verb andPictureWhite:(NSData *)whitePicture;

-(void)encodeWithCoder:(NSCoder *)aCoder;
-(id)initWithCoder:(NSCoder *)aDecoder;

+ (void)saveToUserDefaults:(SAActivity *)activity;

@end
