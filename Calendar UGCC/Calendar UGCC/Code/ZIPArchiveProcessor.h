//
//  ZIPArchiveProcessor.h
//  CalendarUGCC
//
//  Created by Admin on 10/30/14.
//  Copyright (c) 2014 DyvenSvit. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^archiveCompletionBlock) (NSString *savedPath);
typedef void (^archiveErrorBlock) (NSError *error);
typedef void (^archiveProgressBlock) (float completed, float total);

@interface ZIPArchiveProcessor : NSObject <SSZipArchiveDelegate>

+ (void)asyncUnZipFile:(NSString*) filePath toPath:(NSString*) toPath
          completionBlock:(archiveCompletionBlock)completionBlock
               errorBlock:(archiveErrorBlock)errorBlock
            progressBlock:(archiveProgressBlock)progressBlock;

@end
