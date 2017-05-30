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
#import "SANewsFeedTableViewController.h"
#import "SAEventDescriptionViewController.h"

@interface AppDelegate ()
@property SAPerson *currentUser;

@end

@implementation AppDelegate

UNUserNotificationCenter *center;


//  AppDelegate.m

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    //ask for notifications if not determined yet
    center = [UNUserNotificationCenter currentNotificationCenter];
    
    center.delegate = self;
    
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionBadge)
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
                              // Enable or disable features based on authorization.
                          }];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self registerForNotifications];
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    //setting navigation bar style for the app
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init]
                                      forBarPosition:UIBarPositionAny
                                          barMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    //init window so initial view can be settable
    self.window = [[UIWindow alloc]initWithFrame:UIScreen.mainScreen.bounds];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIStoryboard *barbaraStoryboard = [UIStoryboard storyboardWithName:@"StoryboardDaBarbara" bundle:nil];
    
    //DELETE THIS WHEN FINISHED TESTING
    //[userDefaults setBool:NO forKey:@"HasLaunchedOnce"];
    //[userDefaults setObject:[NSData new] forKey:@"user"];
    //[userDefaults setObject:[NSDictionary new] forKey:@"loginInfo"];
    //[userDefaults setObject:[NSArray new] forKey:@"ArrayOfDictionariesContainingTheActivities"];
    //[userDefaults setObject:[NSArray new] forKey:@"ArrayOfDictionariesContainingPeople"];
    //[userDefaults setObject:[NSArray new] forKey:@"ArrayOfDictionariesContainingWithEvent"];
    
    //CHECK IF APP IS BEING LAUNCHED FOR THE FIRST TIME
    if (![userDefaults boolForKey:@"HasLaunchedOnce"]){
        [userDefaults setObject:[NSData new] forKey:@"user"];
        [userDefaults setObject:[NSDictionary new] forKey:@"loginInfo"];
        [userDefaults setObject:[NSArray new] forKey:@"ArrayOfDictionariesContainingTheActivities"];
        [userDefaults setObject:[NSArray new] forKey:@"ArrayOfDictionariesContainingPeople"];
        [userDefaults setObject:[NSArray new] forKey:@"ArrayOfDictionariesContainingWithEvent"];
        [FBSDKAccessToken setCurrentAccessToken:nil];
        
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
        
        //TODO SHOW INTRO VIEWS
        UIViewController *initialView = [barbaraStoryboard instantiateViewControllerWithIdentifier:@"joinView"];
        self.window.rootViewController = initialView;
        [self.window makeKeyAndVisible];
    }else{
        //check if there is already a user logged in
        if ([userDefaults dataForKey:@"user"]) {
            NSData *dataUser = [userDefaults dataForKey:@"user"];
            self.currentUser = [NSKeyedUnarchiver unarchiveObjectWithData:dataUser];
            
            //check if it is a valid user with valid recordId
            if (self.currentUser.personId) {
                //SHOW FEED
                UIViewController *initialView = [mainStoryboard instantiateViewControllerWithIdentifier:@"view2"];
                self.window.rootViewController = initialView;
                [self.window makeKeyAndVisible];
                
                //            SAUser *objToRegister = [SAUser new];
                //
                //            [objToRegister setCurrentPerson:person];
            }else{
                //NOTHING WORKED, SHOW JOIN VIEW
                UIViewController *initialView = [barbaraStoryboard instantiateViewControllerWithIdentifier:@"joinView"];
                self.window.rootViewController = initialView;
                [self.window makeKeyAndVisible];
            }
        }
//        else
//            //check if there is login info to perform the login operation
//            if([userDefaults dictionaryForKey:@"loginInfo"]){
//                //TODO SHOW PERFORMING LOG IN
//                UIViewController *initialView = [barbaraStoryboard instantiateViewControllerWithIdentifier:@"joinView"];
//                self.window.rootViewController = initialView;
//                [self.window makeKeyAndVisible];
//                
//                SAUser *objToLogin = [SAUser new];
//                [objToLogin loginWithCompletionHandler:^(int wasSuccessful) {
//                    if (wasSuccessful == 0) {
//                        //SHOW FEED
//                        UIViewController *initialView = [mainStoryboard instantiateViewControllerWithIdentifier:@"view2"];
//                        self.window.rootViewController = initialView;
//                        [self.window makeKeyAndVisible];
//                    }else{
//                        //SHOW LOGIN VIEW
//                        UIViewController *initialView = [mainStoryboard instantiateViewControllerWithIdentifier:@"loginView"];
//                        self.window.rootViewController = initialView;
//                        [self.window makeKeyAndVisible];
//                    }
//                }];
//            }
        else{
            //NOTHING WORKED, SHOW JOIN VIEW
            UIViewController *initialView = [barbaraStoryboard instantiateViewControllerWithIdentifier:@"joinView"];
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









#pragma notification methods

//notification was received when app was in foreground
- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    CKNotification *cloudKitNotification = [CKNotification notificationFromRemoteNotificationDictionary:userInfo];
    
    //until now, all the notifications are related to an event being created/updated
    
    
    if (cloudKitNotification.notificationType == CKNotificationTypeQuery) {
        CKRecordID *recordID = [(CKQueryNotification *)cloudKitNotification recordID];
        
        //fetch the record from db
        [SAEventConnector fetchRecordByRecordId:recordID handler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
            if (!error) {
                //check what record type this record is and decide what to do with it
                if ([record.recordType isEqualToString:@"Event"]) {
                    SAEvent *eventFromNotification = [SAEventConnector getEventFromRecord:(record)];
                    //save/update event in user defaults
                    [SAEvent saveToDefaults:eventFromNotification];
                    
                    UIViewController *presentedViewController = [self topViewController];
                    
                    
                    //if view controller being presented is feed, update its tableview
                    if ([presentedViewController isKindOfClass:[SANewsFeedTableViewController class]]) {
                        SANewsFeedTableViewController *currentView = (SANewsFeedTableViewController *)presentedViewController;
                        
                        [currentView updateEventsWithUserDefaults];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [currentView.tableView reloadData];
                        });
                    }
                    
                    //if view controller being presented is feed, update its collection views
                    if ([presentedViewController isKindOfClass:[SAEventDescriptionViewController class]]) {
                        SAEventDescriptionViewController *currentView = (SAEventDescriptionViewController *)presentedViewController;
                        
                        currentView.currentEvent = eventFromNotification;
                        [currentView setInitialValueOfFieldsInScreen];
                        [currentView updateCollectionViews];
                    }
                }
                //do the same with activity and other record types
            }
        }];
    }
}


//notification was received when app was in background
//user selected an action from the alert/banner notification
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    
    //************************************************************************************//
    //     notification related to current user being invited to an event by a friend     //
    //************************************************************************************//
    if ([response.notification.request.content.categoryIdentifier isEqualToString:@"userInvitedToEvent"]) {
        //get the event
        CKNotification *cloudKitNotification = [CKNotification notificationFromRemoteNotificationDictionary:response.notification.request.content.userInfo];
        
        if (cloudKitNotification.notificationType == CKNotificationTypeQuery) {
            CKRecordID *recordID = [(CKQueryNotification *)cloudKitNotification recordID];
            //if user wants to joing the event
            if ([response.actionIdentifier isEqualToString:@"joinEvent"]) {
                //fetch event
                [SAEventConnector getEventById:recordID handler:^(SAEvent * _Nullable event, NSError * _Nullable error) {
                    if (!error) {
                        //register user in event
                        [SAEventConnector registerParticipant:self.currentUser inEvent:event handler:
                         ^(SAEvent * _Nullable event, NSError * _Nullable error) {
                             if (!error) {
                                 completionHandler();
                             }
                         }];
                    }
                }];
            }
            //if user wants to leave the event
            if ([response.actionIdentifier isEqualToString:@"leaveEvent"]) {
                //fetch event
                [SAEventConnector getEventById:recordID handler:^(SAEvent * _Nullable event, NSError * _Nullable error) {
                    if (!error) {
                        //deny invitation
                        [SAEventConnector denyInvite:self.currentUser ofEvent:event handler:^(SAEvent * _Nullable event, NSError * _Nullable error) {
                            if (!error) {
                                completionHandler();
                            }
                        }];
                    }
                }];
            }
        }
    }
    // ************************************************************************************ //
    
}


-(void)registerForNotifications{
    //***** notification settings *****//
    
    UIMutableUserNotificationAction* joinEventAction = [[UIMutableUserNotificationAction alloc] init];
    joinEventAction.identifier = @"joinEvent";
    joinEventAction.title = @"Join";
    joinEventAction.activationMode = UIUserNotificationActivationModeBackground;
    joinEventAction.destructive = NO;
    joinEventAction.authenticationRequired = YES;
    
    UIMutableUserNotificationAction* leaveEventAction = [[UIMutableUserNotificationAction alloc] init];
    leaveEventAction.identifier = @"leaveEvent";
    leaveEventAction.title = @"Leave";
    leaveEventAction.activationMode = UIUserNotificationActivationModeBackground;
    leaveEventAction.destructive = NO;
    leaveEventAction.authenticationRequired = YES;
    
    UIMutableUserNotificationCategory *userInvitedToEventMutableCategory  = [[UIMutableUserNotificationCategory alloc]init];
    userInvitedToEventMutableCategory.identifier = @"userInvitedToEvent";
    [userInvitedToEventMutableCategory setActions:@[joinEventAction, leaveEventAction] forContext:UIUserNotificationActionContextDefault];
    
    
    NSSet *categories = [NSSet setWithObject:userInvitedToEventMutableCategory];
    
    //*Register for push notifications*/
    UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert categories:categories];
    [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    //*********************//
}










#pragma methods built in

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











#pragma methods to find presented view controller

- (UIViewController *)topViewController{
    return [self topViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController *)topViewController:(UIViewController *)vc
{
    if (vc.presentedViewController) {
        
        // Return presented view controller
        return [self topViewController:vc.presentedViewController];
        
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        
        // Return right hand side
        UISplitViewController* svc = (UISplitViewController*) vc;
        if (svc.viewControllers.count > 0)
            return [self topViewController:svc.viewControllers.lastObject];
        else
            return vc;
        
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        
        // Return top view
        UINavigationController* svc = (UINavigationController*) vc;
        if (svc.viewControllers.count > 0)
            return [self topViewController:svc.topViewController];
        else
            return vc;
        
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        
        // Return visible view
        UITabBarController* svc = (UITabBarController*) vc;
        if (svc.viewControllers.count > 0)
            return [self topViewController:svc.selectedViewController];
        else
            return vc;
        
    } else {
        
        // Unknown view controller type, return last child view controller
        return vc;
        
    }}


@end
