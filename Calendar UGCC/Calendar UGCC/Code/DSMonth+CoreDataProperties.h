//
//  DSMonth+CoreDataProperties.h
//  CalendarUGCC
//
//  Created by Developer on 3/23/16.
//  Copyright © 2016 DyvenSvit. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DSMonth.h"

NS_ASSUME_NONNULL_BEGIN

@interface DSMonth (CoreDataProperties)

@property (nonatomic) int16_t value;
@property (nonatomic) BOOL loaded;
@property (nullable, nonatomic, retain) NSOrderedSet<DSDay *> *days;
@property (nullable, nonatomic, retain) DSYear *year;

@end

@interface DSMonth (CoreDataGeneratedAccessors)

- (void)insertObject:(DSDay *)value inDaysAtIndex:(NSUInteger)idx;
- (void)removeObjectFromDaysAtIndex:(NSUInteger)idx;
- (void)insertDays:(NSArray<DSDay *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeDaysAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInDaysAtIndex:(NSUInteger)idx withObject:(DSDay *)value;
- (void)replaceDaysAtIndexes:(NSIndexSet *)indexes withDays:(NSArray<DSDay *> *)values;
- (void)addDaysObject:(DSDay *)value;
- (void)removeDaysObject:(DSDay *)value;
- (void)addDays:(NSOrderedSet<DSDay *> *)values;
- (void)removeDays:(NSOrderedSet<DSDay *> *)values;

@end

NS_ASSUME_NONNULL_END
