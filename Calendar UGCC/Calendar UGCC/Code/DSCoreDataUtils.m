//
//  DSCoreDataUtils.m
//  CalendarUGCC
//
//  Created by Developer on 3/22/16.
//  Copyright © 2016 DyvenSvit. All rights reserved.
//

#import "DSCoreDataUtils.h"

@implementation DSCoreDataUtils

+(BOOL)isManagedObjectOfClass:(Class)classArg forKeyValues:(NSDictionary*)keyValues
{
    BOOL result = NO;
    
    NSError * error;
    
    NSFetchRequest * request = [self getFetchRequestForManagedObjectOfClass:classArg forKeyValues:keyValues];
    
    result = [[NSThread isMainThread]?CDM.mainObjectContext:CDM.bgObjectContext countForFetchRequest:request error:&error] > 0;
    
    return result;
}

+(NSManagedObject*)getManagedObjectOfClass:(Class)classArg forKeyValues:(NSDictionary*)keyValues
{
    NSManagedObject* result = nil;
    
    NSError * error;
    
    NSFetchRequest * request = [self getFetchRequestForManagedObjectOfClass:classArg forKeyValues:keyValues];
    NSArray *array = [[NSThread isMainThread]?CDM.mainObjectContext:CDM.bgObjectContext executeFetchRequest:request error:&error];
    if(!error &&[array count]>0)
    {
        result = [array objectAtIndex:0];
    }
    
    return result;
}

+(NSFetchRequest*)getFetchRequestForManagedObjectOfClass:(Class)classArg forKeyValues:(NSDictionary*)keyValues
{
    NSFetchRequest* result = [[NSFetchRequest alloc] init];
    [result setEntity:[self getEntityForClass:classArg]];

    [result setFetchLimit:1];
    
    NSMutableArray* predicates = [NSMutableArray new];
    for (NSString* key in keyValues)
    {
        if(!result.sortDescriptors.count)
        {
            [result setSortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:key ascending:YES]]];
        }
        
        [predicates addObject:[NSPredicate predicateWithFormat:@"%K == %@",key, keyValues[key]]];
        
    }
    
    [result setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:predicates]];
    return result;
}

+(NSArray*)getAllManagedObjectOfClass:(Class)classArg sortedKey:(NSString*)keyName;
{
    NSArray *result = nil;
    
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    [request setEntity:[self getEntityForClass:classArg]];
    [request setSortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:keyName ascending:YES]]];
    
    NSError * error;
    
    NSArray *array = [[NSThread isMainThread]?CDM.mainObjectContext:CDM.bgObjectContext executeFetchRequest:request error:&error];
    if(!error &&[array count]>0)
    {
        result = array;
    }
    
    return result;
}

+(NSEntityDescription*)getEntityForClass:(Class)classArg
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass(classArg) inManagedObjectContext:[NSThread isMainThread]?CDM.mainObjectContext:CDM.bgObjectContext];
    return entity;
}

@end
