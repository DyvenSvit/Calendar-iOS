//
//  DSDayViewController.h
//  Calendar UGCC
//
//  Created by Max Gontar on 8/15/14.
//  Copyright (c) 2014 DyvenSvit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import "DSDay.h"
#import "DSData.h"
#import "DSDayContentViewController.h"
#import "UILabel+Resize.h"
#import "UIViewController+Utils.h"
#import "NSDate+Utils.h"

@interface DSDayViewController : UITabBarController

@property (strong, atomic) DSDay *day;
-(void)loadResources;
@end
