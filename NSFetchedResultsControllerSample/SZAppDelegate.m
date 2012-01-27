//
//  SZAppDelegate.m
//  NSFetchedResultsControllerSample
//
//  Created by Stephan Zehrer on 19.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SZAppDelegate.h"

#import "SZMasterViewController.h"

#import "SZDataSource.h"

@implementation SZAppDelegate

@synthesize window = _window;
@synthesize dataStore = __dataStore;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    SZMasterViewController *controller = (SZMasterViewController *)navigationController.topViewController;
   
    [controller configureControllerWithDataStore:self.dataStore];
    
    // fetch or insert root event
    SZDataSource *dataSource = controller.dataSource;
    dataSource.currentEvent = dataSource.rootEvent;
    if (!dataSource.currentEvent) {
        dataSource.currentEvent = dataSource.insertNewObject;
    }
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self.dataStore saveObjectContext];
}


#pragma mark - Data Store


- (SZDataStore *)dataStore
{
    if (__dataStore != nil) {
        return __dataStore;
    }
    
    __dataStore = [[SZDataStore alloc] initWithAppDelegate:self];
    
    return __dataStore;
}

- (NSString*) dataStoreFileName {
    
    return @"NSFetchedResultsControllerSample.sqlite";
}

- (NSString*) dataStoreModelName {
    
    return @"NSFetchedResultsControllerSample";
}


#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
