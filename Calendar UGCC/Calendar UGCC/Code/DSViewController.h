//
//  DSViewController.h
//  Calendar UGCC
//
//  Created by Max Gontar on 8/13/14.
//  Copyright (c) 2014 DyvenSvit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSData.h"
#import "NSDate+Utils.h"
#import "DSDayTableViewCell.h"
#import "DSDay+TablePresentation.h"
#import "UIViewController+Utils.h"
#import "UIViewController+Dialog.h"
#import "NSAttributedString+HTML.h"
#import "UILabel+Resize.h"
#import "DSDayViewController.h"
#import "ActionSheetYearMonthPicker.h"
#import "DSInfoViewController.h"
#import "MBProgressHUD.h"
#import <Reachability.h>
#import <Crashlytics/Crashlytics.h>
#import "DSAppDelegate.h"

@interface DSViewController : GAITrackedViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableDays;
@property (assign, nonatomic) NSInteger selectedYearIndex;
@property (assign, nonatomic) NSInteger selectedMonthIndex;
@property (strong, atomic) MBProgressHUD *HUD;
@end
