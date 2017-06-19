//
//  SAUser.m
//  SportsApp
//
//  Created by Max Zorzetti on 22/04/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "SAUser.h"
#import "SAPerson.h"
#import "SAPersonConnector.h"

@implementation SAUser

+ (instancetype)currentUser {
	static SAUser *sharedInstance = nil;
	static dispatch_once_t onceToken;
    
	dispatch_once(&onceToken, ^{
		sharedInstance = [[SAUser alloc] init];
	});
	return sharedInstance;
}

- (id)init {
	if ( (self = [super init]) ) {
		// your custom initialization
	}
	return self;
}

-(void)loginWithCompletionHandler:(void (^_Nonnull)(int))handler{
    NSDictionary *dicOfLogin = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"loginInfo"];
    
    //if facebook user, log in in a different way
    if (![dicOfLogin[@"facebookId"] isEqualToString:@""]) {
        [SAPersonConnector getPeopleFromFacebookIds:[NSArray arrayWithObject:dicOfLogin[@"facebookId"]] handler:^(NSArray<SAPerson *> * _Nullable people, NSError * _Nullable error) {
            if (!error && people) {
                _person = people[0];
                
                [SAUser saveToUserDefaults:_person];
                
                handler(0);
            }else{
                handler(1);
            }
        }];
    }
    // if not a facebook user, log in using traditional way
    else{
        [SAPersonConnector loginWithUsername:dicOfLogin[@"username"] andPassword:dicOfLogin[@"password"] handler:^(SAPerson * _Nullable person, NSError * _Nullable error) {
            if (!error && person) {
                _person = person;
                
                [SAUser saveToUserDefaults:_person];
                
                handler(0);
            }else{
                handler(1);
            }
        }];
    }
}

+ (void)saveToUserDefaults:(SAPerson *) person{
    NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:person];
    [[NSUserDefaults standardUserDefaults] setObject:userData forKey:@"user"];
    
    [SAPerson saveToUserDefaults:person];
}



-(void)setCurrentPerson:(SAPerson *)person{
    self.person = person;
}

- (void)setPreferredActivity:(SAActivity *)activity {
	// TODO NSUserDefaults something
}

- (id)copyWithZone:(NSZone *)zone {
	return self;
}

@end
