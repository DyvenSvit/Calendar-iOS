//
//  DSURLDownloader.m
//  CalendarUGCC
//
//  Created by Admin on 11/5/14.
//  Copyright (c) 2014 DyvenSvit. All rights reserved.
//

#import "URLDownloader.h"

@interface URLDownloader ()  <NSURLConnectionDelegate>{
    NSURLConnection *connection;
    NSMutableURLRequest *request;
    NSMutableData *data;
    NSURLResponse *response;
    long long downloadSize;
    
    NSString *pathSave;
    
    downloadCompletionBlock completionBlock;
    downloadErrorBlock errorBlock;
    downloadProgressBlock progressBlock;
}

- (id)initWithDownloadFile:(NSString*) _url toPath:(NSString*) _pathSave
                     token:(NSString*) _token
           completionBlock:(downloadCompletionBlock)_completionBlock
                errorBlock:(downloadErrorBlock)_errorBlock
             progressBlock:(downloadProgressBlock)_progressBlock;
- (void)start;
@end

@implementation URLDownloader

+ (void)asyncDownloadFile:(NSString*) url toPath:(NSString*) pathSave
                    token:(NSString*) token
          completionBlock:(downloadCompletionBlock)completionBlock
               errorBlock:(downloadErrorBlock)errorBlock
            progressBlock:(downloadProgressBlock)progressBlock

{
    URLDownloader *connection = [[URLDownloader alloc] initWithDownloadFile:url toPath: pathSave token:token
                                                                    completionBlock:completionBlock
                                                                         errorBlock:errorBlock
                                                                      progressBlock:progressBlock];
    [connection start];
}

+ (void)asyncDownloadFile:(NSString*) url toPath:(NSString*) pathSave
          completionBlock:(downloadCompletionBlock)completionBlock
               errorBlock:(downloadErrorBlock)errorBlock
            progressBlock:(downloadProgressBlock)progressBlock

{
    [self asyncDownloadFile: url toPath: pathSave token:nil completionBlock: completionBlock errorBlock: errorBlock progressBlock: progressBlock];
}

- (id)initWithDownloadFile:(NSString*) _url toPath:(NSString*) _pathSave
                     token:(NSString*) _token
           completionBlock:(downloadCompletionBlock)_completionBlock
                errorBlock:(downloadErrorBlock)_errorBlock
             progressBlock:(downloadProgressBlock)_progressBlock {
    self = [super init];
    if (self) {
        pathSave = [_pathSave copy];
        NSURL *url = [NSURL URLWithString:[_url copy]];
        request=[NSMutableURLRequest requestWithURL:url];
        
        [request setHTTPMethod:@"GET"];
        
        if(_token)
        {
            [request setValue:[NSString stringWithFormat:@"Bearer %@", _token] forHTTPHeaderField:@"Authorization"];
        }
        
        completionBlock = [_completionBlock copy];
        errorBlock = [_errorBlock copy];
        progressBlock = [_progressBlock copy];
    }
    return self;
}

-(void)start
{
    AFHTTPRequestOperation  *operation =   [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:pathSave append:NO];
    
    
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        if(progressBlock) progressBlock(totalBytesRead, totalBytesExpectedToRead);
        
    }];
    
    [operation setCompletionBlock:^{
        if(completionBlock) completionBlock(pathSave);
    }];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(completionBlock) completionBlock(pathSave);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(errorBlock) errorBlock(error);
    }];
    
    [operation start];
}


@end
