//
//  DSDay+CD.h
//  CalendarUGCC
//
//  Created by Developer on 3/22/16.
//  Copyright © 2016 DyvenSvit. All rights reserved.
//

#import "DSDay.h"
#import "DSCoreDataUtils.h"

@interface DSDay (CD)

+(BOOL)isWithYear:(NSInteger) year month:(NSInteger)month day:(NSInteger) day;
+(DSDay*)getByYear:(NSInteger) year month:(NSInteger)month day:(NSInteger) day;
+(NSEntityDescription*)getEntity;
+(NSArray*)getAll;


@end
