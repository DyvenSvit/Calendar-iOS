//
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

    NSURL *bundleURLBuildIn = [[NSBundle mainBundle] resourceURL];
    
    NSURL *bundleURLFile = [[NSURL alloc] initFileURLWithPath:[DSData cachesPath]];
    
    NSURL *path = (local)?bundleURLBuildIn:bundleURLFile;
    
    NSURL * assetsPath = [path URLByAppendingPathComponent:@"Assets"];
    
    [self loadYearsDataFromPath:assetsPath Local:local];

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
                year = [[DSYear alloc] initWithEntity:[DSYear getEntity] insertIntoManagedObjectContext:CDM.managedObjectContext];
            }
            year.value = yearNumber;
            
            [self loadMonthsDataForYear:&year fromPath:fileURL Local:local];
        }
    }
    [CDM saveContext];
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
                    month = [[DSMonth alloc] initWithEntity:[DSMonth getEntity] insertIntoManagedObjectContext:CDM.managedObjectContext];
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
                day = [[DSDay alloc] initWithEntity:[DSDay getEntity] insertIntoManagedObjectContext:CDM.managedObjectContext];
            }
            
            day.value = dayNumber;
            
            day.month = *month;
            
            NSDateComponents *comps = [NSDateComponents new];
            [comps setDay:dayNumber];
            [comps setMonth:(*month).value];
            [comps setYear:(*month).year.value];
            day.date = [[[NSCalendar currentCalendar] dateFromComponents:comps] timeIntervalSince1970];

            day.isHoliday = [[parts objectAtIndex:2] boolValue];
            day.fastingType =[[parts objectAtIndex:3] integerValue];
            
            NSString *holidayTitle = [parts objectAtIndex:4];
            
            holidayTitle = day.isHoliday?[NSString stringWithFormat:@"<font color='#FF0000'>%@</font>", holidayTitle]:holidayTitle;
        
            day.holidayTitle = holidayTitle;
            
            /*
            if(local)
            {
                day.holidayTitleAttr = [[NSAttributedString alloc] initWithString:holidayTitle];
            }
            else
            {
                day.holidayTitleAttr = [[NSAttributedString alloc] initWithData:[holidayTitle dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
            }
            */
            
            NSString *reading = [parts objectAtIndex:5];
            NSString *glas =[parts objectAtIndex:6];
            NSString *readingTitle = [[NSString stringWithFormat:@"%@ %@", [glas isEqualToString:@"*"]?@"": glas,  [reading isEqualToString:@"*"]?@"":reading] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            day.readingTitle = readingTitle;
            
           /* if(local)
            {
                day.readingTitleAttr = [[NSAttributedString alloc] initWithString:readingTitle];
            }
            else
            {
                day.readingTitleAttr = [[NSAttributedString alloc] initWithData:[readingTitle dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
            }
            */
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
