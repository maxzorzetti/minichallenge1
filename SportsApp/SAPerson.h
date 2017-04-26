//
//  Person.h
//  SportsApp
//
//  Created by Bruno Scheltzke on 2017-04-19.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CloudKit/CloudKit.h>
@class SAEvent;
@class SAActivity;

@interface SAPerson : NSObject

@property (nonatomic, readonly) CKRecordID *personId;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *email;
@property (nonatomic) NSString *telephone;
@property (nonatomic) NSMutableArray<SAActivity *> *interests;
@property (nonatomic) NSMutableArray<SAEvent *> *events;

//@property (nonatomic) id facebookId;

- (void)addInterest:(SAActivity *)interest;
- (void)removeInterest:(SAActivity *)interest;

- (void)addEvent:(SAEvent *)event;
- (void)removeEvent:(SAEvent *)event;

- (instancetype)initWithName:(NSString *)name personId:(CKRecordID *)personId email:(NSString *)email telephone:(NSString *)telephone andEvents:(NSArray<SAEvent *> *)events;


@end
