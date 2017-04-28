//
//  SAFacebookIdDAO.m
//  SportsApp
//
//  Created by Laura Corssac on 27/04/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "SAFacebookIdDAO.h"

#import "SAPerson.h"

@implementation SAFacebookIdDAO

CKContainer *container;
CKDatabase *publicDatabase;


- (void)getFacebookIdsFromIdHandler:(void (^_Nonnull)(NSArray *_Nullable, NSError *_Nullable))handler{
    [self connectToPublicDatabase];
    
    NSPredicate *predicate = [NSPredicate predicateWithValue:YES];
    CKQuery *personQuery = [[CKQuery alloc]initWithRecordType:@"SAPerson" predicate:predicate];
    
    [publicDatabase performQuery:personQuery inZoneWithID:nil completionHandler:handler];
}


- (void)connectToPublicDatabase{
    if (container == nil) container = [CKContainer defaultContainer];
    if (publicDatabase == nil) publicDatabase = [container publicCloudDatabase];
}



- (void)getFacebookIdsFromId:(NSString *_Nonnull)facebookId handler:(void (^_Nonnull)(NSArray<NSString *> *_Nullable, NSError *_Nullable))handler{

    [self connectToPublicDatabase];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"facebookId = %@", facebookId];
    
    CKQuery *query = [[CKQuery alloc]initWithRecordType:@"SAPerson" predicate:predicate];
    
    [publicDatabase performQuery:query inZoneWithID:nil completionHandler:handler];
}
@end
