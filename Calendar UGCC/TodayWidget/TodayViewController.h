//
//  TodayViewController.h
//  TodayWidget
//
//  Created by Admin on 10/21/14.
//  Copyright (c) 2014 DyvenSvit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSData.h"
#import "DSDay+CD.h"
#import "NSDate+Utils.h"
#import "DSDay+TablePresentation.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@interface TodayViewController : GAITrackedViewController

@property (strong, nonatomic) IBOutlet UIView *viewBackground;
@property (strong, nonatomic) IBOutlet UIView *viewDate;
@property (strong, nonatomic) IBOutlet UIView *viewInfo;
@property (strong, nonatomic) IBOutlet UILabel *lbTitle;
@property (strong, nonatomic) IBOutlet UILabel *lbReading;
@property (strong, nonatomic) IBOutlet UIImageView *imgFasting;
@property (strong, nonatomic) IBOutlet UILabel *lbOldStyleDate;
@property (strong, nonatomic) IBOutlet UILabel *lbDate;
@property (strong, nonatomic) IBOutlet UILabel *lbDayOfWeek;

@property (weak, nonatomic) IBOutlet UIButton *btnOpenApp;

@end
