//
//  DSDay+JSON.m
//  CalendarUGCC
//
//  Created by Developer on 3/25/16.
//  Copyright © 2016 DyvenSvit. All rights reserved.
//

#import "DSDay+JSON.h"

@implementation DSDay (JSON)

+(DSDay*) fromDictionary:(NSDictionary*) dictionary
{
    int day = [dictionary[@"date"] intValue];
    int month = [dictionary[@"month"] intValue];
    int year = [dictionary[@"year"] intValue];
    
    DSDay* objDay = nil;
    if([DSDay isWithYear:year month:month day:day])    {
        objDay = [DSDay getByYear:year month:month day:day];
    }
    else
    {
        objDay = [[DSDay alloc] initWithEntity:[DSDay getEntity] insertIntoManagedObjectContext:CDM.bgObjectContext];
        objDay.value = day;
        DSMonth* objMonth = nil;
        if([DSMonth isWithYear:year month:month])    {
            objMonth = [DSMonth getByYear:year month:month];
        }
        else
        {
            objMonth = [[DSMonth alloc] initWithEntity:[DSMonth getEntity] insertIntoManagedObjectContext:CDM.bgObjectContext];
            objMonth.value = month;
            DSYear* objYear = nil;
            if([DSYear isWithYear:year])    {
                objYear = [DSYear getByYear:year];
            }
            else
            {
                objYear = [[DSYear alloc] initWithEntity:[DSYear getEntity] insertIntoManagedObjectContext:CDM.bgObjectContext];
                objYear.value = year;
            }
            objMonth.year = objYear;
        }
        objDay.month = objMonth;
    }
    
        if(dictionary[@"hours"] && ![dictionary[@"hours"] isEqual:[NSNull null]])
    objDay.hours = dictionary[@"hours"];
        if(dictionary[@"liturgy"] && ![dictionary[@"liturgy"] isEqual:[NSNull null]])
    objDay.liturgy = dictionary[@"liturgy"];
        if(dictionary[@"morning"] && ![dictionary[@"morning"] isEqual:[NSNull null]])
    objDay.morning = dictionary[@"morning"];
        if(dictionary[@"night"] && ![dictionary[@"night"] isEqual:[NSNull null]])
    objDay.night = dictionary[@"night"];
        if(dictionary[@"quotes"] && ![dictionary[@"quotes"] isEqual:[NSNull null]])
    objDay.quotes = dictionary[@"quotes"];
        if(dictionary[@"saints"] && ![dictionary[@"saints"] isEqual:[NSNull null]])
    objDay.saints = dictionary[@"saints"];
        if(dictionary[@"readings"] && ![dictionary[@"readings"] isEqual:[NSNull null]])
    objDay.readings = dictionary[@"readings"];

    
    [CDM saveBgContext];
    
    return objDay;
}

@end
