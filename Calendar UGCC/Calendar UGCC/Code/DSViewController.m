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

@synthesize tableDays, selectedYearIndex, selectedMonthIndex, HUD;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.screenName = @"Day List";
    

    
    UIBarButtonItem *monthItem = [self getBarItemWithImageNamed:@"appbar_calendar_month" action:@selector(monthItemClick:)];
    //UIBarButtonItem *settingsItem = [self getBarItemWithImageNamed:@"appbar_settings" action:@selector(settingsItemClick)];
    UIBarButtonItem *infoItem = [self getBarItemWithImageNamed:@"appbar_information_circle" action:@selector(infoItemClick)];
    UIBarButtonItem *wwwItem = [self getBarItemWithImageNamed:@"appbar_www" action:@selector(wwwItemClick)];
    UIBarButtonItem *fbItem = [self getBarItemWithImageNamed:@"appbar_fb" action:@selector(fbItemClick)];
    NSArray *actionButtonItems = @[infoItem, wwwItem, fbItem, monthItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;


    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataLoadingBegin:) name:NT_DATA_LOADING_BEGIN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataLoadingEnd:) name:NT_DATA_LOADING_END object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataLoadingProgress:) name:NT_DATA_LOADING_PROGRESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataLoadingError:) name:NT_DATA_LOADING_ERROR object:nil];
    
    [APP.backgroundQueue addOperationWithBlock:^(){
        [APP startManageData];
    }];
}


- (void) dataLoadingBegin:(NSNotification *) notification
{
    [NSOperationQueue.mainQueue addOperationWithBlock:^(){
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"Loading";
    HUD.detailsLabelText = @"Looking for data update";
        
    }];
}

- (void) dataLoadingEnd:(NSNotification *) notification
{
    [NSOperationQueue.mainQueue addOperationWithBlock:^(){
        
        tableDays.delegate = self;
        tableDays.dataSource = self;
        
        NSString *currentYearString = [NSString stringWithFormat:@"%ld", (long)[NSDate getCurrentYearNumber]];
        selectedYearIndex = [[[DSData shared] yearNames] indexOfObject:currentYearString];
       
        selectedMonthIndex = [NSDate getCurrentMonthNumber]-1;
        
        self.navigationItem.title = [NSString stringWithFormat:@"%@ (%@)",  [[[DSData shared] monthNames] objectAtIndex: selectedMonthIndex], [[[DSData shared] yearNames] objectAtIndex:selectedYearIndex]];
        
        if(HUD)
        {
            [HUD removeFromSuperview];
            HUD = nil;
        }
    }];
    
    [APP.backgroundQueue addOperationWithBlock:^(){
        [self prepareAttributedTexts];
    }];
}

- (void) dataLoadingProgress:(NSNotification *) notification
{
    [NSOperationQueue.mainQueue addOperationWithBlock:^(){
        HUD.labelText =notification.userInfo[@"status"];
        HUD.progress = [(NSNumber*)notification.userInfo[@"progress"] floatValue];
    }];
    

}

- (void) dataLoadingError:(NSNotification *) notification
{
    
    [NSOperationQueue.mainQueue addOperationWithBlock:^(){
       // NSError * error  = notification.userInfo[@"error"];
        if(HUD)
        {
            [HUD removeFromSuperview];
            HUD = nil;
        }
        
        [self showAlert:@"Error" message:@"Під час оновлення календаря сталася помилка"];
    }];
    

    
    [APP.backgroundQueue addOperationWithBlock:^(){
        [self prepareAttributedTexts];
    }];
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
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"UI"
                                                                                        action:@"Select Year Month click"
                                                                                         label:nil
                                                                                         value:nil] build]];
    
    [ActionSheetYearMonthPicker showPickerWithSelectedYear:selectedYearIndex month:selectedMonthIndex doneBlock:^(ActionSheetYearMonthPicker *picker, NSInteger selectedYIndex, NSInteger selectedMIndex) {
        [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"UI"
                                                                                            action:[NSString stringWithFormat:@"Select Year: %ld Month: %ld", (long)selectedYIndex,  (long)selectedMIndex]
                                                                                             label:nil
                                                                                             value:nil] build]];
        
        selectedYearIndex = selectedYIndex;
        selectedMonthIndex = selectedMIndex;
        self.navigationItem.title = [NSString stringWithFormat:@"%@ (%@)",  [[[DSData shared] monthNames] objectAtIndex: selectedMonthIndex], [[[DSData shared] yearNames] objectAtIndex:selectedYearIndex]];
        [APP.backgroundQueue addOperationWithBlock:^(){
            [self prepareAttributedTexts];
        }];
    }
                                        cancelBlock:^(ActionSheetYearMonthPicker *picker) {
                                            [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"UI"
                                                                                                                                action:@"Select Year Month cancel"
                                                                                                                                 label:nil
                                                                                                                                 value:nil] build]];
                                        } origin:sender];
}

-(void)settingsItemClick{
    
    
}

-(void)fbItemClick{
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"UI"
                                                                                        action:@"FB click"
                                                                                         label:nil
                                                                                         value:nil] build]];
    
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/groups/ugcc.calendar/"]];
    

}

-(void)wwwItemClick{
    
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"UI"
                                                                                        action:@"WWW click"
                                                                                         label:nil
                                                                                         value:nil] build]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://calendar.dyvensvit.org"]];
}


-(void)infoItemClick{
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"UI"
                                                                                        action:@"Info click"
                                                                                         label:nil
                                                                                         value:nil] build]];
    
    DSInfoViewController *navController = [[self storyboard] instantiateViewControllerWithIdentifier:@"DSInfoViewController"];
    [self.navigationController pushViewController:navController animated:YES];
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
    result = ((DSMonth*)((DSYear*) [DSData shared].years[selectedYearIndex]).months[selectedMonthIndex]).days.count;
    return result;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == tableDays)
    {
        DSDayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDSDayTableViewCell];
        DSDay *day = [((DSMonth*)((DSYear*) [DSData shared].years[selectedYearIndex]).months[selectedMonthIndex]).days objectAtIndex:indexPath.row];
        
        cell.imgFasting.image = [day getFastimgImage];
        cell.lbOldStyleDate.text = [day getOldStyleDateString];
        cell.lbDate.text = [day getDateString];
        cell.lbDayOfWeek.text = [day getWeekDayString];
        cell.lbTitle.attributedText = day.holidayTitle;
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) { //*
            [cell.lbTitle setAdjustsFontSizeToFitWidth:NO];
        }
        cell.viewDate.alpha =  [day getDayBgAlpha];
        cell.viewInfo.alpha = [day getDayBgAlpha];
        
        cell.lbReading.attributedText = day.readingTitle;
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
        if([[NSDate new] getMonthNumber]-1 == selectedMonthIndex)
        {
            NSInteger dn = [[NSDate new] getDayNumber]-1;
            NSIndexPath *scrollToPath = [NSIndexPath indexPathForRow:dn  inSection:0];
            [tableDays scrollToRowAtIndexPath:scrollToPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        else
        {
            NSIndexPath *scrollToPath = [NSIndexPath indexPathForRow:0  inSection:0];
            [tableDays scrollToRowAtIndexPath:scrollToPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == tableDays)
    {
        
        
        [NSOperationQueue.mainQueue addOperationWithBlock:^(){
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        }];
        
        
        
        DSDay *day = [((DSMonth*)((DSYear*) [DSData shared].years[selectedYearIndex]).months[selectedMonthIndex]).days objectAtIndex:indexPath.row];
        
        [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"UI"
                                                                                            action:[NSString stringWithFormat: @"Day click: %@", ([[day date] isToday])?@"Today":[[day date] toString]]
                                                                                             label:nil
                                                                                             value:nil] build]];
        
        
        DSDayViewController *navController = [[self storyboard] instantiateViewControllerWithIdentifier:@"DSDayViewController"];

        [APP.backgroundQueue addOperationWithBlock:^(){
            navController.day = day;
            [navController loadResources];
            
            [NSOperationQueue.mainQueue addOperationWithBlock:^(){
                [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
                [self.navigationController pushViewController:navController animated:YES];
            }];
        }];
        
    }
}


@end
