//
//  DSData.h
//  Calendar UGCC
//
//  Created by Max Gontar on 8/14/14.
//  Copyright (c) 2014 DyvenSvit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSYear.h"
#import "DSMonth.h"
#import "DSDay.h"
#import "NSDate+Utils.h"

@interface DSData : NSObject
@property (strong, nonatomic) NSArray *years;
@property (strong, nonatomic) NSArray *monthNames;
@property (strong, nonatomic) NSArray *yearNames;

+ (DSData*)sharedWithLocal:(BOOL) local;
+ (DSData*)shared;
-(DSDay*)loadResourcesForDay:(DSDay*)day;
- (void)loadDataLocal:(BOOL) local;
+ (NSString *)cachesPath;
@end
