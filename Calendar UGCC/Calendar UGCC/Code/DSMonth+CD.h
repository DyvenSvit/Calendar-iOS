//
//  DSMonth+CD.h
//  CalendarUGCC
//
//  Created by Developer on 3/22/16.
//  Copyright © 2016 DyvenSvit. All rights reserved.
//

#import "DSMonth.h"
#import "DSCoreDataUtils.h"

@interface DSMonth (CD)

+(BOOL)isWithYear:(NSInteger) year month:(NSInteger)month;
+(DSMonth*)getByYear:(NSInteger) year month:(NSInteger)month;
+(NSEntityDescription*)getEntity;
+(NSArray*)getAll;

@end
