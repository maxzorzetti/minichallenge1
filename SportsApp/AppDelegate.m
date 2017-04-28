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

@interface AppDelegate ()

@end

@implementation AppDelegate



//  AppDelegate.m


- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    // Add any custom logic here.

    
    
//UGLIEST CODE TO TEST ABILITY TO FETCH EVENTS BY ACTIVITIES AND BY ID
//    [ActivityConnector getAllActivities:^(NSArray * _Nullable activities, NSError * _Nullable error) {
//        if (error) {
//            NSLog(@"%@", error.description);
//        } else {
//            for (SAActivity *activity in activities) {
//                NSLog(@"%@", activity.name);
//                
//                [SAEventConnector getEventsByActivity:activity handler:^(NSArray * _Nullable events, NSError * _Nullable error) {
//                    if (error) {
//                        NSLog(@"%@", error.description);
//                    } else {
//                        for (SAEvent *event in events) {
//                            NSLog(@"Events from activities: %@", event.name);
//                            
//                            [SAEventConnector getEventById:event.eventId handler:^(SAEvent * _Nullable eventFromid, NSError * _Nullable error) {
//                                if (error) {
//                                    NSLog(@"%@", error.description);
//                                } else {
//                                    NSLog(@"Event from id: %@", eventFromid.name);
//                                }
//                            }];
//                        }
//                    }
//                }];
//            }
//        }
//    }];
    
    
//UGLY CODE TO TEST ABILITY TO FETCH EVENTS FEED STYLE
//    [SAActivityConnector getAllActivities:^(NSArray * _Nullable activities, NSError * _Nullable error) {
//        if (!error) {
//            
//            CLLocation *fixedLoc = [[CLLocation alloc] initWithLatitude:-30.033285 longitude:-51.213884];
//            
//            [SAEventConnector getComingEventsBasedOnFavoriteActivities:activities AndCurrentLocation:fixedLoc AndRadiusOfDistanceDesiredInMeters:100 handler:^(NSArray<SAEvent *> * _Nullable events, NSError * _Nullable error) {
//                if(!error){
//                    for (SAEvent *event in events) {
//                        NSLog(@"Saca!!!! %@", event.name);
//                    }
//                }else{
//                    NSLog(@"Error pra buscar eventos, sente: %@", error.description);
//                }
//            }];
//        }else{
//            NSLog(@"Error pra buscar activity, sente: %@", error.description);
//        }
//    }];
//    
    
    //NSArray *arrayOfEmails = @[@"email", @"lau@hot.com", @"emailto.com"];
    
    /*[SAPersonConnector getPeopleFromEmails:arrayOfEmails handler:^(NSArray<SAPerson *> * _Nullable people, NSError * _Nullable error) {
        if (!error) {
            for (SAPerson * person in people) {
                NSLog(@"Opa, deu certo: %@", person.name);
            }
        }
    }];*/

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
