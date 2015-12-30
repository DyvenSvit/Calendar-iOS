//
//  DSDay.h
//  Calendar UGCC
//
//  Created by Max Gontar on 8/14/14.
//  Copyright (c) 2014 DyvenSvit. All rights reserved.
//

#import <Foundation/Foundation.h>

enum FastingType : NSInteger {
    FastingNone = 0,
    FastingSimple = 1,
    FastingStrong = 2,
    FastingFree = 3
};

@interface DSDay : NSObject
@property (strong, nonatomic) NSDate *date;
@property (assign, nonatomic) BOOL isHoliday;
@property (assign, nonatomic) enum FastingType fastingType;
@property (strong, nonatomic) NSString *holidayTitleStr;
@property (strong, nonatomic) NSString *readingTitleStr;
@property (strong, nonatomic) NSAttributedString *holidayTitle;
@property (strong, nonatomic) NSAttributedString *readingTitle;

@property (strong, nonatomic) NSString *dayLiturgy;
@property (strong, nonatomic) NSString *dayMorningHours;
@property (strong, nonatomic) NSString *dayNightHours;
@property (strong, nonatomic) NSString *dayReadings;
@property (strong, nonatomic) NSString *dayHoliday;
@property (strong, nonatomic) NSString *dayHours;
@end
