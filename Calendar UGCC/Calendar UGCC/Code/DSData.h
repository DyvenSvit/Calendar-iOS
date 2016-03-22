//
//  DSData.h
//  Calendar UGCC
//
//  Created by Max Gontar on 8/14/14.
//  Copyright (c) 2014 DyvenSvit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSYear+CD.h"
#import "DSMonth+CD.h"
#import "DSDay+CD.h"
#import "NSDate+Utils.h"

@interface DSData : NSObject

+ (DSData*)sharedWithLocal:(BOOL) local;
+ (DSData*)shared;
- (DSDay*)loadResourcesForDay:(DSDay*)day;
- (void)loadDataLocal:(BOOL) local;
+ (NSString *)cachesPath;
@end
