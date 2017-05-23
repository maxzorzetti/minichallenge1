//
//  SAPersonConnector.m
//  SportsApp
//
//  Created by Bruno Scheltzke on 26/04/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "SAPersonConnector.h"
#import "SAPersonDAO.h"
#import "SAPerson.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <CommonCrypto/CommonDigest.h>
#import "SAActivity.h"

@implementation SAPersonConnector

+ (void)loginWithUsername:(NSString *_Nonnull)username andPassword:(NSString *_Nonnull)password handler:(void (^_Nonnull)(SAPerson *_Nullable, NSError *_Nullable))handler{
    SAPersonDAO *dao = [SAPersonDAO new];
    
    [dao loginWithUsername:username andPassword:[self sha1:password] handler:^(CKRecord * _Nullable personRecord, NSError * _Nullable error) {
        if (!error && !personRecord) {
            //facebook user? get picture
            if (personRecord[@"facebookId"]) {
                NSString *pathGraph = [[NSString alloc]initWithFormat:@"/%@",personRecord[@"facebookId"]];
                FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                              initWithGraphPath:pathGraph
                                              parameters:@{ @"fields": @"picture"}
                                              HTTPMethod:@"GET"];
                
                [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                    if(!error){
                        
                        NSData *photo = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:[[[result objectForKey:@"picture"]objectForKey:@"data"]objectForKey:@"url"]]];
                        
                        SAPerson *person = [self getPersonFromRecord:personRecord andPicture:photo];
                        handler(person, error);
                    }
                    //YOU DONT HAVE ACCESS TO FACEBOOK PICTURES (PROBABLY BECAUSE YOU'RE NOT LOGGED IN)
                    else{
                        //ADD PLACEHOLDER profile picture
                        NSData *photo = [NSData dataWithContentsOfFile:@"img_placeholder"];
                        SAPerson *person = [self getPersonFromRecord:personRecord andPicture:photo];
                        handler(person, error);
                    }
                }];
            }
            //not a facebok user? use placeholder as picture
            else{
                //ADD PLACEHOLDER profile picture
                NSData *photo = [NSData dataWithContentsOfFile:@"img_placeholder"];
                SAPerson *person = [self getPersonFromRecord:personRecord andPicture:photo];
                handler(person, error);
            }
        }else{
            handler(nil, error);
        }
    }];
}



+ (void)getPeopleFromFacebookIds:(NSArray<NSString *> *_Nonnull)facebookIds handler:(void (^_Nonnull)(NSArray<SAPerson *> *_Nullable, NSError *_Nullable))handler{
    __block NSMutableArray *arrayOfPeople = [NSMutableArray new];
    SAPersonDAO *personDAO = [SAPersonDAO new];
    
    [personDAO getPeopleFromFacebookIds:facebookIds handler:^(NSArray<CKRecord *> * _Nullable personRecords, NSError * _Nullable error) {
        if (!error) {
            for (int i = 0; i<personRecords.count; i++) {
                CKRecord *personRecord = personRecords[i];
                
                NSString *pathGraph = [[NSString alloc]initWithFormat:@"/%@",personRecord[@"facebookId"]];
                
                FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                              initWithGraphPath:pathGraph
                                              parameters:@{ @"fields": @"picture",}
                                              HTTPMethod:@"GET"];
                
                [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                    if(!error){
                        NSData *photo = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:[[[result objectForKey:@"picture"]objectForKey:@"data"]objectForKey:@"url"]]];
                        
                        SAPerson *person = [self getPersonFromRecord:personRecord andPicture:photo];
                        [arrayOfPeople addObject:person];
                        if (arrayOfPeople.count==personRecords.count) {
                            handler(arrayOfPeople, error);
                        }
                    }else{
                        NSLog(@"%@", error.description);
                    }
                }];
            }
        }
    }];
}

+ (void)getPeopleFromIds:(NSArray<CKRecordID *> *_Nonnull)peopleIds handler:(void (^_Nonnull)(NSArray<SAPerson *> *_Nullable, NSError *_Nullable))handler{
    __block NSMutableArray *arrayOfPeople = [NSMutableArray new];
    SAPersonDAO *personDAO = [SAPersonDAO new];
    
    [personDAO getPeopleFromIds:peopleIds handler:^(NSArray<CKRecord *> * _Nullable personRecords, NSError * _Nullable error) {
        if (!error) {
            for (int i = 0; i<personRecords.count; i++) {
                CKRecord *personRecord = personRecords[i];
                
                //if person is a facebook user, load his/her picture before creating a SAPerson object and adding to array
                if (![personRecord[@"facebookId"] isEqual:nil]) {
                    NSString *pathGraph = [[NSString alloc]initWithFormat:@"/%@",personRecord[@"facebookId"]];
                    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                                  initWithGraphPath:pathGraph
                                                   parameters:@{ @"fields": @"picture",}
                                                  HTTPMethod:@"GET"];
                    
                    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                        if(!error){
                            
                            NSData *photo = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:[[[result objectForKey:@"picture"]objectForKey:@"data"]objectForKey:@"url"]]];
                            
                            SAPerson *person = [self getPersonFromRecord:personRecord andPicture:photo];
                            [arrayOfPeople addObject:person];
                            
                            //calling the block end when the last person got his/her facebook picture loaded
                            if (arrayOfPeople.count==personRecords.count) {
                                handler(arrayOfPeople, error);
                            }
                        }else{
                            NSLog(@"%@", error.description);
                        }
                    }];
                }
                //if the person ain't a facebook user, use a placeholder to create a SAPerson object and add the object to array
                else{
                    //ADD PLACEHOLDER profile picture
                    NSData *photo = [NSData dataWithContentsOfFile:@"img_placeholder.png"];
                    
                    SAPerson *person = [self getPersonFromRecord:personRecord andPicture:photo];
                    [arrayOfPeople addObject:person];
                }
                
                
                //this condition will never be met if there is a facebookUser's picture yet to be loaded. Don't worry, the picture will call the block
                if (arrayOfPeople.count==personRecords.count) {
                    handler(arrayOfPeople, error);
                }
            }
        }
    }];
}

+ (void)getPersonFromId:(CKRecordID *_Nonnull)personId handler:(void (^_Nonnull)(SAPerson *_Nullable, NSError *_Nullable))handler{
    SAPersonDAO *dao = [SAPersonDAO new];
    
    [dao getPersonFromId:personId handler:^(CKRecord * _Nullable personRecord, NSError * _Nullable error) {
        if (!error) {
            //facebook user? get picture
            if (personRecord[@"facebookId"]) {
                NSString *pathGraph = [[NSString alloc]initWithFormat:@"/%@",personRecord[@"facebookId"]];
                FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                              initWithGraphPath:pathGraph
                                              parameters:@{ @"fields": @"picture"}
                                              HTTPMethod:@"GET"];
                
                    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                            if(!error){
                                
                                NSData *photo = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:[[[result objectForKey:@"picture"]objectForKey:@"data"]objectForKey:@"url"]]];
                                
                                SAPerson *person = [self getPersonFromRecord:personRecord andPicture:photo];
                                [SAPerson saveToUserDefaults:person];
                                handler(person, error);
                            }
                            //YOU DONT HAVE ACCESS TO FACEBOOK PICTURES (PROBABLY BECAUSE YOU'RE NOT LOGGED IN)
                            else{
                                //ADD PLACEHOLDER profile picture
                                NSData *photo = [NSData dataWithContentsOfFile:@"img_placeholder"];
                                SAPerson *person = [self getPersonFromRecord:personRecord andPicture:photo];
                                [SAPerson saveToUserDefaults:person];
                                handler(person, error);
                            }
                        });
                    }];
               
            }
            //not a facebok user? use placeholder as picture
            else{
                //ADD PLACEHOLDER profile picture
                NSData *photo = [NSData dataWithContentsOfFile:@"img_placeholder"];
                SAPerson *person = [self getPersonFromRecord:personRecord andPicture:photo];
                [SAPerson saveToUserDefaults:person];
                handler(person, error);
            }
        }else{
            handler(nil, error);
        }
    }];
}

+ (void)savePerson:(SAPerson *)person handler:(void (^)(SAPerson * _Nullable, NSError * _Nullable))handler{
    SAPersonDAO *dao = [SAPersonDAO new];
    
    [dao savePerson:[self getRecordFromPerson:person] handler:^(CKRecord * _Nullable personRecord, NSError * _Nullable error) {
        if(!error){
            //facebook user? get picture
            if (personRecord[@"facebookId"]) {
                NSString *pathGraph = [[NSString alloc]initWithFormat:@"/%@",personRecord[@"facebookId"]];
                FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                              initWithGraphPath:pathGraph
                                              parameters:@{ @"fields": @"picture"}
                                              HTTPMethod:@"GET"];
                
                [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                        if(!error){
                            NSData *photo = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:[[[result objectForKey:@"picture"]objectForKey:@"data"]objectForKey:@"url"]]];
                            
                            SAPerson *person = [self getPersonFromRecord:personRecord andPicture:photo];
                            handler(person, error);
                        }
                        //YOU DONT HAVE ACCESS TO FACEBOOK PICTURES (PROBABLY BECAUSE YOU'RE NOT LOGGED IN)
                        else{
                            //ADD PLACEHOLDER profile picture
                            NSData *photo = [NSData dataWithContentsOfFile:@"img_placeholder"];
                            SAPerson *person = [self getPersonFromRecord:personRecord andPicture:photo];
                            handler(person, error);
                        }
                    });
                }];
                
            }
            //not a facebok user? use placeholder as picture
            else{
                //ADD PLACEHOLDER profile picture
                NSData *photo = [NSData dataWithContentsOfFile:@"img_placeholder"];
                SAPerson *person = [self getPersonFromRecord:personRecord andPicture:photo];
                handler(person, error);
            }

        }
    }];
}


+ (SAPerson *_Nonnull)getPersonFromRecord:(CKRecord *_Nonnull)personRecord andPicture:(NSData *_Nullable)photo{
    NSString *name = [NSString new];
    CKRecordID *personId = personRecord.recordID;
    NSString *email = [NSString new];
    NSString *telephone = [NSString new];
    NSString *facebookId = [NSString new];
    NSString *gender = [NSString new];
    NSArray *interestsRef = [NSArray new];
    NSMutableArray *interests = [NSMutableArray new];
    
    if (personRecord[@"name"]) {
        name = personRecord[@"name"];
    }
    if (personRecord[@"email"]) {
        email = personRecord[@"email"];
    }
    if (personRecord[@"telephone"]) {
        telephone = personRecord[@"telephone"];
    }
    if (personRecord[@"facebookId"]) {
        facebookId = personRecord[@"facebookId"];
    }
    if (personRecord[@"gender"]) {
        gender = personRecord[@"gender"];
    }
    
    
    if (personRecord[@"interestedActivities"]) {
        interestsRef = personRecord[@"interestedActivities"];
        NSArray *arrayOfDicActivitiesUserDefaults = [[NSUserDefaults standardUserDefaults] arrayForKey:@"ArrayOfDictionariesContainingTheActivities"];
        
        for (CKReference *ref in interestsRef) {
            for (NSDictionary *activityDic in arrayOfDicActivitiesUserDefaults) {
                if ([ref.recordID.recordName isEqualToString:activityDic[@"activityId"]]) {
                    SAActivity *activity = [NSKeyedUnarchiver unarchiveObjectWithData:activityDic[@"activityData"]];
                    [interests addObject:activity];
                }
            }
        }
    }
    
    SAPerson *person = [[SAPerson alloc]initWithName:name personId:personId email:email telephone:telephone facebookId:facebookId andPhoto:photo andEvents:nil andGender:gender];
    
    [person setInterests:interests];
    return person;
}

+ (CKRecord *) getRecordFromPerson:(SAPerson *_Nonnull)person{
    CKRecord *personRecord;
    
    if (person.personId) {
        personRecord = [[CKRecord alloc]initWithRecordType:@"SAPerson" recordID:person.personId];
    }else{
        personRecord = [[CKRecord alloc]initWithRecordType:@"SAPerson"];
    }
    
    NSMutableArray *activityReferences = [NSMutableArray new];
    for (SAActivity *activity in person.interests) {
        CKReference *ref = [[CKReference alloc]initWithRecordID:activity.activityId action:CKReferenceActionNone];
        [activityReferences addObject:ref];
    }
    
    personRecord[@"name"] = person.name;
    personRecord[@"email"] = person.email;
    personRecord[@"telephone"] = person.telephone;
    personRecord[@"gender"] = person.gender;
    personRecord[@"facebookId"] = person.facebookId;
    personRecord[@"interestedActivities"] = activityReferences;
    
    return personRecord;
}

+ (NSString *)sha1:(NSString *)password
{
    NSData *data = [password dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}


@end
