//
//  DSURLDownloader.h
//  CalendarUGCC
//
//  Created by Admin on 11/5/14.
//  Copyright (c) 2014 DyvenSvit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

typedef void (^downloadCompletionBlock) (NSString *savedPath);
typedef void (^downloadErrorBlock) (NSError *error);
typedef void (^downloadProgressBlock) (float loaded, float total);

@interface URLDownloader : NSObject <NSURLConnectionDelegate>

+ (void)asyncDownloadFile:(NSString*) url toPath:(NSString*) pathSave
                    token:(NSString*) token
          completionBlock:(downloadCompletionBlock)completionBlock
               errorBlock:(downloadErrorBlock)errorBlock
            progressBlock:(downloadProgressBlock)progressBlock;


+ (void)asyncDownloadFile:(NSString*) url toPath:(NSString*) pathSave
          completionBlock:(downloadCompletionBlock)completionBlock
               errorBlock:(downloadErrorBlock)errorBlock
            progressBlock:(downloadProgressBlock)progressBlock;

@end
