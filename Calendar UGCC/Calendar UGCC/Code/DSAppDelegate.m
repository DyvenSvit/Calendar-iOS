//
//  DSAppDelegate.m
//  Calendar UGCC
//
//  Created by Max Gontar on 8/13/14.
//  Copyright (c) 2014 DyvenSvit. All rights reserved.
//

#import "DSAppDelegate.h"

@implementation DSAppDelegate

@synthesize backgroundQueue, isDataLoading, isDataLoaded, reach, updateDataObj, manageDataObj;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //#ifndef DEBUG
    [Crashlytics startWithAPIKey:@"a833e3cfadfc1218c22f19bfbdc9caf0183fe899"];
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
    
    if(IOS7)
    {
        [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithHexString:@"008000"]];//@"067AB5"]];
        
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        
        [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                               [UIColor whiteColor], NSForegroundColorAttributeName, nil]];
        [[UITabBar appearance] setBarTintColor:[UIColor colorWithHexString:@"008000"]];
    }
    else {
        // iOS 6.1 or earlier
        [[UINavigationBar appearance] setTintColor:[UIColor colorWithHexString:@"008000"]];
    }
    [[UITabBar appearance] setTintColor:[UIColor colorWithHexString:@"008000"]];
    [[UITabBar appearance] setSelectedImageTintColor:[UIColor whiteColor]];
    [[UIPickerView appearance] setBackgroundColor:[UIColor redColor]];
    
    return YES;
}

-(void)startManageData
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NT_DATA_LOADING_BEGIN object:nil];
    manageDataObj = [[DSManageData alloc] initWithCompletionBlock:^() {
       
        
        [DSData shared];
        [[NSNotificationCenter defaultCenter] postNotificationName:NT_DATA_LOADING_END object:nil];
        
        // Allocate a reachability object
        reach = [Reachability reachabilityWithHostname:@"dyvensvit.org"];
        
        // Tell the reachability that we DON'T want to be reachable on 3G/EDGE/CDMA
        reach.reachableOnWWAN = NO;
        
        NetworkStatus internetStatus = [reach currentReachabilityStatus];
        if (internetStatus == ReachableViaWiFi) {
        
            // [self updateData];
        }
        
    } errorBlock:^(NSError *error) {
        
        
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:error forKey:@"error"];
        [[NSNotificationCenter defaultCenter] postNotificationName:NT_DATA_LOADING_ERROR object:nil userInfo:userInfo];
        
        NSString *errorMsg = [NSString stringWithFormat:@"Update data error: %@", (error)?[error description]:@""];
        
        [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createExceptionWithDescription:errorMsg withFatal:@NO] build]];
        
    }];

    [manageDataObj start];

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


-(void)updateData
{
    if(!APP.isDataLoading)
       {
            NSDate *startDate = [NSDate date];
        
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NT_DATA_LOADING_BEGIN object:nil];
            
            APP.isDataLoading = YES;
            

            updateDataObj = [[DSUpdateData alloc] initWithCompletionBlock:^() {
                APP.isDataLoading = NO;
                
                NSDate *endDate = [NSDate date];
                [self onLoad:[endDate timeIntervalSinceDate:startDate]];
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
               
                [[NSNotificationCenter defaultCenter] postNotificationName:NT_DATA_LOADING_END object:nil];
            } errorBlock:^(NSError *error) {
                APP.isDataLoading = NO;
                
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:error forKey:@"error"];
                [[NSNotificationCenter defaultCenter] postNotificationName:NT_DATA_LOADING_ERROR object:nil userInfo:userInfo];
                
                NSString *errorMsg = [NSString stringWithFormat:@"Update data error: %@", (error)?[error description]:@""];
                
                [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createExceptionWithDescription:errorMsg withFatal:@NO] build]];
                NSDate *endDate = [NSDate date];
                [self onLoad:[endDate timeIntervalSinceDate:startDate]];
                
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                
            } progressBlock:^(NSString *status, float loaded, float total) {
                NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:status, @"status", [NSNumber numberWithFloat:total/loaded], @"progress", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NT_DATA_LOADING_PROGRESS object:nil userInfo:userInfo];
            }];
            
            [updateDataObj start];
       }
}

/*
 * Called after a list of high scores finishes loading.
 *
 * @param loadTime The time it takes, in milliseconds, to load a resource.
 */
- (void)onLoad:(NSTimeInterval) loadTime {
    
    // May return nil if a tracker has not already been initialized with a
    // property ID.
    id tracker = [[GAI sharedInstance] defaultTracker];
    NSNumber *timeUsed = [NSNumber numberWithInt:(int)(loadTime*1000)];
    [tracker send:[[GAIDictionaryBuilder createTimingWithCategory:@"Networking"    // Timing category (required)
                                                         interval:timeUsed        // Timing interval (required)
                                                             name:@"Update Data"  // Timing name
                                                            label:nil] build]];    // Timing label
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    DSDay *day;
    NSString * dateStr = [[url absoluteString] componentsSeparatedByString:@"//"][1];
    if(dateStr.length > 0)
    {
        NSDate *date = [NSDate dateFromString:dateStr];
        
        NSInteger yearIndex = [[[DSData shared] yearNames] indexOfObject:[@([date getYearNumber]) stringValue]];
        NSInteger monthIndex = [date getMonthNumber] - 1;
        NSInteger dayIndex = [date getDayNumber] - 1;
        day= ((DSMonth*)((DSYear*)[DSData shared].years[yearIndex]).months[monthIndex]).days[dayIndex];
    }
    else
    {
        
        //NSString *currentYearString = [NSString stringWithFormat:@"%ld", (long)[NSDate getCurrentYearNumber]];
        //NSInteger selectedYearIndex = [[[DSData shared] yearNames] indexOfObject:currentYearString];
        
        day = ((DSMonth*)((DSYear*)[DSData shared].years[0]).months[[NSDate getCurrentMonthNumber]-1]).days[[NSDate getCurrentDayNumber] -1];
    }
    
    DSDayViewController *navController = [[self.window.rootViewController storyboard] instantiateViewControllerWithIdentifier:@"DSDayViewController"];
    navController.day = day;
    [navController loadResources];
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
