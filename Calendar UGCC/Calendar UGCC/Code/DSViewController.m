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

@synthesize tableDays, selectedYear, selectedMonth, HUD;

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
    
    tableDays.delegate = self;
    tableDays.dataSource = self;
    
    selectedYear = [NSDate getCurrentYearNumber];
    
    selectedMonth = [NSDate getCurrentMonthNumber];
    

    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [APP.backgroundQueue addOperationWithBlock:^(){
        
        [DSData shared];
        
        [NSOperationQueue.mainQueue addOperationWithBlock:^(){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.navigationItem.title = [[DSMonth getByYear:selectedYear month:selectedMonth] getTitleString];
            [tableDays reloadData];
        }];
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
    
    [ActionSheetYearMonthPicker showPickerWithSelectedYear:selectedYear month:selectedMonth doneBlock:^(ActionSheetYearMonthPicker *picker, NSInteger selectedYearValue, NSInteger selectedMonthValue) {
        [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"UI"
                                                                                            action:[NSString stringWithFormat:@"Select Year: %ld Month: %ld", (long)selectedYearValue,  (long)selectedMonthValue]
                                                                                             label:nil
                                                                                             value:nil] build]];
        
        selectedYear = selectedYearValue;
        selectedMonth = selectedMonthValue;
        self.navigationItem.title = [[DSMonth getByYear:selectedYear month:selectedMonth] getTitleString];
        
        [APP.backgroundQueue addOperationWithBlock:^(){
            if([DSMonth getByYear:selectedYear month:selectedMonth].days.count > 0)
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
    result = [DSMonth getByYear:selectedYear month:selectedMonth].days.count;
    return result;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == tableDays)
    {
        DSDayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDSDayTableViewCell];
        DSDay *day = [[DSMonth getByYear:selectedYear month:selectedMonth].days objectAtIndex:indexPath.row];
        
        cell.imgFasting.image = [day getFastimgImage];
        cell.lbOldStyleDate.text = [day getOldStyleDateString];
        cell.lbDate.text = [day getDateString];
        cell.lbDayOfWeek.text = [day getWeekDayString];

        if(!day.holidayTitleAttr)
            day.holidayTitleAttr = [[NSAttributedString alloc] initWithData:[day.holidayTitle dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        if(!day.readingTitleAttr)
            day.readingTitleAttr = [[NSAttributedString alloc] initWithData:[day.readingTitle dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        [CDM saveMainContext];
        
        cell.lbTitle.attributedText = day.holidayTitleAttr;
        cell.viewDate.alpha =  [day getDayBgAlpha];
        cell.viewInfo.alpha = [day getDayBgAlpha];
        cell.lbReading.attributedText = day.readingTitleAttr;
        
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
        if([[NSDate new] getMonthNumber] == selectedMonth)
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
        
        
        
        DSDay *day = [[DSMonth getByYear:selectedYear month:selectedMonth].days objectAtIndex:indexPath.row];
        
        [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"UI"
                                                                                            action:[NSString stringWithFormat: @"Day click: %@", ([[day getDate] isToday])?@"Today":[[day getDate] toString]]
                                                                                             label:nil
                                                                                             value:nil] build]];
        
        
        DSDayViewController *navController = [[self storyboard] instantiateViewControllerWithIdentifier:@"DSDayViewController"];
        navController.day = day;
        [NSOperationQueue.mainQueue addOperationWithBlock:^(){
            [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
            
        }];
        [self.navigationController pushViewController:navController animated:YES];
        
    }
}


@end
