//
//  DSMonth+Presentation.m
//  CalendarUGCC
//
//  Created by Developer on 3/22/16.
//  Copyright © 2016 DyvenSvit. All rights reserved.
//

#import "DSMonth+Presentation.h"

@implementation DSMonth (Presentation)

-(NSString*) getTitleString
{
    return [NSString stringWithFormat:@"%@ (%d)",  MONTH_NAMES[self.value-1], self.year.value];
}

@end
