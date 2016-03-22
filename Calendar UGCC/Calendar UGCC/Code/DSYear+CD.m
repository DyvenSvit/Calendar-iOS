//
//  DSYear+CD.m
//  CalendarUGCC
//
//  Created by Developer on 3/22/16.
//  Copyright © 2016 DyvenSvit. All rights reserved.
//

#import "DSYear+CD.h"

@implementation DSYear (CD)

+(BOOL)isWithYear:(NSInteger)year
{
    return [DSCoreDataUtils isManagedObjectOfClass:[DSYear class] forKeyValues:@{@"value":@(year)}];
}

+(DSYear*)getByYear:(NSInteger)year
{
    return (DSYear*)[DSCoreDataUtils getManagedObjectOfClass:[DSYear class] forKeyValues:@{@"value":@(year)}];
}

+(NSEntityDescription*)getEntity
{
    return [DSCoreDataUtils getEntityForClass:[DSYear class]];
}

+(NSArray*)getAll
{
    return [DSCoreDataUtils getAllManagedObjectOfClass:[DSYear class] sortedKey:@"value"];
}


@end
