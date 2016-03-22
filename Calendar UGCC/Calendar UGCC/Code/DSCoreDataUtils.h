//
//  DSCoreDataUtils.h
//  CalendarUGCC
//
//  Created by Developer on 3/22/16.
//  Copyright © 2016 DyvenSvit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSCoreDataManager.h"

@interface DSCoreDataUtils : NSObject

+(BOOL)isManagedObjectOfClass:(Class)classArg  forKeyValues:(NSDictionary*)keyValues;

+(NSManagedObject*)getManagedObjectOfClass:(Class)classArg forKeyValues:(NSDictionary*)keyValues;

+(NSArray*)getAllManagedObjectOfClass:(Class)classArg sortedKey:(NSString*)keyName;

+(NSEntityDescription*)getEntityForClass:(Class)classArg;

@end
