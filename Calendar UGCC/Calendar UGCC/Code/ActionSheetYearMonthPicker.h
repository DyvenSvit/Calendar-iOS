//
//  DSMonthPicker.h
//  CalendarUGCC
//
//  Created by Admin on 11/4/14.
//  Copyright (c) 2014 DyvenSvit. All rights reserved.
//

#import "ActionSheetCustomPicker.h"
#import "DSData.h"
#import "NSDate+Utils.h"

@class ActionSheetYearMonthPicker;

typedef void(^ActionYearMonthDoneBlock)(ActionSheetYearMonthPicker *picker, NSInteger selectedYearIndex, NSInteger selectedMonthIndex);
typedef void(^ActionYearMonthCancelBlock)(ActionSheetYearMonthPicker *picker);

@interface ActionSheetYearMonthPicker : ActionSheetCustomPicker <ActionSheetCustomPickerDelegate>

@property (nonatomic) NSInteger selectedYear;
@property (nonatomic) NSInteger selectedMonth;

+ (id)showPickerWithSelectedYear:(NSInteger)yearIndex month:(NSInteger)monthIndex doneBlock:(ActionYearMonthDoneBlock)doneBlock cancelBlock:(ActionYearMonthCancelBlock)cancelBlock origin:(id)origin;

@property (nonatomic, copy) ActionYearMonthDoneBlock onActionDone;
@property (nonatomic, copy) ActionYearMonthCancelBlock onActionCancel;
@end
