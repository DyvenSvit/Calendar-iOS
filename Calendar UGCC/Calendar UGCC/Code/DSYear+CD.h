//
//  DSYear+CD.h
//  CalendarUGCC
//
//  Created by Developer on 3/22/16.
//  Copyright © 2016 DyvenSvit. All rights reserved.
//

#import "DSYear.h"
#import "DSCoreDataUtils.h"
@interface DSYear (CD)

+(BOOL)isWithYear:(NSInteger)year;
+(DSYear*)getByYear:(NSInteger)year;
+(NSEntityDescription*)getEntity;
+(NSArray*)getAll;

@end
