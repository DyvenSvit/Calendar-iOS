//
//  DSManageData.h
//  CalendarUGCC
//
//  Created by Admin on 11/6/14.
//  Copyright (c) 2014 DyvenSvit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSData.h"

typedef void (^manageCompletionBlock)();
typedef void (^manageErrorBlock) (NSError *error);

@interface DSManageData : NSObject <NSFileManagerDelegate>

@property (strong, atomic) manageCompletionBlock completionBlock;
@property (strong, atomic) manageErrorBlock errorBlock;

- (id)initWithCompletionBlock:(manageCompletionBlock)completionBlock
                   errorBlock:(manageErrorBlock)errorBlock;
- (void)start;
@end
