//
//  DSWebAPI.h
//  CalendarUGCC
//
//  Created by Developer on 3/24/16.
//  Copyright © 2016 DyvenSvit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "DSDay+JSON.h"

@interface DSWebAPI : NSObject
+ (void)getYear:(NSInteger) year month:(NSInteger) month day:(NSInteger) day withCompletionBlock:(void (^)(DSDay* day, NSError *error))complete;
@end
