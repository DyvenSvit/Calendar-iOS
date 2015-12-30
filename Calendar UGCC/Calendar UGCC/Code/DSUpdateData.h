//
//  DSUpdateData.h
//  CalendarUGCC
//
//  Created by Admin on 10/27/14.
//  Copyright (c) 2014 DyvenSvit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDate+Utils.h"
#import "DSUpdate.h"
#import "URLDownloader.h"
#import "DSData.h"

typedef void (^updatesCompletionBlock)();
typedef void (^updatesErrorBlock) (NSError *error);
typedef void (^updatesProgressBlock) (NSString *status, float completed, float total);

@interface DSUpdateData : NSObject <NSFileManagerDelegate>

@property (strong, atomic) updatesCompletionBlock completionBlock;
@property (strong, atomic) updatesErrorBlock errorBlock;
@property (strong, atomic) updatesProgressBlock progressBlock;


- (id)initWithCompletionBlock:(updatesCompletionBlock)completionBlock
                   errorBlock:(updatesErrorBlock)errorBlock
                progressBlock:(updatesProgressBlock)progressBlock;
- (void)start;

@end
