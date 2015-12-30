//
//  DSAppDelegate.h
//  Calendar UGCC
//
//  Created by Max Gontar on 8/13/14.
//  Copyright (c) 2014 DyvenSvit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Utils.h"
#import "DSDayViewController.h"
#import "DSData.h"
#import "DSDay.h"
#import "NSDate+Utils.h"
#import "DSManageData.h"
#import "Reachability.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>


@interface DSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSOperationQueue *backgroundQueue;
@property (strong, atomic) Reachability *reach;
@property (assign, nonatomic) BOOL isDataLoading;
@property (assign, nonatomic) BOOL isDataLoaded;
@property (strong, atomic) DSManageData *manageDataObj;
-(void)startManageData;
@end
