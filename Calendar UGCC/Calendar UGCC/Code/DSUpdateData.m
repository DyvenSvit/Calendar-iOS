//
//  DSUpdateData.m
//  CalendarUGCC
//
//  Created by Admin on 10/27/14.
//  Copyright (c) 2014 DyvenSvit. All rights reserved.
//

#import "DSUpdateData.h"

#define BASE_URL @"http://dyvensvit.org/files/i-calendar/"
#define UPD_FILE @"updates.xml"
//#define TOKEN @"hX-o_SZ1AYsAAAAAAAAACHWhe2HlwWFPEtZwen2K6Aol42tifz5kbWOwcPEcdYU-"

//#define BASE_URL @"https://api-content.dropbox.com/1/files/auto/Safari/"
//#define UPD_FILE @"updates.xml"

@implementation DSUpdateData
@synthesize completionBlock, errorBlock, progressBlock;
- (id)initWithCompletionBlock:(updatesCompletionBlock)_completionBlock
                   errorBlock:(updatesErrorBlock)_errorBlock
                progressBlock:(updatesProgressBlock)_progressBlock {
    self = [super init];
    if (self) {
        completionBlock = [_completionBlock copy];
        errorBlock = [_errorBlock copy];
        progressBlock = [_progressBlock copy];
    }
    return self;
}

- (void)start {
    [[NSFileManager defaultManager] setDelegate:self];
    [self downloadLastUpdatesFile];
}

- (BOOL)fileManager:(NSFileManager *)fileManager shouldProceedAfterError:(NSError *)error copyingItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath{
    if ([error code] == NSFileWriteFileExistsError) //error code for: The operation couldn’t be completed. File exists
        return YES;
    else
        return NO;
}

-(void) downloadLastUpdatesFile
{
    NSLog(@"Download updates xml");
    
    NSError * error = nil;
    
    NSString *downloadAssetsPath = [[DSData cachesPath] stringByAppendingPathComponent:@"/tmp"];
    
    NSString *downloadUpdatesPath = [downloadAssetsPath stringByAppendingPathComponent:@"/updates.xml"];
    
    NSString *updatesFileDBUrl = [BASE_URL stringByAppendingString:UPD_FILE];;
    
    [[NSFileManager defaultManager] createDirectoryAtPath:downloadAssetsPath withIntermediateDirectories:YES attributes:nil error:&error];
    
    if (error != nil) {
        if(errorBlock) errorBlock(error);
        return;
    }
    
    [URLDownloader asyncDownloadFile:updatesFileDBUrl toPath:downloadUpdatesPath completionBlock:^(NSString* savedPath) {
        NSLog(@"Done download updates xml");
        if(![[NSFileManager defaultManager] fileExistsAtPath:savedPath])
        {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Failed save updates xml" forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:@"DSUpdateDataErrorDomain" code:-1 userInfo:userInfo];
            if(errorBlock) errorBlock(error);
            return;
        }
        [self processUpdates];
    } errorBlock:^(NSError *error) {
        if(errorBlock) errorBlock(error);
    }progressBlock:^(float loaded, float total) {
        if(progressBlock) progressBlock(@"Downloading updates xml", loaded, total);
    }];
}

-(void)processUpdates
{
    NSLog(@"Process updates xml");
    NSString *oldAssetsPath = [[DSData cachesPath] stringByAppendingPathComponent:@"/Assets"];
    
    NSString *oldUpdatesPath = [oldAssetsPath stringByAppendingPathComponent:@"/updates.xml"];
    
    NSString *newAssetsPath = [[DSData cachesPath] stringByAppendingPathComponent:@"/tmp"];
    
    NSString *newUpdatesPath = [newAssetsPath stringByAppendingPathComponent:@"/updates.xml"];
    
    NSMutableArray *oldUpdates = [self loadUpdatesAtPath:oldUpdatesPath];
    
    NSMutableArray *newUpdates = [self loadUpdatesAtPath:newUpdatesPath];
    
    DSUpdate *latestLocalUpdate = [oldUpdates lastObject];
    DSUpdate *latestServiceUpdate = [newUpdates lastObject];
    if([latestServiceUpdate.date compare:latestLocalUpdate.date] == NSOrderedDescending)
    {
        NSLog(@"There is an update available");
        [self processUpdate:latestServiceUpdate];
    }
    else
    {
        NSLog(@"There is no update available");
        
        NSLog(@"Data update complete");
        
        if(completionBlock) completionBlock();
    }
}

-(void) processUpdate:(DSUpdate*)update
{
    NSLog(@"Download update zip");
    NSString *updateFileDBUrl = [BASE_URL stringByAppendingString: update.filename];
    
    NSString *oldAssetsPath = [[DSData cachesPath] stringByAppendingPathComponent:@"/Assets"];
    NSString *newAssetsPath = [[DSData cachesPath] stringByAppendingPathComponent:@"/tmp"];
    
    NSString *localUpdatesZipPath  = [newAssetsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", update.filename]];
    
    
    [URLDownloader asyncDownloadFile:updateFileDBUrl toPath:localUpdatesZipPath completionBlock:^(NSString* savedPath) {
        
        NSLog(@"Done download update zip");
        
        if([[NSFileManager defaultManager] fileExistsAtPath:savedPath])
        {
            
            NSLog(@"Update %@ saved", update.filename);
            
            NSLog(@"Unzip update");
            
            [ZIPArchiveProcessor asyncUnZipFile:localUpdatesZipPath toPath:newAssetsPath completionBlock:^(NSString* savedPath) {
                
                NSError * error = nil;
                
                NSLog(@"Done unzip update");
                NSString *newAssetsPathUnzipped = [newAssetsPath stringByAppendingPathComponent:@"/Assets"];
                if([[NSFileManager defaultManager] copyItemAtPath:newAssetsPathUnzipped toPath:oldAssetsPath error: &error])
                {
                    if([[NSFileManager defaultManager] fileExistsAtPath:oldAssetsPath])
                    {
                        NSLog(@"Done copy update");
                        
                        [[NSFileManager defaultManager] removeItemAtPath:newAssetsPath error:nil];
                        
                        [[DSData shared] loadDataLocal:NO];
                        
                        NSLog(@"Done Data update");
                        
                        if(completionBlock) completionBlock();
                    }
                    else
                    {                    NSLog(@"Failed copy update");
                        
                        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Failed copy directory" forKey:NSLocalizedDescriptionKey];
                        
                        error = [NSError errorWithDomain:@"DSUpdateDataErrorDomain" code:-1 userInfo:userInfo];
                        if(errorBlock) errorBlock(error);
                    }
                }
                else
                {
                    NSLog(@"Failed copy update: %@", [error description]);
                    if(!error)
                    {
                        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Failed copy directory" forKey:NSLocalizedDescriptionKey];
                        if (error) {
                            error = [NSError errorWithDomain:@"DSUpdateDataErrorDomain" code:-1 userInfo:userInfo];
                        }
                    }
                    if(errorBlock) errorBlock(error);
                }
            } errorBlock:^(NSError *error) {
                NSLog(@"Failed unzip update: %@", [error description]);
                if(errorBlock) errorBlock(error);
            }progressBlock:^(float loaded, float total) {
                if(progressBlock) progressBlock(@"UnZipping update archive", loaded, total);
            }];
        }
        else
        {
            NSLog(@"Failed download update zip");
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Failed to download update archive" forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:@"DSUpdateDataErrorDomain" code:-1 userInfo:userInfo];
            if(errorBlock) errorBlock(error);
        }
        
    } errorBlock:^(NSError *error) {
        NSLog(@"Failed download update zip: %@", [error description]);
        if(errorBlock) errorBlock(error);
    }progressBlock:^(float loaded, float total) {
        if(progressBlock) progressBlock(@"Downloading update archive", loaded, total);
    }];
}


-(NSMutableArray*) loadUpdatesAtPath:(NSString*)path
{
    
    NSLog(@"Loading updates xml at path: %@", path);
    
    NSMutableArray *result = [NSMutableArray new];
    
    NSError * error = nil;
    
    NSString * fileContents=[NSString stringWithContentsOfURL:[[NSURL alloc] initFileURLWithPath:path] encoding:
                             NSUTF8StringEncoding error:&error];
    
    if (!fileContents && error != nil) {
        NSLog(@"Failed to access file %@ \nError: %@", path, error);
        if(errorBlock) errorBlock(error);
        return nil;
    }
    
    DDXMLDocument *ddDoc = [[DDXMLDocument alloc] initWithXMLString:fileContents options:0 error:&error];
    if (!ddDoc && error != nil) {
        NSLog(@"Failed to parse file %@ \nError: %@", path, error);
        if(errorBlock) errorBlock(error);
        return nil;
    }
    
    NSArray *xmlItems = [ddDoc nodesForXPath:@"//update" error:&error];
    if (!xmlItems && error != nil) {
        NSLog(@"Failed to parse file %@ \nError: %@", path, error);
        if(errorBlock) errorBlock(error);
        return nil;
    }
    
    for(DDXMLElement* itemElement in xmlItems)
    {
        // Here you get the item->value attribute value as string...
        NSString *dateValueAsString = [[itemElement attributeForName:@"date"] stringValue];
        NSString *filenameValueAsString = [[itemElement attributeForName:@"filename"] stringValue];
        DSUpdate *update = [DSUpdate new];
        update.date = [NSDate dateFromString:dateValueAsString];
        update.filename = filenameValueAsString;
        update.isDone = NO;
        [result addObject:update];
    }
    
    NSArray *sortedArray;
    sortedArray = [result sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSDate *first = [(DSUpdate*)a date];
        NSDate *second = [(DSUpdate*)b date];
        return [first compare:second];
    }];
    
    NSLog(@"Done loading updates xml at path: %@", path);
    
    return [NSMutableArray arrayWithArray: sortedArray];
}

-(BOOL) saveUpdates:(NSArray *) updates atPath:(NSString*) path
{
    NSLog(@"Saving updates xml at path: %@", path);
    
    NSError * error = nil;
    DDXMLDocument* xmlDoc = [[DDXMLDocument alloc] initWithXMLString:@"<updates/>" options:0 error:&error];
    if (!xmlDoc && error != nil) {
        NSLog(@"Failed to parse file %@ \nError: %@", path, error);
        if(errorBlock) errorBlock(error);
        return NO;
    }
    DDXMLElement* root = [xmlDoc rootElement];
    
    for(DSUpdate *u in updates)
    {
        DDXMLElement  *n = [DDXMLElement  elementWithName:@"update"];
        [n addAttribute:[DDXMLNode attributeWithName:@"date" stringValue:[u.date toString]]];
        [n addAttribute:[DDXMLNode attributeWithName:@"filename" stringValue:u.filename]];
        [root addChild:n];
    }
    
    NSData *xmlData = [xmlDoc XMLDataWithOptions:DDXMLNodePrettyPrint];
    if (![xmlData writeToFile:path atomically:YES]) {
        
        NSLog(@"Could not write document out...");
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Could not write document out" forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:@"DSUpdateDataErrorDomain" code:-1 userInfo:userInfo];
        if(errorBlock) errorBlock(error);
        return NO;
    }
    
    NSLog(@"Done saving updates xml at path: %@", path);
    
    return YES;
}

@end
