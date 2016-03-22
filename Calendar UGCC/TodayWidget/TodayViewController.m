//
//  TodayViewController.m
//  TodayWidget
//
//  Created by Admin on 10/21/14.
//  Copyright (c) 2014 DyvenSvit. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController
@synthesize viewBackground, viewDate, viewInfo, lbDate, lbDayOfWeek, lbOldStyleDate, lbReading, lbTitle, imgFasting, btnOpenApp;

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
       
        [Fabric with:@[[Crashlytics class]]];
        
        // Optional: automatically send uncaught exceptions to Google Analytics.
        [GAI sharedInstance].trackUncaughtExceptions = YES;
        
        // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
        [GAI sharedInstance].dispatchInterval = 120;
        
        // Optional: set Logger to VERBOSE for debug information.
        [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
        
        // Initialize tracker. Replace with your tracking ID.
        [[GAI sharedInstance] trackerWithTrackingId:@"UA-56294253-1"];
        
        NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
        [[GAI sharedInstance].defaultTracker set:kGAIAppVersion value:version];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenName = @"Календар УГКЦ";
    [DSData sharedWithLocal:YES];
    [btnOpenApp addTarget:self action:@selector(openAppClick) forControlEvents:UIControlEventTouchUpInside];
    [self updateData];
}


-(void)updateData
{
    [DSData shared];
    
    DSDay* day = [DSDay getByYear:[NSDate getCurrentYearNumber] month:[NSDate getCurrentMonthNumber] day:[NSDate getCurrentDayNumber]];

    imgFasting.image = [day getFastimgImage];
    lbOldStyleDate.text = [day getOldStyleDateString];
    lbDate.text = [day getDateString];
    lbDayOfWeek.text = [day getWeekDayString];
    
    lbTitle.attributedText = [[NSAttributedString alloc] initWithData:[day.holidayTitle dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    
    viewDate.alpha =  [day getDayBgAlpha];
    viewInfo.alpha = [day getDayBgAlpha];
    
    
   lbReading.attributedText = [[NSAttributedString alloc] initWithData:[day.readingTitle dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    
    viewBackground.backgroundColor = [day getDayMainBgColor];
}

-(void)openAppClick
{
    id tracker = [[GAI sharedInstance] defaultTracker];

    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"UI"     // Event category (required)
                                                          action:@"Today Widget touch"  // Event action (required)
                                                           label:nil
                                                           value:nil] build]];    // Event value

    
    
    NSURL *url = [NSURL URLWithString:@"dscal://"];
    [self.extensionContext openURL:url completionHandler:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

-(UIEdgeInsets) widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

@end
