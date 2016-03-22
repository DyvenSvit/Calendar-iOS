//
//  DSDay+CoreDataProperties.h
//  CalendarUGCC
//
//  Created by Developer on 3/22/16.
//  Copyright © 2016 DyvenSvit. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DSDay.h"

NS_ASSUME_NONNULL_BEGIN

@interface DSDay (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *hours;
@property (nullable, nonatomic, retain) NSString *liturgy;
@property (nullable, nonatomic, retain) NSString *morning;
@property (nullable, nonatomic, retain) NSString *night;
@property (nullable, nonatomic, retain) NSString *quotes;
@property (nullable, nonatomic, retain) NSString *readings;
@property (nullable, nonatomic, retain) NSString *saints;
@property (nonatomic) int16_t value;
@property (nonatomic) BOOL isHoliday;
@property (nonatomic) int16_t fastingType;
@property (nullable, nonatomic, retain) NSString *holidayTitle;
@property (nullable, nonatomic, retain) NSString *readingTitle;
@property (nonatomic) NSTimeInterval date;
@property (nullable, nonatomic, retain) NSAttributedString *holidayTitleAttr;
@property (nullable, nonatomic, retain) NSAttributedString *readingTitleAttr;
@property (nullable, nonatomic, retain) DSMonth *month;

@end

NS_ASSUME_NONNULL_END
