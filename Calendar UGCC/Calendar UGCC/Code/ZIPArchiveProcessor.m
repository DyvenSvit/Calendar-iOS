//
//  ZIPArchiveProcessor.m
//  CalendarUGCC
//
//  Created by Admin on 10/30/14.
//  Copyright (c) 2014 DyvenSvit. All rights reserved.
//

#import "ZIPArchiveProcessor.h"

@interface ZIPArchiveProcessor () {
    NSString *zipPath;
    NSString *savePath;
    
    archiveCompletionBlock completionBlock;
    archiveErrorBlock errorBlock;
    archiveProgressBlock progressBlock;
}

- (id)initWithUnZipFile:(NSString*) filePath toPath:(NSString*) toPath
       completionBlock:(archiveCompletionBlock)completionBlock
            errorBlock:(archiveErrorBlock)errorBlock
         progressBlock:(archiveProgressBlock)progressBlock;
- (void)start;
@end

@implementation ZIPArchiveProcessor

+ (void)asyncUnZipFile:(NSString*) filePath toPath:(NSString*) toPath
       completionBlock:(archiveCompletionBlock)completionBlock
            errorBlock:(archiveErrorBlock)errorBlock
         progressBlock:(archiveProgressBlock)progressBlock;

{
    ZIPArchiveProcessor *connection = [[ZIPArchiveProcessor alloc] initWithUnZipFile:filePath toPath: toPath
                                                                    completionBlock:completionBlock
                                                                         errorBlock:errorBlock
                                                                      progressBlock:progressBlock];
    [connection start];
}

- (id)initWithUnZipFile:(NSString*) filePath toPath:(NSString*) toPath
           completionBlock:(archiveCompletionBlock)_completionBlock
                errorBlock:(archiveErrorBlock)_errorBlock
             progressBlock:(archiveProgressBlock)_progressBlock {
    self = [super init];
    if (self) {
        zipPath = [filePath copy];
        savePath = [toPath copy];
        completionBlock = [_completionBlock copy];
        errorBlock = [_errorBlock copy];
        progressBlock = [_progressBlock copy];
    }
    return self;
}

- (void)start {
    NSError *error;
    if([SSZipArchive unzipFileAtPath:zipPath toDestination:savePath overwrite:YES password:nil error:&error delegate:self])
    {
        if(completionBlock) completionBlock(savePath);
    }
    else
    {
        if(!error)
        {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Failed to unzip file" forKey:NSLocalizedDescriptionKey];
            if (error) {
                error = [NSError errorWithDomain:@"ZIPArchiveProcessorErrorDomain" code:-1 userInfo:userInfo];
            }
        }
        if(errorBlock) errorBlock(error);
    }
}

- (void)zipArchiveProgressEvent:(NSInteger)loaded total:(NSInteger)total
{
    if(progressBlock) progressBlock(loaded, total);
}

@end
