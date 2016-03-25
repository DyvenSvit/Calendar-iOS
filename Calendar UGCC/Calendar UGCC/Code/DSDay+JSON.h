//
//  DSDay+JSON.h
//  CalendarUGCC
//
//  Created by Developer on 3/25/16.
//  Copyright © 2016 DyvenSvit. All rights reserved.
//

#import "DSDay+CD.h"
#import "DSMonth+CD.h"
#import "DSYear+CD.h"

@interface DSDay (JSON)

+(DSDay*) fromDictionary:(NSDictionary*) dic;

@end
