//
//  DSInfoViewController.h
//  Calendar UGCC
//
//  Created by Max Gontar on 9/17/14.
//  Copyright (c) 2014 DyvenSvit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import <Crashlytics/Crashlytics.h>

@interface DSInfoViewController : UIViewController <UIWebViewDelegate> //GAITrackedViewController <UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *mWebView;
@end
