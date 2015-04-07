//
//  DSDayContentViewController.h
//  Calendar UGCC
//
//  Created by Max Gontar on 8/20/14.
//  Copyright (c) 2014 DyvenSvit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "UILabel+Resize.h"
#import "DSDay.h"
#import "NSAttributedString+HTML.h"
#import "UIViewController+Utils.h"
#import "UIViewController+Dialog.h"
#import "NSAttributedString+FontSize.h"
#import "MBProgressHUD.h"

enum DayContentType : NSInteger {
    ContentLiturgy = 0,
    ContentMorningHours = 1,
    ContentNightHours = 2,
    ContentHours = 3,
    ContentReadings = 4,
    ContentHoliday = 5
};


@interface DSDayContentViewController : GAITrackedViewController <UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIWebView *webViewText;
@property (strong, nonatomic) DSDay *day;
@property (assign, nonatomic) enum DayContentType contentType;

@property (strong, nonatomic) IBOutlet UITabBarItem *btiHour;
@property (strong, nonatomic) IBOutlet UITabBarItem *tbiNightHours;
@property (strong, nonatomic) IBOutlet UITabBarItem *tbiMorningHours;
@property (strong, nonatomic) IBOutlet UITabBarItem *tbiHoliday;
@property (strong, nonatomic) IBOutlet UITabBarItem *tbiReadings;

-(void)updateWithSizeUpFont;
-(void)updateWithSizeDownFont;
@end
