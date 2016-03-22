//
//  DSMonthPicker.h
//  CalendarUGCC
//
//  Created by Admin on 11/4/14.
//  Copyright (c) 2014 DyvenSvit. All rights reserved.
//

#import "ActionSheetCustomPicker.h"
#import "DSYear+CD.h"
#import "NSDate+Utils.h"

@class ActionSheetYearMonthPicker;

typedef void(^ActionYearMonthDoneBlock)(ActionSheetYearMonthPicker *picker, NSInteger selectedYear, NSInteger selectedMonth);
typedef void(^ActionYearMonthCancelBlock)(ActionSheetYearMonthPicker *picker);

@interface ActionSheetYearMonthPicker : ActionSheetCustomPicker <ActionSheetCustomPickerDelegate>

@property (nonatomic) NSInteger selectedYear;
@property (nonatomic) NSInteger selectedMonth;

+ (id)showPickerWithSelectedYear:(NSInteger)year month:(NSInteger)month doneBlock:(ActionYearMonthDoneBlock)doneBlock cancelBlock:(ActionYearMonthCancelBlock)cancelBlock origin:(id)origin;

@property (nonatomic, copy) ActionYearMonthDoneBlock onActionDone;
@property (nonatomic, copy) ActionYearMonthCancelBlock onActionCancel;
@end
