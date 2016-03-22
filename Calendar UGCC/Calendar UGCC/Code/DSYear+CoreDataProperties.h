//
//  DSYear+CoreDataProperties.h
//  CalendarUGCC
//
//  Created by Developer on 3/22/16.
//  Copyright © 2016 DyvenSvit. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DSYear.h"

NS_ASSUME_NONNULL_BEGIN

@interface DSYear (CoreDataProperties)

@property (nonatomic) int16_t value;
@property (nullable, nonatomic, retain) NSOrderedSet<DSMonth *> *months;

@end

@interface DSYear (CoreDataGeneratedAccessors)

- (void)insertObject:(DSMonth *)value inMonthsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromMonthsAtIndex:(NSUInteger)idx;
- (void)insertMonths:(NSArray<DSMonth *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeMonthsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInMonthsAtIndex:(NSUInteger)idx withObject:(DSMonth *)value;
- (void)replaceMonthsAtIndexes:(NSIndexSet *)indexes withMonths:(NSArray<DSMonth *> *)values;
- (void)addMonthsObject:(DSMonth *)value;
- (void)removeMonthsObject:(DSMonth *)value;
- (void)addMonths:(NSOrderedSet<DSMonth *> *)values;
- (void)removeMonths:(NSOrderedSet<DSMonth *> *)values;

@end

NS_ASSUME_NONNULL_END
