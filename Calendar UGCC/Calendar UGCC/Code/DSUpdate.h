//
//  DSUpdate.h
//  CalendarUGCC
//
//  Created by Admin on 10/24/14.
//  Copyright (c) 2014 DyvenSvit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSUpdate : NSObject
@property (strong, nonatomic) NSDate *date;
@property (assign, nonatomic) BOOL isDone;
@property (strong, nonatomic) NSString *filename;
@end
