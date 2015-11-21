//
//  AppDelegate.m
//  ContatosIP67
//
//  Created by ios5778 on 24/10/15.
//  Copyright © 2015 Venturus. All rights reserved.
//

#import "AppDelegate.h"
#import "ContactsListViewController.h"
#import "ContactsMapViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // We want to use ContactsListViewController as main screen
    ContactsListViewController *list = [ContactsListViewController new];
    // Create the Navigation Controller
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:list];

    
    // And the ContactsMapViewController as second screen
    ContactsMapViewController *map = [ContactsMapViewController new];
    // Create the Navigation Controller
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:map];
    
    // Create the tab bar with the two screens
    UITabBarController *tabBarController = [UITabBarController new];
    tabBarController.viewControllers = @[nav, nav2];

    
    // Set the tab bar controller as the root view controller
    self.window.rootViewController = tabBarController;
    
    // Initialize the dao
    self.dao = [ContactDao contactDaoInstance];

    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[ContactDao contactDaoInstance]saveContext];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [[ContactDao contactDaoInstance]saveContext];

}


@end
