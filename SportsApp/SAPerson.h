//
//  Person.h
//  SportsApp
//
//  Created by Bruno Scheltzke on 2017-04-19.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CloudKit/CloudKit.h>

@interface SAPerson : NSObject

@property (nonatomic, readonly) CKRecordID *id;
@property (nonatomic) NSString *name;
@property (nonatomic) NSMutableArray *events;

@end
