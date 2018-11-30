//
//  DSViewController.m
//  Calendar UGCC
//
//  Created by Max Gontar on 8/13/14.
//  Copyright (c) 2014 DyvenSvit. All rights reserved.
//

#import "DSViewController.h"

@implementation DSViewController

static NSString *const kDSDayTableViewCell = @"DSDayTableViewCell";

@synthesize tableDays, selectedYear, selectedMonth, HUD, attributedTextArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //self.screenName = @"Day List";
    

    
    UIBarButtonItem *monthItem = [self getBarItemWithImageNamed:@"appbar_calendar_month" action:@selector(monthItemClick:)];
    //UIBarButtonItem *settingsItem = [self getBarItemWithImageNamed:@"appbar_settings" action:@selector(settingsItemClick)];
    UIBarButtonItem *infoItem = [self getBarItemWithImageNamed:@"appbar_information_circle" action:@selector(infoItemClick)];
    UIBarButtonItem *prayerItem = [self getBarItemWithImageNamed:@"appbar.prayer" action:@selector(prayerItemClick)];
    UIBarButtonItem *wwwItem = [self getBarItemWithImageNamed:@"appbar_www" action:@selector(wwwItemClick)];
    UIBarButtonItem *fbItem = [self getBarItemWithImageNamed:@"appbar_fb" action:@selector(fbItemClick)];
    self.navigationItem.rightBarButtonItems = @[infoItem, monthItem];
    self.navigationItem.leftBarButtonItems = @[wwwItem, fbItem, prayerItem];
    tableDays.delegate = self;
    tableDays.dataSource = self;
    
    selectedYear = [NSDate getCurrentYearNumber];
    
    selectedMonth = [NSDate getCurrentMonthNumber];
    
    attributedTextArray = [[NSMutableArray alloc] init];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"оновлення даних";
    [APP.backgroundQueue addOperationWithBlock:^(){
        
        [DSData shared];
        
        [NSOperationQueue.mainQueue addOperationWithBlock:^(){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.navigationItem.title = [[DSMonth getByYear:selectedYear month:selectedMonth] getTitleString];
            //[tableDays reloadData];
            [self prepareAttributedTexts];
            //[self presentAnnouncement];
            /*
            BOOL dontShow = [[NSUserDefaults standardUserDefaults] boolForKey:@"1.9.1-Announce-Off"];
            if(!dontShow)
            {
                SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
                alert.hideAnimationType = SCLAlertViewHideAnimationSlideOutToBottom;
                alert.showAnimationType =  SCLAlertViewShowAnimationSlideInFromTop;
                alert.backgroundType = SCLAlertViewBackgroundBlur;
                alert.customViewColor = [UIColor colorWithHexString:@"008000"];
                alert.iconTintColor = [UIColor whiteColor];

                NSString* subTitle = nil;
                
                if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
                {
                    subTitle = @"ДивенСвіт потребує Вашої допомоги! Потрібно терміново придбати комп'ютер для розробника сайту та Android-версії додатку!\nНеобхідна сума 23 333 грн\nКартка 4731 1856 0341 0116";
                }
                else
                {
                    UIImageView *img1 = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 215.0f, 143.0f)];
                    NSURL *imgUrl1 = [NSURL URLWithString:@"https://i2.wp.com/dyvensvit.org/wp-content/uploads/2017/06/comp-300x200.jpg"];
                    [img1 setImageWithURL:imgUrl1];
                    [img1 setContentMode:UIViewContentModeScaleAspectFit];
                    [alert addCustomView:img1];

                    UIImageView *img3 = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 215.0f, 38.0f)];
                    NSURL *imgUrl3 = [NSURL URLWithString:@"http://dyvensvit.org/wp-content/plugins/olimometer/thermometer.php?olimometer_id=1"];
                    [img3 setImageWithURL:imgUrl3];
                    [img3 setContentMode:UIViewContentModeScaleAspectFit];
                    [alert addCustomView:img3];
                }
                
                SCLSwitchView *switchView = [alert addSwitchViewWithLabel:@"більше не турбувати".uppercaseString];
                switchView.tintColor = [UIColor redColor];
                
                [alert addButton:@"Пожертва через LiqPay" actionBlock:^(void) {
                    [Answers logCustomEventWithName:@"Online payment" customAttributes:@{@"From":@"Info screen",@"Campaign":@"2017-DS-Computer"}];
                    UIApplication *application = [UIApplication sharedApplication];
                    NSURL *URL = [NSURL URLWithString:@"https://www.liqpay.com/uk/checkout/card/dyvensvit"];
                    if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                        [application openURL:URL options:@{}
                           completionHandler:^(BOOL success) {
                               if(success)
                               {
                                   NSLog(@"Opened URL: %@",URL.description);
                               }
                               else
                               {
                                   NSLog(@"Failed to open URL: %@",URL.description);
                               }
                           }];
                    } else {
                        BOOL success = [application openURL:URL];
                        if(success)
                        {
                            NSLog(@"Opened URL: %@",URL.description);
                        }
                        else
                        {
                            NSLog(@"Failed to open URL: %@",URL.description);
                        }
                    }
                }];
                
                [alert addButton:@"Закрити" actionBlock:^(void) {
                    NSLog(@"Show again? %@", switchView.isSelected ? @"-No": @"-Yes");
                    
                    if(switchView.isSelected)
                    {
                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"1.9.1-Announce-Off"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        [Answers logCustomEventWithName:@"Announcement don't show" customAttributes:@{@"From":@"Info screen",@"Campaign":@"2017-DS-Computer"}];
                    }
                    else
                    {
                        [Answers logCustomEventWithName:@"Announcement close" customAttributes:@{@"From":@"Info screen",@"Campaign":@"2017-DS-Computer"}];
                    }
                }];
                
                [alert showCustom:[UIApplication sharedApplication].keyWindow.rootViewController image:[UIImage imageNamed:@"calendar"] color:[UIColor brownColor] title:@"Оголошення" subTitle:subTitle closeButtonTitle:nil duration:0.0f];
                                
                
                [Answers logContentViewWithName:@"Announcement view" contentType:@"Announcement" contentId:@"announce-2.0.0" customAttributes:@{@"From":@"Home screen",@"Campaign":@"2017-DS-Computer"}];
            }
         */
        }];
    }];
}

-(void) presentAnnouncement
{
    BOOL dontShow = [[NSUserDefaults standardUserDefaults] boolForKey:@"1.9.8-Announce-Off"];
    if(!dontShow)
    {
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus] != NotReachable)
    {
        int width = [[UIScreen mainScreen] bounds].size.width*0.9 ;//- 105;
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindowWidth:width];
        alert.hideAnimationType = SCLAlertViewHideAnimationSlideOutToBottom;
        alert.showAnimationType =  SCLAlertViewShowAnimationSlideInFromTop;
        alert.backgroundType = SCLAlertViewBackgroundBlur;
        alert.customViewColor = [UIColor colorWithHexString:@"008000"];
        alert.iconTintColor = [UIColor whiteColor];
        
        [alert addButton:@"Пройти опитування" actionBlock:^(void) {
            [Answers logCustomEventWithName:@"Poll opened" customAttributes:@{@"From":@"Info screen",@"Campaign":@"2017-Community-Poll"}];
            UIApplication *application = [UIApplication sharedApplication];
            NSURL *URL = [NSURL URLWithString:@"https://docs.google.com/forms/d/e/1FAIpQLSfC-SNM8W3GvnOoLkrTEXS1jWXwf3rp_lt1RzTzafV0gTGqHQ/viewform"];
            if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                [application openURL:URL options:@{}
                   completionHandler:^(BOOL success) {
                       if(success)
                       {
                           NSLog(@"Opened URL: %@",URL.description);
                           [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"1.9.8-Announce-Off"];
                           [[NSUserDefaults standardUserDefaults] synchronize];
                       }
                       else
                       {
                           NSLog(@"Failed to open URL: %@",URL.description);
                       }
                   }];
            } else {
                BOOL success = [application openURL:URL];
                if(success)
                {
                    NSLog(@"Opened URL: %@",URL.description);
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"1.9.8-Announce-Off"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                else
                {
                    NSLog(@"Failed to open URL: %@",URL.description);
                }
            }
        }];
        
        [alert addButton:@"Не зараз" actionBlock:^(void) {
            [Answers logCustomEventWithName:@"Announcement close" customAttributes:@{@"From":@"Info screen",@"Campaign":@"2017-Community-Poll"}];
        }];
        
        [alert addButton:@"Більше не турбувати" actionBlock:^(void) {
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"1.9.8-Announce-Off"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [Answers logCustomEventWithName:@"Announcement don't show" customAttributes:@{@"From":@"Info screen",@"Campaign":@"2017-Community-Poll"}];
        }];
        
        [alert showCustom:[UIApplication sharedApplication].keyWindow.rootViewController  image:[UIImage imageNamed:@"community"] color:[UIColor brownColor] title:@"Оголошення" subTitle:@"Слава Ісусу Христу! Допоможіть Церкві, присвятивши 5 хв свого часу: пройдіть опитування, яке стосується нашого нового проекту: Довідника спільнот УГКЦ. Дякуємо Вам." closeButtonTitle:nil duration:0.0f];

        [Answers logContentViewWithName:@"Announcement view" contentType:@"Announcement" contentId:@"announce-1.9.8" customAttributes:@{@"From":@"Home screen",@"Campaign":@"2017-Community-Poll"}];
    }
    }
}

-(UIBarButtonItem*) getBarItemWithImageNamed:(NSString*) imgName action:(SEL) action
{
    UIImage *img = [UIImage imageNamed:imgName];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:img forState:UIControlStateNormal];
    btn.showsTouchWhenHighlighted = YES;
    btn.frame = CGRectMake(0.0, 0.0, img.size.width, img.size.height);
    
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *bi = [[UIBarButtonItem alloc]
                           initWithCustomView:btn];
    
    return bi;
}

-(void)monthItemClick:(id)sender
{
    /*
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"UI"
                                                                                        action:@"Select Year Month click"
                                                                                         label:nil
                                                                                         value:nil] build]];
    */
    [ActionSheetYearMonthPicker showPickerWithSelectedYear:selectedYear month:selectedMonth doneBlock:^(ActionSheetYearMonthPicker *picker, NSInteger selectedYearValue, NSInteger selectedMonthValue) {
        /*
        [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"UI"
                                                                                            action:[NSString stringWithFormat:@"Select Year: %ld Month: %ld", (long)selectedYearValue,  (long)selectedMonthValue]
                                                                                             label:nil
                                                                                             value:nil] build]];
        */
        selectedYear = selectedYearValue;
        selectedMonth = selectedMonthValue;
        self.navigationItem.title = [[DSMonth getByYear:selectedYear month:selectedMonth] getTitleString];
        
        [APP.backgroundQueue addOperationWithBlock:^(){
            if([DSMonth getByYear:selectedYear month:selectedMonth].days.count > 0)
                [self prepareAttributedTexts];
        
        }];
    }
                                        cancelBlock:^(ActionSheetYearMonthPicker *picker) {
                                            /*
                                            [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"UI"
                                                                                                                                action:@"Select Year Month cancel"
                                                                                                                                 label:nil
                                                                                                                                 value:nil] build]];
                                             */
                                        } origin:sender];
}

-(void)settingsItemClick{
    
    
}

-(void)fbItemClick{
    /*
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"UI"
                                                                                        action:@"FB click"
                                                                                         label:nil
                                                                                         value:nil] build]];
    
    */
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/groups/ugcc.calendar/"]];
    

}

-(void)wwwItemClick{
    /*
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"UI"
                                                                                        action:@"WWW click"
                                                                                         label:nil
                                                                                         value:nil] build]];
     */
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://calendar.dyvensvit.org"]];
}


-(void)infoItemClick{
    /*
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"UI"
                                                                                        action:@"Info click"
                                                                                         label:nil
                                                                                         value:nil] build]];
    */
    DSInfoViewController *navController = [[self storyboard] instantiateViewControllerWithIdentifier:@"DSInfoViewController"];
    [self.navigationController pushViewController:navController animated:YES];
}

-(void)prayerItemClick{
    NSString *customURL = @"praycatholic://";
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:customURL];
    if ([application canOpenURL:URL])
    {
        [application openURL:URL options:@{}
           completionHandler:^(BOOL success) {
               NSLog(@"Open %@: %d",customURL,success);
           }];
    }
    else {
        NSURL *urlToAppStore = [NSURL URLWithString:@"https://itunes.apple.com/us/app/catholic-prayer-molitovnik/id1087833268?mt=8"];
        [application openURL:urlToAppStore options:@{}
           completionHandler:^(BOOL success) {
               NSLog(@"Open %@: %d",customURL,success);
           }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger result = 0;
    result = [DSMonth getByYear:selectedYear month:selectedMonth].days.count;
    return result;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == tableDays)
    {
        DSDayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDSDayTableViewCell];
        DSDay *day = [[DSMonth getByYear:selectedYear month:selectedMonth].days objectAtIndex:indexPath.row];
        
        cell.imgFasting.image = [day getFastingImage];
        cell.lbOldStyleDate.text = [day getOldStyleDateString];
        cell.lbDate.text = [day getDateString];
        cell.lbDayOfWeek.text = [day getWeekDayString];

        /*
        if(!day.holidayTitleAttr)
        {
            day.holidayTitleAttr = [[NSAttributedString alloc] initWithData:[day.holidayTitle dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        }
        if(!day.readingTitleAttr)
        {
            day.readingTitleAttr = [[NSAttributedString alloc] initWithData:[day.readingTitle dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        }

        [CDM.mainObjectContext performBlock:^{
            [CDM saveMainContext];
            [CDM.bgObjectContext performBlock:^{
                [CDM saveBgContext];
            }];
        }];
        */
        
        
        cell.lbTitle.attributedText = [[NSAttributedString alloc] initWithData:[day.holidayTitle dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        cell.viewDate.alpha =  [day getDayBgAlpha];
        cell.viewInfo.alpha = [day getDayBgAlpha];
        cell.lbReading.attributedText = [[NSAttributedString alloc] initWithData:[day.readingTitle dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        
        cell.viewBackground.backgroundColor = [day getDayMainBgColor];
        return cell;
    }
    return nil;
}


-(void)prepareAttributedTexts
{
    [NSOperationQueue.mainQueue addOperationWithBlock:^(){
        
        [tableDays reloadData];
        [tableDays layoutIfNeeded];
        NSIndexPath *scrollToPath;
        if([[NSDate new] getMonthNumber] == selectedMonth)
        {
            NSInteger dn = [[NSDate new] getDayNumber]-1;
            scrollToPath = [NSIndexPath indexPathForRow:dn  inSection:0];
        }
        else
        {
            scrollToPath = [NSIndexPath indexPathForRow:0  inSection:0];
        }
        
        if([self indexPathIsValid:scrollToPath])
        {
            [tableDays scrollToRowAtIndexPath:scrollToPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

-(BOOL) indexPathIsValid:(NSIndexPath*) indexPath
{
    if(indexPath.section >= tableDays.numberOfSections)
    {
        return NO;
    }
    else if (indexPath.row >= [tableDays numberOfRowsInSection:indexPath.section])
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == tableDays)
    {
        
        
        [NSOperationQueue.mainQueue addOperationWithBlock:^(){
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        }];
        
        
        
        DSDay *day = [[DSMonth getByYear:selectedYear month:selectedMonth].days objectAtIndex:indexPath.row];
        /*
        [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"UI"
                                                                                            action:[NSString stringWithFormat: @"Day click: %@", ([[day getDate] isToday])?@"Today":[[day getDate] toString]]
                                                                                             label:nil
                                                                                             value:nil] build]];
        */
        
        DSDayViewController *navController = [[self storyboard] instantiateViewControllerWithIdentifier:@"DSDayViewController"];
        navController.day = day;
        [NSOperationQueue.mainQueue addOperationWithBlock:^(){
            [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
            
        }];
        [self.navigationController pushViewController:navController animated:YES];
        
    }
}


@end
