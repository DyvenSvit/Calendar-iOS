//
//  DSViewController.h
//  Calendar UGCC
//
//  Created by Max Gontar on 8/13/14.
//  Copyright (c) 2014 DyvenSvit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSMonth+Presentation.h"
#import "DSData.h"
#import "NSDate+Utils.h"
#import "DSDayTableViewCell.h"
#import "DSDay+TablePresentation.h"
#import "UIViewController+Utils.h"
#import "UIViewController+Dialog.h"
#import "UILabel+Resize.h"
#import "DSDayViewController.h"
#import "ActionSheetYearMonthPicker.h"
#import "DSInfoViewController.h"
#import "MBProgressHUD.h"
#import <Crashlytics/Crashlytics.h>
#import "DSAppDelegate.h"
#import <AFNetworking.h>
#import <UIImageView+AFNetworking.h>
#import <SCLAlertView.h>
#import <Reachability.h>

@interface DSViewController :UIViewController<UITableViewDelegate, UITableViewDataSource> //GAITrackedViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableDays;
@property (assign, nonatomic) NSInteger selectedYear;
@property (assign, nonatomic) NSInteger selectedMonth;
@property (strong, atomic) MBProgressHUD *HUD;
@end
