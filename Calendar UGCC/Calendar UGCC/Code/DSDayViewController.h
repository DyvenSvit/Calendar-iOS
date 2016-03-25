//
//  DSDayViewController.h
//  Calendar UGCC
//
//  Created by Max Gontar on 8/15/14.
//  Copyright (c) 2014 DyvenSvit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

#import "DSDay.h"
#import "DSDay+TablePresentation.h"
#import "DSData.h"
#import "UILabel+Resize.h"
#import "UIViewController+Utils.h"
#import "NSDate+Utils.h"

#import "UIViewController+Utils.h"
#import "UIViewController+Dialog.h"
#import "NSAttributedString+FontSize.h"
#import "MBProgressHUD.h"

#import "DSWebAPI.h"

enum DayContentType : NSInteger {
    ContentLiturgy = 0,
    ContentMorningHours = 1,
    ContentNightHours = 2,
    ContentHours = 3,
    ContentReadings = 4,
    ContentHoliday = 5
};


@interface DSDayViewController : GAITrackedViewController <UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *menuView;
@property (strong, nonatomic) IBOutlet UIWebView *webViewText;
@property (strong, nonatomic) DSDay *day;
@property (strong, nonatomic) NSMutableArray *contentModeButtons;
@property (assign, nonatomic) enum DayContentType contentType;

-(void)loadResources;
-(void)updateWithSizeUpFont;
-(void)updateWithSizeDownFont;


@end
