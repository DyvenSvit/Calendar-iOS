///
//  DSData.m
//  Calendar UGCC
//
//  Created by Max Gontar on 8/14/14.
//  Copyright (c) 2014 DyvenSvit. All rights reserved.
//

#import "DSData.h"

@implementation DSData

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
        [result loadDataLocal:YES];
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
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.dyvensvit.CalendarUGCC"];
    
    NSString *lastSavedVersion = [shared objectForKey:@"app.version"];
    
    NSString *majorVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *minorVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    NSString *currentVersion = [NSString stringWithFormat:@"%@ (%@)", majorVersion, minorVersion];
    NSLog(@"Checking last app version");
    if(![currentVersion isEqualToString:lastSavedVersion])
    {
        
        // Copy all resources Assets to the Library directory
        NSLog(@"Copy all resources Assets to the Core Data database");
        NSURL *bundleURLBuildIn = [[NSBundle mainBundle] resourceURL];
        NSURL *bundleURLFile = [[NSURL alloc] initFileURLWithPath:[DSData cachesPath]];
        NSURL *path = (local)?bundleURLBuildIn:bundleURLFile;
        NSURL * assetsPath = [path URLByAppendingPathComponent:@"Assets"];
        [CDM.bgObjectContext performBlockAndWait:^{
            [self loadYearsDataFromPath:assetsPath Local:local];
        }];
        NSLog(@"Assets was copied successfully!");
        [shared setObject:currentVersion forKey:@"app.version"];
        [shared synchronize];
    }
    else
    {
        NSLog(@"This app version resources was already copied to the Core Data database");
    }
}

-(void) loadYearsDataFromPath:(NSURL*) yearURL Local:(BOOL) local
{
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
            NSInteger yearNumber = [filename integerValue];
            DSYear* year;
            if([DSYear isWithYear:yearNumber])
            {
                year = [DSYear getByYear:yearNumber];
            }
            else
            {
                year = [[DSYear alloc] initWithEntity:[DSYear getEntity] insertIntoManagedObjectContext:CDM.bgObjectContext];
            }
            year.value = yearNumber;
            
            [self loadMonthsDataForYear:&year fromPath:fileURL Local:local];
        }
    }
    [CDM saveBgContext];
}
    
-(void)loadMonthsDataForYear:(DSYear**)year fromPath:(NSURL*) monthURL Local:(BOOL) local
    {
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
                NSInteger monthNumber = [filename integerValue];
                DSMonth *month;
                if([DSMonth isWithYear:(*year).value month:monthNumber])
                {
                    month = [DSMonth getByYear:(*year).value month:monthNumber];
                }
                else
                {
                    month = [[DSMonth alloc] initWithEntity:[DSMonth getEntity] insertIntoManagedObjectContext:CDM.bgObjectContext];
                }

                month.value = monthNumber;
                month.year = *year;
                [self loadDaysDataForMonth:&month fromPath:fileURL Local:local];
            }
        }
}

-(void)loadDaysDataForMonth:(DSMonth**)month fromPath:(NSURL*) monthURL Local:(BOOL) local
{
    NSURL *filePath=[monthURL URLByAppendingPathComponent:@"c.txt"];
    NSString *fileContents=[NSString stringWithContentsOfURL:filePath encoding:NSUTF8StringEncoding error:nil];
    NSArray *values = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];

    for (NSString *lineStr in values) {
        
        if([lineStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length > 0)
        {
            NSArray *parts = [lineStr componentsSeparatedByString:@"|"];
            NSInteger dayNumber = [[parts objectAtIndex:0] integerValue];
            DSDay *day;
            if([DSDay isWithYear:(*month).year.value month:(*month).value day:dayNumber])
            {
                day = [DSDay getByYear:(*month).year.value month:(*month).value day:dayNumber];
            }
            else
            {
                day = [[DSDay alloc] initWithEntity:[DSDay getEntity] insertIntoManagedObjectContext:CDM.bgObjectContext];
            }
            
            day.value = dayNumber;
            
            day.month = *month;
            
            NSDateComponents *comps = [NSDateComponents new];
            [comps setDay:dayNumber];
            [comps setMonth:(*month).value];
            [comps setYear:(*month).year.value];
            day.date = [[[NSCalendar currentCalendar] dateFromComponents:comps] timeIntervalSince1970];

            day.isHoliday = [[parts objectAtIndex:2] boolValue];
            NSString *holidayTitle;
            NSString *reading;
            NSString *glas;
            if (day.month.year.value < 2018)
            {
                day.fastingType =[[parts objectAtIndex:3] integerValue];
                holidayTitle = [parts objectAtIndex:4];
                reading = [parts objectAtIndex:5];
                glas =[parts objectAtIndex:6];
            }
            else
            {
                day.fastingType =[[parts objectAtIndex:4] integerValue];
                holidayTitle = [parts objectAtIndex:5];
                reading = [parts objectAtIndex:6];
                glas =[parts objectAtIndex:7];
            }
           
            
            holidayTitle = day.isHoliday?[NSString stringWithFormat:@"<font color='#FF0000'>%@</font>", holidayTitle]:holidayTitle;
        
            day.holidayTitle = holidayTitle;
            
            NSString *readingTitle = [[NSString stringWithFormat:@"%@ %@", [glas isEqualToString:@"*"]?@"": glas,  [reading isEqualToString:@"*"]?@"":reading] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            day.readingTitle = readingTitle;
            
            
            NSURL * dayPath = [monthURL URLByAppendingPathComponent:[NSString stringWithFormat:@"u%02d.html", day.value]];
            
            NSString *fileContents=[NSString stringWithContentsOfURL:dayPath encoding:
                                    NSUTF8StringEncoding error:nil];
            day.liturgy = fileContents;
            
            
            dayPath = [monthURL URLByAppendingPathComponent:[NSString stringWithFormat:@"t%02du.html", day.value]];
            
            fileContents=[NSString stringWithContentsOfURL:dayPath encoding:
                          NSUTF8StringEncoding error:nil];
            day.morning = fileContents;
            
            
            dayPath = [monthURL URLByAppendingPathComponent:[NSString stringWithFormat:@"t%02dv.html", day.value]];
            
            fileContents=[NSString stringWithContentsOfURL:dayPath encoding:
                          NSUTF8StringEncoding error:nil];
            day.night = fileContents;
            
            dayPath = [monthURL URLByAppendingPathComponent:[NSString stringWithFormat:@"t%02dc.html", day.value]];
            
            fileContents=[NSString stringWithContentsOfURL:dayPath encoding:
                          NSUTF8StringEncoding error:nil];
            day.hours = fileContents;
            
            
            dayPath = [monthURL URLByAppendingPathComponent:[NSString stringWithFormat:@"b%02d.html", day.value]];
            
            fileContents=[NSString stringWithContentsOfURL:dayPath encoding:
                          NSUTF8StringEncoding error:nil];
            day.readings = fileContents;
            
            dayPath = [monthURL URLByAppendingPathComponent:[NSString stringWithFormat:@"s%02d.html", day.value]];
            
            fileContents=[NSString stringWithContentsOfURL:dayPath encoding:
                          NSUTF8StringEncoding error:nil];
            day.saints = fileContents;
            
            [NSOperationQueue.mainQueue addOperationWithBlock:^(){
                if(!day.holidayTitleAttr)
                {
                    day.holidayTitleAttr = [[NSAttributedString alloc] initWithData:[day.holidayTitle dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
                }
                if(!day.readingTitleAttr)
                {
                    day.readingTitleAttr = [[NSAttributedString alloc] initWithData:[day.readingTitle dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
                }
                
                    [CDM.mainObjectContext performBlock:^{
                    [CDM saveMainContext];
                }];
            }];
        }
    }
}

-(DSDay*)loadResourcesForDay:(DSDay*)day
{
    NSURL *bundleURLBuildIn = [[NSBundle mainBundle] resourceURL];
    

    
    NSURL * documentsPath = [bundleURLBuildIn URLByAppendingPathComponent:@"Assets"];
    NSURL * yearPath = [documentsPath URLByAppendingPathComponent:[NSString stringWithFormat:@"%04d", day.month.year.value]];
    NSURL * monthPath = [yearPath URLByAppendingPathComponent:[NSString stringWithFormat:@"%02d", day.month.value]];
    
    
    NSURL * dayPath = [monthPath URLByAppendingPathComponent:[NSString stringWithFormat:@"u%02d.html", day.value]];
    
    NSString *fileContents=[NSString stringWithContentsOfURL:dayPath encoding:
                            NSUTF8StringEncoding error:nil];
    day.liturgy = fileContents;
    
    
    dayPath = [monthPath URLByAppendingPathComponent:[NSString stringWithFormat:@"t%02du.html", day.value]];
    
    fileContents=[NSString stringWithContentsOfURL:dayPath encoding:
                  NSUTF8StringEncoding error:nil];
    day.morning = fileContents;
    
    
    dayPath = [monthPath URLByAppendingPathComponent:[NSString stringWithFormat:@"t%02dv.html", day.value]];
    
    fileContents=[NSString stringWithContentsOfURL:dayPath encoding:
                  NSUTF8StringEncoding error:nil];
    day.night = fileContents;
    
    dayPath = [monthPath URLByAppendingPathComponent:[NSString stringWithFormat:@"t%02dc.html", day.value]];
    
    fileContents=[NSString stringWithContentsOfURL:dayPath encoding:
                  NSUTF8StringEncoding error:nil];
    day.hours = fileContents;
    
    
    dayPath = [monthPath URLByAppendingPathComponent:[NSString stringWithFormat:@"b%02d.html", day.value]];
    
    fileContents=[NSString stringWithContentsOfURL:dayPath encoding:
                  NSUTF8StringEncoding error:nil];
    day.readings = fileContents;
    
    dayPath = [monthPath URLByAppendingPathComponent:[NSString stringWithFormat:@"s%02d.html", day.value]];
    
    fileContents=[NSString stringWithContentsOfURL:dayPath encoding:
                  NSUTF8StringEncoding error:nil];
    day.saints = fileContents;
    
    return day;
}



@end
