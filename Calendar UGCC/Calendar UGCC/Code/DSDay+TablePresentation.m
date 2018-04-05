//
//  DSDay+TablePresentation.m
//  Calendar UGCC
//
//  Created by Max Gontar on 8/14/14.
//  Copyright (c) 2014 DyvenSvit. All rights reserved.
//

#import "DSDay+TablePresentation.h"

@implementation DSDay (TablePresentation)

-(NSDate*) getDate
{
    return [NSDate dateWithTimeIntervalSince1970:self.date];
}

-(NSString*) getDateString
{
    int iDATA = (int)[self getDayInt];
    return [NSString stringWithFormat:@"%d", iDATA];
}

-(NSString*) getOldStyleDateString
{
    int iDATAOLD = (int)[self getDayInt] - 13;
    if (iDATAOLD < 1) {
        switch ([self getMonthInt]) {
            case 1:
                iDATAOLD = iDATAOLD+31;
                break;
            case 2:
                iDATAOLD = iDATAOLD+31;
                break;
            case 3:
                iDATAOLD = iDATAOLD+28;
                break;
            case 4:
                iDATAOLD = iDATAOLD+31;
                break;
            case 5:
                iDATAOLD = iDATAOLD+30;
                break;
            case 6:
                iDATAOLD = iDATAOLD+31;
                break;
            case 7:
                iDATAOLD = iDATAOLD+30;
                break;
            case 8:
                iDATAOLD = iDATAOLD+31;
                break;
            case 9:
                iDATAOLD = iDATAOLD+31;
                break;
            case 10:
                iDATAOLD = iDATAOLD+30;
                break;
            case 11:
                iDATAOLD = iDATAOLD+31;
                break;
            case 12:
                iDATAOLD = iDATAOLD+30;
                break;
        }
    }
    return [NSString stringWithFormat:@"%d", iDATAOLD];
}

- (NSInteger) getDayInt
{
    return [[[NSCalendar currentCalendar]  components:NSCalendarUnitDay fromDate:[self getDate]] day];
}

- (NSInteger) getMonthInt
{
    return [[[NSCalendar currentCalendar]  components:NSCalendarUnitMonth fromDate:[self getDate]] month];
}

- (NSInteger) getYearInt
{
    return [[[NSCalendar currentCalendar]  components:NSCalendarUnitYear fromDate:[self getDate]] year];
}

- (NSInteger) getWeekDayInt
{
    return [[[NSCalendar currentCalendar]  components:NSCalendarUnitWeekday fromDate:[self getDate]] weekday];
}

-(NSString*) getWeekDayString
{
    NSString *result = @"";
    switch ([self getWeekDayInt]) {
        case 1:
            result = @"Нд";
            break;
        case 2:
            result = @"Пн";
            break;
        case 3:
            result = @"Вт";
            break;
        case 4:
            result = @"Ср";
            break;
        case 5:
            result = @"Чт";
            break;
        case 6:
            result = @"Пт";
            break;
        case 7:
            result = @"Сб";
            break;
        default:
            break;
    }

    return result;

}

-(UIColor*) getDayMainBgColor
{
    UIColor *result =  [UIColor colorWithHexString:@"9FFF00"];
    
    if(self.isHoliday || [[self getDate] isWeekend])
    {
        result = [UIColor colorWithHexString:@"FF7400"];
    }

    switch ([self getFastingTypeU]) {
        case FastingNone:
            break;
        case FastingSimple:
            result = [UIColor colorWithHexString:@"AA00FF"];
            break;
        case FastingStrong:
            result = [UIColor colorWithHexString:@"AB47BC"];
            break;
        case FastingFree:
            break;
        default:
            break;
    }
    return result;
}

-(CGFloat) getDayBgAlpha
{
    CGFloat result = [[self getDate] isToday]?0.90:0.70;
    
    return result;
}

- (NSInteger) getFastingTypeU
{
    NSInteger result = 0;
    switch (self.fastingType) {
        case FastingNone:
            result = FastingNone;
            break;
        case FastingSimple:
        {
            NSInteger year = [self getYearInt];
            NSInteger month = [self getMonthInt];
            NSInteger day = [self getDayInt];
            NSInteger wday = [self getWeekDayInt];
            
            if ((month > 1 && month < 6) && (wday == 2||wday == 4||wday == 6))
            {
                result = FastingSimple;
            }
            else if (wday == 4||wday == 6)
            {
                result = FastingSimple;
            }
            else if (year == 2017 && ((month == 2 && day == 28) ||
                                      (month == 3 && day == 2) ||
                                      (month == 4 && day == 11) ||
                                      (month == 4 && day == 13) ||
                                      (month == 4 && day == 15)))
            {
                result = FastingSimple;
            }
            else
            {
                result = FastingFree;
            }

            break;
        }
        case FastingStrong:
            result = FastingStrong;
            break;
        case FastingFree:
            result = FastingFree;
            break;
        default:
            break;
    }
    return result;
}

-(UIImage*) getFastingImage
{
    UIImage *result = nil;
    switch ([self getFastingTypeU]) {
        case FastingNone:
            result = nil;
            break;
        case FastingSimple:
            result = [UIImage imageNamed:@"fasting"];
            break;
        case FastingStrong:
            result = [UIImage imageNamed:@"fasting_strong"];
            break;
        case FastingFree:
            result = nil;
            break;
        default:
            break;
    }
    return result;
}

@end
