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
{int iDATA = (int)[[[NSCalendar currentCalendar]  components:NSCalendarUnitDay fromDate:[self getDate]] day];
 return [NSString stringWithFormat:@"%d", iDATA];
}

-(NSString*) getOldStyleDateString
{
    int iDATAOLD = (int)[[[NSCalendar currentCalendar]  components:NSCalendarUnitDay fromDate:[self getDate]] day] - 13;
    if (iDATAOLD < 1) {
        switch ([[[NSCalendar currentCalendar]  components:NSCalendarUnitMonth fromDate:[self getDate]] month]) {
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
-(NSString*) getWeekDayString
{
    NSString *result = @"";
    switch ([[[NSCalendar currentCalendar]  components:NSCalendarUnitWeekday fromDate:[self getDate]] weekday]) {
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
    
    
    return result;
}

-(CGFloat) getDayBgAlpha
{
    CGFloat result = [[self getDate] isToday]?0.90:0.70;
    
    return result;
}

-(UIImage*) getFastimgImage
{
    UIImage *result = nil;
    switch (self.fastingType) {
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
