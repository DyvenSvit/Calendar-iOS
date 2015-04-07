//
//  NSDate+Utils.m
//  Calendar UGCC
//
//  Created by Max Gontar on 8/15/14.
//  Copyright (c) 2014 DyvenSvit. All rights reserved.
//

#import "NSDate+Utils.h"

@implementation NSDate (Utils)

-(BOOL) isToday
{
    return  [self isSameDay:[NSDate date]];
}


-(BOOL) isSameDay:(NSDate*)date
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:date];
    
    NSDate *dateArg = [cal dateFromComponents:components];
    
    components = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:self];
    
    NSDate *dateSelf = [cal dateFromComponents:components];
    
    return [dateSelf isEqualToDate:dateArg];
}

-(BOOL) isSameMonth:(NSDate*)date
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth) fromDate:date];
    
    NSDate *dateArg = [cal dateFromComponents:components];
    
    components = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth) fromDate:self];
    
    NSDate *dateSelf = [cal dateFromComponents:components];
    
    return [dateSelf isEqualToDate:dateArg];
}

+(NSInteger) getCurrentMonthNumber
{
    return [self getMonthNumberFromDate:[NSDate date]];
}

+(NSInteger) getMonthNumberFromDate:(NSDate*)date
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:date];
    return [components month];
}

-(NSInteger) getMonthNumber
{
    return [NSDate getMonthNumberFromDate:self];
}

+(NSInteger) getCurrentYearNumber
{
    return [self getYearNumberFromDate:[NSDate date]];
}

+(NSInteger) getYearNumberFromDate:(NSDate*)date
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:date];
    return [components year];
}

-(NSInteger) getYearNumber
{
    return [NSDate getYearNumberFromDate:self];
}

+(NSInteger) getCurrentDayNumber
{
    return [self getDayNumberFromDate:[NSDate date]];
}

+(NSInteger) getDayNumberFromDate:(NSDate*)date
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:date];
    return [components day];
}

-(NSInteger) getDayNumber
{
    return [NSDate getDayNumberFromDate:self];
}

-(BOOL) isWeekend
{
    return [[[NSCalendar currentCalendar]  components:NSCalendarUnitWeekday fromDate:self] weekday] == 1;
}

+(NSDate*) dateFromString:(NSString*) strDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // this is imporant - we set our input date format to match our input string
    // if format doesn't match you'll get nil from your string, so be careful
    [dateFormatter setDateFormat:@"dd.MM.yy"];

    NSDate *dateFromString = [dateFormatter dateFromString:strDate];
    return dateFromString;
}

-(NSString*) toString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yy"];
    NSString *stringDate = [dateFormatter stringFromDate:self];
    return stringDate;
}

@end
