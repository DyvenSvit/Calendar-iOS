//
//  DSData.m
//  Calendar UGCC
//
//  Created by Max Gontar on 8/14/14.
//  Copyright (c) 2014 DyvenSvit. All rights reserved.
//

#import "DSData.h"

@implementation DSData
@synthesize years, monthNames, yearNames;
static DSData* result;

+ (NSString *)cachesPath
{
    static dispatch_once_t onceToken;
    static NSString *cachedPath;
    
    dispatch_once(&onceToken, ^{
        cachedPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    });
    
    return cachedPath;
}

+ (DSData*)shared
{
    
    if(result == nil)
    {
        result = [DSData new];
        [result loadDataLocal:NO];
    }
    
    return result;
}

+ (DSData*)sharedWithLocal:(BOOL) local
{
    if(result == nil)
    {
        result = [DSData new];
        [result loadDataLocal:local];
    }
    
    return result;
}

- (void)loadDataLocal:(BOOL) local
{
    
    monthNames  = [NSArray arrayWithObjects: @"Січень", @"Лютий", @"Березень", @"Квітень", @"Травень", @"Червень", @"Липень", @"Серпень", @"Вересень", @"Жовтень", @"Листопад", @"Грудень" , nil];
   
    
    NSURL *bundleURLBuildIn = [[NSBundle mainBundle] resourceURL];
    
    NSURL *bundleURLFile = [[NSURL alloc] initFileURLWithPath:[DSData cachesPath]];
    
    NSURL *path = (local)?bundleURLBuildIn:bundleURLFile;
    
    NSURL * assetsPath = [path URLByAppendingPathComponent:@"Assets"];
    
    [self loadYearsDataFromPath:assetsPath];
    /*
    
    NSURL * yearPath = [assetsPath URLByAppendingPathComponent:[NSString stringWithFormat:@"%ld", (long)[NSDate getCurrentYearNumber]]];
    
    NSInteger yearNumber = [NSDate getCurrentYearNumber];
    
    DSYear *year = [DSYear new];
    NSDateComponents *comps = [NSDateComponents new];
    [comps setYear:yearNumber];
    year.date = [[NSCalendar currentCalendar] dateFromComponents:comps];
    
    NSMutableArray *months = [NSMutableArray new];
    
    NSDirectoryEnumerator *enumerator = [fileManager enumeratorAtURL:yearPath
                                          includingPropertiesForKeys:@[NSURLNameKey, NSURLIsDirectoryKey]
                                                             options:NSDirectoryEnumerationSkipsHiddenFiles
                                                        errorHandler:^BOOL(NSURL *url, NSError *error)
                                         {
                                             NSLog(@"[Error] %@ (%@)", error, url);
                                             return YES;
                                         }];
    
    
    for (NSURL *fileURL in enumerator) {
        NSString *filename;
        [fileURL getResourceValue:&filename forKey:NSURLNameKey error:nil];
        
        NSNumber *isDirectory;
        [fileURL getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:nil];
        
        // Skip directories with '_' prefix, for example
        if ([filename hasPrefix:@"_"] && [isDirectory boolValue]) {
            [enumerator skipDescendants];
            continue;
        }
        if([isDirectory boolValue])
        {
            DSMonth *month =[DSMonth new];
            
            NSInteger monthNumber = [filename integerValue];
            NSDateComponents *comps = [NSDateComponents new];
            [comps setMonth:monthNumber];
            [comps setYear:yearNumber];
            month.date = [[NSCalendar currentCalendar] dateFromComponents:comps];
            
            NSURL *filePath=[fileURL URLByAppendingPathComponent:@"c.txt"];
            NSString *fileContents=[NSString stringWithContentsOfURL:filePath encoding:NSUTF8StringEncoding error:nil];
            NSArray *values = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
            
            NSMutableArray *days = [NSMutableArray new];
            
            for (NSString *lineStr in values) {
                
                if([lineStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length > 0)
                {
                    
                    DSDay *day = [DSDay new];
                    
                    
                    NSArray *parts = [lineStr componentsSeparatedByString:@"|"];
                    
                    NSInteger dayNumber = [[parts objectAtIndex:0] integerValue];
                    
                    NSDateComponents *comps = [NSDateComponents new];
                    [comps setDay:dayNumber];
                    [comps setMonth:monthNumber];
                    [comps setYear:yearNumber];
                    day.date = [[NSCalendar currentCalendar] dateFromComponents:comps];
                    
                    
                    day.isHoliday = [[parts objectAtIndex:2] boolValue];
                    day.fastingType =[[parts objectAtIndex:3] integerValue];
                    day.holidayTitle =[parts objectAtIndex:4];
                    day.reading =[parts objectAtIndex:5];
                    day.glas =[parts objectAtIndex:6];
                    [days addObject: day];
                }
            }
            
            month.days = [NSArray arrayWithArray:days];
            
            [months addObject:month];
        }
    }
    year.months = [NSArray arrayWithArray:months];
    
    years = [NSArray arrayWithObjects:year, nil];
     */
}

-(void) loadYearsDataFromPath:(NSURL*) yearURL
{
        NSMutableArray *yearNameArray = [NSMutableArray new];
    NSMutableArray *yearsArray = [NSMutableArray new];
        NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *enumerator = [fileManager enumeratorAtURL:yearURL
                                          includingPropertiesForKeys:@[NSURLNameKey, NSURLIsDirectoryKey]
                                                             options:NSDirectoryEnumerationSkipsSubdirectoryDescendants|NSDirectoryEnumerationSkipsHiddenFiles
                                                        errorHandler:^BOOL(NSURL *url, NSError *error)
                                         {
                                             NSLog(@"[Error] %@ (%@)", error, url);
                                             return YES;
                                         }];
    
    
    for (NSURL *fileURL in enumerator) {
        NSString *filename;
        [fileURL getResourceValue:&filename forKey:NSURLNameKey error:nil];
        
        NSNumber *isDirectory;
        [fileURL getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:nil];
        
        // Skip directories with '_' prefix, for example
        if ([filename hasPrefix:@"_"] && [isDirectory boolValue]) {
            [enumerator skipDescendants];
            continue;
        }
        if([isDirectory boolValue] && [filename integerValue] > 0)
        {
            DSYear *year = [DSYear new];
            
            NSInteger yearNumber = [filename integerValue];
            
            [yearNameArray addObject:[NSString stringWithFormat:@"%ld", (long)yearNumber]];
            
            NSDateComponents *comps = [NSDateComponents new];
            [comps setYear:yearNumber];
            year.date = [[NSCalendar currentCalendar] dateFromComponents:comps];
            [self loadMonthsDataForYear:&year fromPath:fileURL];
            [yearsArray addObject:year];
        }
    }
    
    years = [NSArray arrayWithArray:yearsArray];
    yearNames = [NSArray arrayWithArray:yearNameArray];
}
    
-(void)loadMonthsDataForYear:(DSYear**)year fromPath:(NSURL*) monthURL
    {
        NSMutableArray *monthsArray = [NSMutableArray new];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSDirectoryEnumerator *enumerator = [fileManager enumeratorAtURL:monthURL
                                              includingPropertiesForKeys:@[NSURLNameKey, NSURLIsDirectoryKey]
                                                                 options:NSDirectoryEnumerationSkipsSubdirectoryDescendants|NSDirectoryEnumerationSkipsHiddenFiles
                                                            errorHandler:^BOOL(NSURL *url, NSError *error)
                                             {
                                                 NSLog(@"[Error] %@ (%@)", error, url);
                                                 return YES;
                                             }];
        
        
        for (NSURL *fileURL in enumerator) {
            NSString *filename;
            [fileURL getResourceValue:&filename forKey:NSURLNameKey error:nil];
            
            NSNumber *isDirectory;
            [fileURL getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:nil];
            
            // Skip directories with '_' prefix, for example
            if ([filename hasPrefix:@"_"] && [isDirectory boolValue]) {
                [enumerator skipDescendants];
                continue;
            }
            if([isDirectory boolValue])
            {
                DSMonth *month =[DSMonth new];
                
                NSInteger monthNumber = [filename integerValue];
                NSDateComponents *comps = [NSDateComponents new];
                [comps setMonth:monthNumber];
                [comps setYear:[(*year).date getYearNumber]];
                month.date = [[NSCalendar currentCalendar] dateFromComponents:comps];
                
                [self loadDaysDataForMonth:&month fromPath:fileURL];
                
                [monthsArray addObject:month];
            }
        }
        (*year).months = monthsArray;
}

-(void)loadDaysDataForMonth:(DSMonth**)month fromPath:(NSURL*) monthURL
{
    NSURL *filePath=[monthURL URLByAppendingPathComponent:@"c.txt"];
    NSString *fileContents=[NSString stringWithContentsOfURL:filePath encoding:NSUTF8StringEncoding error:nil];
    NSArray *values = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    NSMutableArray *days = [NSMutableArray new];
    
    for (NSString *lineStr in values) {
        
        if([lineStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length > 0)
        {
            
            DSDay *day = [DSDay new];
            
            
            NSArray *parts = [lineStr componentsSeparatedByString:@"|"];
            
            NSInteger dayNumber = [[parts objectAtIndex:0] integerValue];
            
            NSDateComponents *comps = [NSDateComponents new];
            [comps setDay:dayNumber];
            [comps setMonth:[(*month).date getMonthNumber]];
            [comps setYear:[(*month).date getYearNumber]];
            day.date = [[NSCalendar currentCalendar] dateFromComponents:comps];
            
            
            day.isHoliday = [[parts objectAtIndex:2] boolValue];
            day.fastingType =[[parts objectAtIndex:3] integerValue];
            
            NSString *holidayTitle = [parts objectAtIndex:4];
            
            holidayTitle = day.isHoliday?[NSString stringWithFormat:@"<font color='#FF0000'>%@</font>", holidayTitle]:holidayTitle;
            
            NSMutableDictionary *options = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],DTUseiOS6Attributes, nil];
            
            
            day.holidayTitle = [[NSAttributedString alloc] initWithHTMLData:[holidayTitle dataUsingEncoding:NSUTF8StringEncoding] options:options documentAttributes:NULL];
            
            NSString *reading = [parts objectAtIndex:5];
            NSString *glas =[parts objectAtIndex:6];
            NSString *readingTitle = [[NSString stringWithFormat:@"%@ %@", [glas isEqualToString:@"*"]?@"": glas,  [reading isEqualToString:@"*"]?@"":reading] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
             day.readingTitle = [[NSAttributedString alloc] initWithHTMLData:[readingTitle dataUsingEncoding:NSUTF8StringEncoding] options:options documentAttributes:NULL];
            
            [days addObject: day];
        }
    }
    
    (*month).days = [NSArray arrayWithArray:days];
}

-(DSDay*)loadResourcesForDay:(DSDay*)day
{
    NSURL *bundleURL = [[NSURL alloc] initFileURLWithPath:[DSData cachesPath]];
    
    NSURL * documentsPath = [bundleURL URLByAppendingPathComponent:@"Assets"];
    NSURL * yearPath = [documentsPath URLByAppendingPathComponent:[NSString stringWithFormat:@"%04d", (int)[day.date getYearNumber]]];
    NSURL * monthPath = [yearPath URLByAppendingPathComponent:[NSString stringWithFormat:@"%02d", (int)[day.date getMonthNumber]]];
    
    
    NSURL * dayPath = [monthPath URLByAppendingPathComponent:[NSString stringWithFormat:@"u%02d.html", (int)[day.date getDayNumber]]];
    
    NSString *fileContents=[NSString stringWithContentsOfURL:dayPath encoding:
                            NSUTF8StringEncoding error:nil];
    day.dayLiturgy = fileContents;
    
    
    dayPath = [monthPath URLByAppendingPathComponent:[NSString stringWithFormat:@"t%02du.html", (int)[day.date getDayNumber]]];
    
    fileContents=[NSString stringWithContentsOfURL:dayPath encoding:
                  NSUTF8StringEncoding error:nil];
    day.dayMorningHours = fileContents;
    
    
    dayPath = [monthPath URLByAppendingPathComponent:[NSString stringWithFormat:@"t%02dv.html", (int)[day.date getDayNumber]]];
    
    fileContents=[NSString stringWithContentsOfURL:dayPath encoding:
                  NSUTF8StringEncoding error:nil];
    day.dayNightHours = fileContents;
    
    dayPath = [monthPath URLByAppendingPathComponent:[NSString stringWithFormat:@"t%02dc.html", (int)[day.date getDayNumber]]];
    
    fileContents=[NSString stringWithContentsOfURL:dayPath encoding:
                  NSUTF8StringEncoding error:nil];
    day.dayHours = fileContents;
    
    
    dayPath = [monthPath URLByAppendingPathComponent:[NSString stringWithFormat:@"b%02d.html", (int)[day.date getDayNumber ]]];
    
    fileContents=[NSString stringWithContentsOfURL:dayPath encoding:
                  NSUTF8StringEncoding error:nil];
    day.dayReadings = fileContents;
    
    dayPath = [monthPath URLByAppendingPathComponent:[NSString stringWithFormat:@"s%02d.html", (int)[day.date getDayNumber]]];
    
    fileContents=[NSString stringWithContentsOfURL:dayPath encoding:
                  NSUTF8StringEncoding error:nil];
    day.dayHoliday = fileContents;
    
    return day;
}



@end
