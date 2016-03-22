//
//  DSCoreDataManager.h
//  CalendarUGCC
//
//  Created by Developer on 3/22/16.
//  Copyright © 2016 DyvenSvit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DSCoreDataManager : NSObject

@property (nonatomic, readonly, retain) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, readonly, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, readonly, retain) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (DSCoreDataManager*)sharedInstance;
- (void)saveContext;

@end
