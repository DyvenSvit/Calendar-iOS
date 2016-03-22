//
//  DSAppDelegate.m
//  Calendar UGCC
//
//  Created by Max Gontar on 8/13/14.
//  Copyright (c) 2014 DyvenSvit. All rights reserved.
//

#import "DSAppDelegate.h"

@implementation DSAppDelegate

@synthesize backgroundQueue, reach;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //#ifndef DEBUG
    [Fabric with:@[[Crashlytics class]]];
    //#endif
    
    [self addSkipBackupAttributeToItemAtURL:[self applicationLibraryDirectory]];
    
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 120;
    
    // Optional: set Logger to VERBOSE for debug information.
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    
    // Initialize tracker. Replace with your tracking ID.
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-56294253-1"];
    
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    [[GAI sharedInstance].defaultTracker set:kGAIAppVersion value:version];
    
    backgroundQueue = [NSOperationQueue new];
    
        [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithHexString:@"008000"]];//@"067AB5"]];
        
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        
        [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                               [UIColor whiteColor], NSForegroundColorAttributeName, nil]];
        [[UITabBar appearance] setBarTintColor:[UIColor colorWithHexString:@"008000"]];

    [[UITabBar appearance] setTintColor:[UIColor colorWithHexString:@"008000"]];
    [[UITabBar appearance] setSelectedImageTintColor:[UIColor whiteColor]];
    [[UIPickerView appearance] setBackgroundColor:[UIColor redColor]];
    [DSData shared];
    return YES;
}

- (NSURL *)applicationLibraryDirectory
{
    
    NSString *appSupportDir =
    [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask,
                                         YES) lastObject];
    
    return [NSURL fileURLWithPath:appSupportDir];
}

- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup. Error: %@", [URL lastPathComponent], error);
    }else{
        NSLog(@"Files excluded from backup");
    }
    return success;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    DSDay *day;
    NSString * dateStr = [[url absoluteString] componentsSeparatedByString:@"//"][1];
    if(dateStr.length > 0)
    {
        NSDate *date = [NSDate dateFromString:dateStr];
        
        day = [DSDay getByYear:[date getYearNumber] month:[date getMonthNumber] day:[date getDayNumber]];
    }
    else
    {
        day = [DSDay getByYear:[NSDate getCurrentYearNumber] month:[NSDate getCurrentMonthNumber] day:[NSDate getCurrentDayNumber]];
    }
    
    DSDayViewController *navController = [[self.window.rootViewController storyboard] instantiateViewControllerWithIdentifier:@"DSDayViewController"];
    navController.day = day;
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    [navigationController pushViewController:navController animated:YES];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
