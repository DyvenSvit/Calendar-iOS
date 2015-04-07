//
//  NSDate+Utils.h
//  Calendar UGCC
//
//  Created by Max Gontar on 8/15/14.
//  Copyright (c) 2014 DyvenSvit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Utils)

-(BOOL) isToday;
-(BOOL) isSameDay:(NSDate*)date;
-(BOOL) isSameMonth:(NSDate*)date;

-(NSInteger) getMonthNumber;
+(NSInteger) getCurrentMonthNumber;
+(NSInteger) getMonthNumberFromDate:(NSDate*)date;

-(NSInteger) getYearNumber;
+(NSInteger) getCurrentYearNumber;
+(NSInteger) getYearNumberFromDate:(NSDate*)date;

-(NSInteger) getDayNumber;
+(NSInteger) getCurrentDayNumber;
+(NSInteger) getDayNumberFromDate:(NSDate*)date;

-(BOOL) isWeekend;

+(NSDate*) dateFromString:(NSString*) strDate;
-(NSString*) toString;
@end
