//
//  AppDelegate.m
//  SportsApp
//
//  Created by Bruno Scheltzke on 18/04/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "SAEventConnector.h"
#import "SAActivityConnector.h"
#import "SAActivity.h"
#import "SAEvent.h"
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SAPersonConnector.h"
#import "SAPerson.h"
#import "SAUser.h"

@interface AppDelegate ()

@end

@implementation AppDelegate



//  AppDelegate.m


- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    //setting navigation bar style for the app
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    //[[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:                                                           [UIColor blackColor], NSForegroundColorAttributeName, shadow, NSShadowAttributeName, [UIFont systemFontOfSize:19.28], NSFontAttributeName, nil]];
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    //init window so initial view can be settable
    self.window = [[UIWindow alloc]initWithFrame:UIScreen.mainScreen.bounds];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    //DELETE THIS WHEN FINISHED TESTING
    //[userDefaults setBool:NO forKey:@"HasLaunchedOnce"];
    //[userDefaults setObject:nil forKey:@"user"];
    //[userDefaults setObject:nil forKey:@"loginInfo"];
    //[userDefaults setObject:nil forKey:@"ArrayOfDictionariesContainingTheActivities"];
    //[userDefaults setObject:nil forKey:@"ArrayOfDictionariesContainingPeople"];
    
    //CHECK IF APP IS BEING LAUNCHED FOR THE FIRST TIME
    if (![userDefaults boolForKey:@"HasLaunchedOnce"]){
        //TODO SHOW INTRO VIEWS
        UIViewController *initialView = [mainStoryboard instantiateViewControllerWithIdentifier:@"joinView"];
        self.window.rootViewController = initialView;
        [self.window makeKeyAndVisible];
        
        //GET ALL ACTIVITIES INFO AVAILABLE
        [SAActivityConnector getAllActivities:^(NSArray * _Nullable activities, NSError * _Nullable error) {
            if (!error) {
                for (SAActivity *activity in activities) {
                    [SAActivity saveToUserDefaults:activity];
                }
            }
        }];
        [userDefaults setBool:YES forKey:@"HasLaunchedOnce"];
        [userDefaults synchronize];
    }else{
        //check if there is already a user logged in
        if ([userDefaults dataForKey:@"user"]) {
            //SHOW FEED
            UIViewController *initialView = [mainStoryboard instantiateViewControllerWithIdentifier:@"view2"];
            self.window.rootViewController = initialView;
            [self.window makeKeyAndVisible];
            
            NSData *dataUser = [userDefaults dataForKey:@"user"];
            SAPerson *person = [NSKeyedUnarchiver unarchiveObjectWithData:dataUser];
            SAUser *objToRegister = [SAUser new];
            
            [objToRegister setCurrentPerson:person];
        }
        else
            //check if there is login info to perform the login operation
            if([userDefaults dictionaryForKey:@"loginInfo"]){
                //TODO SHOW PERFORMING LOG IN
                UIViewController *initialView = [mainStoryboard instantiateViewControllerWithIdentifier:@"joinView"];
                self.window.rootViewController = initialView;
                [self.window makeKeyAndVisible];
                
                SAUser *objToLogin = [SAUser new];
                [objToLogin loginWithCompletionHandler:^(int wasSuccessful) {
                    if (wasSuccessful == 0) {
                        //SHOW FEED
                        UIViewController *initialView = [mainStoryboard instantiateViewControllerWithIdentifier:@"view2"];
                        self.window.rootViewController = initialView;
                        [self.window makeKeyAndVisible];
                    }else{
                        //SHOW LOGIN VIEW
                        UIViewController *initialView = [mainStoryboard instantiateViewControllerWithIdentifier:@"loginView"];
                        self.window.rootViewController = initialView;
                        [self.window makeKeyAndVisible];
                    }
                }];
            }
        else{
            //NOTHING WORKED, SHOW JOIN VIEW
            UIViewController *initialView = [mainStoryboard instantiateViewControllerWithIdentifier:@"joinView"];
            self.window.rootViewController = initialView;
            [self.window makeKeyAndVisible];
        }
    }
    
    return YES;
}

/*- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if (shouldShowAnotherViewControllerAsRoot) {
        UIStoryboard *storyboard = self.window.rootViewController.storyboard;
        UIViewController *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"rootNavigationController"];
        self.window.rootViewController = rootViewController;
        [self.window makeKeyAndVisible];
    }
    
    return YES;
}*/






- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:sourceApplication
                                                               annotation:annotation
                    ];
    // Add any custom logic here.
    return handled;
} 





- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
