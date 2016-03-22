//
//  DSMonth+CD.m
//  CalendarUGCC
//
//  Created by Developer on 3/22/16.
//  Copyright © 2016 DyvenSvit. All rights reserved.
//

#import "DSMonth+CD.h"

@implementation DSMonth (CD)

+(BOOL)isWithYear:(NSInteger)year month:(NSInteger)month
{
    return [DSCoreDataUtils isManagedObjectOfClass:[DSMonth class] forKeyValues:
            @{
              @"value":@(month),
              @"year.value":@(year)
              }];
}

+(DSMonth*)getByYear:(NSInteger)year month:(NSInteger)month
{
    return (DSMonth*)[DSCoreDataUtils getManagedObjectOfClass:[DSMonth class] forKeyValues:
                      @{
                        @"value":@(month),
                        @"year.value":@(year)
                        }];
}

+(NSEntityDescription*)getEntity
{
    return [DSCoreDataUtils getEntityForClass:[DSMonth class]];
}

+(NSArray*)getAll
{
    return [DSCoreDataUtils getAllManagedObjectOfClass:[DSMonth class] sortedKey:@"value"];
}

@end
