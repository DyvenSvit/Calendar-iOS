//
//  DSDay+CD.m
//  CalendarUGCC
//
//  Created by Developer on 3/22/16.
//  Copyright © 2016 DyvenSvit. All rights reserved.
//

#import "DSDay+CD.h"

@implementation DSDay (CD)

+(BOOL)isWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger) day
{
    return [DSCoreDataUtils isManagedObjectOfClass:[DSDay class] forKeyValues:
            @{
              @"value":@(day),
              @"month.value":@(month),
              @"month.year.value":@(year)
              }];
}

+(DSDay*)getByYear:(NSInteger)year month:(NSInteger)month day:(NSInteger) day
{
    return (DSDay*)[DSCoreDataUtils getManagedObjectOfClass:[DSDay class] forKeyValues:
                    @{
                      @"value":@(day),
                      @"month.value":@(month),
                      @"month.year.value":@(year)
                      }];
}

+(NSEntityDescription*)getEntity
{
    return [DSCoreDataUtils getEntityForClass:[DSDay class]];
}

+(NSArray*)getAll
{
    return [DSCoreDataUtils getAllManagedObjectOfClass:[DSDay class] sortedKey:@"value"];
}

@end
