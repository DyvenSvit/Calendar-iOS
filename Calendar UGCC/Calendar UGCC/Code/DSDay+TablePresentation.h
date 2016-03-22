//
//  DSDay+TablePresentation.h
//  Calendar UGCC
//
//  Created by Max Gontar on 8/14/14.
//  Copyright (c) 2014 DyvenSvit. All rights reserved.
//

#import "DSDay.h"
#import "UIColor+Utils.h"
#import "NSDate+Utils.h"

enum FastingType : NSInteger {
    FastingNone = 0,
    FastingSimple = 1,
    FastingStrong = 2,
    FastingFree = 3
};

@interface DSDay (TablePresentation)

-(NSString*) getDateString;
-(NSString*) getOldStyleDateString;
-(NSString*) getWeekDayString;
-(UIColor*) getDayMainBgColor;
-(CGFloat) getDayBgAlpha;
-(UIImage*) getFastimgImage;
-(NSDate*) getDate;
@end
