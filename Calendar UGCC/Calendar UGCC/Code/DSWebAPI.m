//
//  DSWebAPI.m
//  CalendarUGCC
//
//  Created by Developer on 3/24/16.
//  Copyright © 2016 DyvenSvit. All rights reserved.
//

#import "DSWebAPI.h"

@implementation DSWebAPI


+ (void)getYear:(NSInteger) year month:(NSInteger) month day:(NSInteger) day withCompletionBlock:(void (^)(DSDay* day, NSError *error))complete{
    NSString* url = [NSString stringWithFormat:@"http://api.dyvensvit.org/DSCalendarAPI/DSCalendarDataService/%d/%02d/%02d", (int)year, (int)month, (int)day];
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSDictionary * jsonDictionary = (NSDictionary *)responseObject;
        
        if(jsonDictionary[@"dsDayFull"])
        {
            __block DSDay* result = nil;
            [CDM.bgObjectContext performBlockAndWait:^{
                result = [DSDay fromDictionary:jsonDictionary[@"dsDayFull"]];
            }];
            complete(result, nil);
        }
        else
        {
            complete(nil, [NSError errorWithDomain:@"" code:0 userInfo:@{@"":@""}]);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        complete(nil, error);
    }];
}
@end
