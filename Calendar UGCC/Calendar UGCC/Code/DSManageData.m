//
//  DSManageData.m
//  CalendarUGCC
//
//  Created by Admin on 11/6/14.
//  Copyright (c) 2014 DyvenSvit. All rights reserved.
//

#import "DSManageData.h"

@implementation DSManageData

@synthesize completionBlock, errorBlock;
- (id)initWithCompletionBlock:(manageCompletionBlock)_completionBlock
                   errorBlock:(manageErrorBlock)_errorBlock {
    self = [super init];
    if (self) {
        completionBlock = [_completionBlock copy];
        errorBlock = [_errorBlock copy];
    }
    return self;
}

- (void)start {
    [[NSFileManager defaultManager] setDelegate:self];
    [self manageLocalResources];
}


- (BOOL)fileManager:(NSFileManager *)fileManager shouldProceedAfterError:(NSError *)error copyingItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath{
    if ([error code] == NSFileWriteFileExistsError) //error code for: The operation couldn’t be completed. File exists
        return YES;
    else
        return NO;
}


-(void)manageLocalResources
{
    NSError * error = nil;
    NSString *lastSavedVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"app.version"];
    
    NSString *majorVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *minorVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    NSString *currentVersion = [NSString stringWithFormat:@"%@ (%@)", majorVersion, minorVersion];
    NSLog(@"Checking last app version");
    if(![currentVersion isEqualToString:lastSavedVersion])
    {
        
        // Copy all resources Assets to the Library directory
        NSLog(@"Copy all resources Assets to the Library directory");
        NSString *bundleURL = [[NSBundle mainBundle] resourcePath];
        NSString * documentsPath = [bundleURL stringByAppendingPathComponent:@"/Assets"];
        
        NSString *dataPath = [[DSData cachesPath] stringByAppendingPathComponent:@"/Assets"];
        
        [[NSFileManager defaultManager] copyItemAtPath:documentsPath toPath: dataPath error:&error];
        if (error != nil) {
            NSLog(@"error creating directory: %@", error);
            
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Failed creating directory" forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:@"DSManageDataErrorDomain" code:-1 userInfo:userInfo];
            if(errorBlock) errorBlock(error);
            return;
            
        }
        else
        {
            NSLog(@"Assets was copied successfully!");
            [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:@"app.version"];
        }
    }
    else
    {
        NSLog(@"This app version resources was already copied to Library");
    }
    
    NSString *localUpdatesPath = [[DSData cachesPath] stringByAppendingPathComponent:@"/Assets/updates.xml"];
    
    NSString * fileContents=[NSString stringWithContentsOfURL:[[NSURL alloc] initFileURLWithPath:localUpdatesPath] encoding:
                             NSUTF8StringEncoding error:&error];
    
    if (!fileContents && error != nil) {
        NSLog(@"error accessing file %@: %@", localUpdatesPath, error);
       
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Failed accessing updates.xml file" forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:@"DSManageDataErrorDomain" code:-1 userInfo:userInfo];
        if(errorBlock) errorBlock(error);
        return;
    }

    NSLog(@"File %@ accessed:\n%@", localUpdatesPath, fileContents);
    if(completionBlock) completionBlock();
}

@end
