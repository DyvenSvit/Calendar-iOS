//
//  DSDayViewController.m
//  Calendar UGCC
//
//  Created by Max Gontar on 8/15/14.
//  Copyright (c) 2014 DyvenSvit. All rights reserved.
//

#import "DSDayViewController.h"


@implementation DSDayViewController

NSInteger mFontSize = 20;
NSInteger DEFAULTWEBVIEWFONTSIZE = 18;

NSArray *contentModeIDs;

@synthesize day, contentType, menuView, webViewText, contentModeButtons;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(0 == [[NSUserDefaults standardUserDefaults] integerForKey:@"settings.font.size"])
    {
        [[NSUserDefaults standardUserDefaults] setInteger:20 forKey:@"settings.font.size"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    mFontSize = [[NSUserDefaults standardUserDefaults] integerForKey:@"settings.font.size"];
    
    contentModeIDs = @[@(ContentLiturgy),
                     @(ContentMorningHours),
                     @(ContentNightHours),
                     @(ContentHours),
                     @(ContentReadings),
                     @(ContentHoliday)];
    
    UIBarButtonItem *addEventItem = [self getBarItemWithImageNamed:@"appbar_add_event" action:@selector(addEventItemClick)];
    BOOL isScroll = [[NSUserDefaults standardUserDefaults] boolForKey:@"settings.scroll"];
    UIBarButtonItem *scrollMode = [self getBarItemWithImageNamed:isScroll?@"navbar.scroll.hor":@"navbar.scroll.ver" action:@selector(scrollModeClick:)];
    UIBarButtonItem *sizeUpFontItem = [self getBarItemWithImageNamed:@"appbar_text_size_up" action:@selector(sizeUpFontItemClick)];
    UIBarButtonItem *sizeDownFontItem = [self getBarItemWithImageNamed:@"appbar_text_size_down" action:@selector(sizeDownFontItemClick)];
    self.navigationItem.rightBarButtonItems = @[scrollMode, sizeDownFontItem, sizeUpFontItem];
    self.navigationItem.leftItemsSupplementBackButton = YES;
    self.navigationItem.leftBarButtonItems = @[addEventItem];
    
    webViewText.delegate = self;
    [self updateScrollMode];
    webViewText.scrollView.bounces = YES;
    
    if(day.liturgy == nil)
    {
        [MBProgressHUD showHUDAddedTo: self.view animated:YES];
        
        [DSWebAPI getYear:day.month.year.value month:day.month.value day:day.value withCompletionBlock:^(DSDay* result, NSError* error){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if(error)
            {
                
            }
            else
            {
                self.day = result;
            }
            
            [self loadResources];
        }];
        
    } else {
        [self loadResources];
    }
}

-(void) updateScrollMode
{
    BOOL isScroll = [[NSUserDefaults standardUserDefaults] boolForKey:@"settings.scroll"];
    
    CGFloat offsetV = webViewText.scrollView.contentOffset.y;
    CGFloat offsetH = webViewText.scrollView.contentOffset.x;
    
    int totalHPages = (int)(webViewText.scrollView.contentSize.width / webViewText.scrollView.frame.size.width);
    int totalVPages = (int)(webViewText.scrollView.contentSize.height / webViewText.scrollView.frame.size.height);
    
    int curHPage = (int)(webViewText.scrollView.contentOffset.x / webViewText.scrollView.frame.size.width);
    int curVPage = (int)(webViewText.scrollView.contentOffset.y / webViewText.scrollView.frame.size.height);

    
    NSLog(@"OV:%f, OH:%f, TVP:%d, THP:%d, CVP:%d, CHP:%d", offsetV, offsetH, totalVPages, totalHPages, curVPage, curHPage);
    
    if(isScroll)
    {
        webViewText.paginationMode = UIWebPaginationModeUnpaginated;
        webViewText.paginationBreakingMode = UIWebPaginationBreakingModePage;
        webViewText.scrollView.pagingEnabled = NO;
        webViewText.scrollView.pagingEnabled = NO;
        webViewText.scrollView.alwaysBounceHorizontal = NO;
        webViewText.scrollView.alwaysBounceVertical = YES;
        webViewText.scrollView.contentOffset = CGPointMake(0, webViewText.scrollView.frame.size.height*curHPage);
    }
    else
    {
        webViewText.paginationMode = UIWebPaginationModeLeftToRight;
        webViewText.paginationBreakingMode = UIWebPaginationBreakingModePage;
        webViewText.scrollView.pagingEnabled = YES;
        webViewText.scrollView.pagingEnabled = YES;
        webViewText.scrollView.alwaysBounceHorizontal = YES;
        webViewText.scrollView.alwaysBounceVertical = NO;
        webViewText.scrollView.contentOffset = CGPointMake(webViewText.scrollView.frame.size.width*curVPage, 0);
    }
}

-(UIBarButtonItem*) getBarItemWithImageNamed:(NSString*) imgName action:(SEL) action
{
    UIImage *img = [[UIImage imageNamed:imgName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTintColor:[UIColor whiteColor]];
    [btn setImage:img forState:UIControlStateNormal];
    [btn setContentMode:UIViewContentModeScaleAspectFit];
    [btn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    btn.showsTouchWhenHighlighted = YES;
    btn.frame = CGRectMake(0.0, 0.0, 22, 22);
    
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *bi = [[UIBarButtonItem alloc]
                           initWithCustomView:btn];
    
    return bi;
}

-(void)sizeUpFontItemClick
{
    /*
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"UI"
                                                                                        action:@"Size Up Font"
                                                                                         label:nil
                                                                                         value:nil] build]];
    */
     [self updateWithSizeUpFont];
}

-(void)sizeDownFontItemClick{
    /*
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"UI"
                                                                                        action:@"Size Down Font"
                                                                                         label:nil
                                                                                         value:nil] build]];
     */
    [self updateWithSizeDownFont];
}

-(void)scrollModeClick:(UIButton*)btn
{
    BOOL isScroll = [[NSUserDefaults standardUserDefaults] boolForKey:@"settings.scroll"];
    isScroll = !isScroll;
    [[NSUserDefaults standardUserDefaults] setBool:isScroll forKey:@"settings.scroll"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    UIImage* img = [[UIImage imageNamed:(isScroll?@"navbar.scroll.hor":@"navbar.scroll.ver")] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [btn setImage:img forState:UIControlStateNormal];
    [btn setTintColor:[UIColor whiteColor]];
    
    [self updateScrollMode];
}
-(void)addEventItemClick
{
    [NSOperationQueue.mainQueue addOperationWithBlock:^(){
        [MBProgressHUD showHUDAddedTo: self.view animated:YES];
    }];
    
    /*
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"UI"
                                                                                        action:@"Add Event"
                                                                                         label:nil
                                                                                         value:nil] build]];
    */
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"dscal://%@", [[day getDate] toString]]];
    
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    
    [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        
        
        if(granted)
        {
            
            NSDate *startEventDate =[day getDate];
            NSDate *endEventDate = [[NSDate alloc] initWithTimeInterval:60*60*24-1 sinceDate:[day getDate]];
            
            // Create the predicate from the event store's instance method
            NSPredicate *predicate = [eventStore predicateForEventsWithStartDate:startEventDate
                                                                         endDate:endEventDate
                                                                       calendars:nil];
            
            // Fetch all events that match the predicate
            NSArray *events = [eventStore eventsMatchingPredicate:predicate];
            BOOL exists = NO;
            for(EKEvent* e in events)
            {
                if([e.URL isEqual:url])
                {
                    exists = YES;
                    break;
                }
            }
            
            if(exists)
            {
                [NSOperationQueue.mainQueue addOperationWithBlock:^(){
                                    [[[UIAlertView alloc] initWithTitle:@"Успіх" message:@"Подія вже існує у Вашому системному календарі" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Закрити", nil] show];
                }];

            }
            else
            {
                
                // Get the appropriate calendar
                EKCalendar *calendar = [eventStore defaultCalendarForNewEvents];
                EKEvent *newCalendarEvent = [EKEvent eventWithEventStore:eventStore];
                newCalendarEvent.startDate = startEventDate;
                // If I just use the startDate as the end date, then the height of the event in the calendar is really short.
                
                newCalendarEvent.endDate = endEventDate;
                newCalendarEvent.title = [day.holidayTitleAttr string];
                newCalendarEvent.calendar = calendar;
                newCalendarEvent.URL = url;
                newCalendarEvent.allDay = YES;
                EKAlarm *alarm =[EKAlarm alarmWithAbsoluteDate: [[NSDate alloc] initWithTimeInterval:-60*60*24 sinceDate:startEventDate]];
                [newCalendarEvent addAlarm:alarm];
                
                NSError *error = nil;
                
                [eventStore saveEvent:newCalendarEvent span:EKSpanThisEvent error:&error];
                
                if (error) {
                    NSLog(@"CalendarIntegration.integrateDate: Error saving event: %@", error);
                    
                    [NSOperationQueue.mainQueue addOperationWithBlock:^(){
                    [[[UIAlertView alloc] initWithTitle:@"Помилка" message:@"Не вдалося додати подію у Ваш системний календар" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Закрити", nil] show];
                    }];
                    

                }
                else
                {
                    
                    [NSOperationQueue.mainQueue addOperationWithBlock:^(){
                    [[[UIAlertView alloc] initWithTitle:@"Успіх" message:@"Подію додано у Ваш системний календар" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Закрити", nil] show];
                    }];
                    

                }
            }
        }
        else if (error) {
            NSLog(@"CalendarIntegration.integrateDate: Error requesting access: %@", error);
            
            [NSOperationQueue.mainQueue addOperationWithBlock:^(){
            [[[UIAlertView alloc] initWithTitle:@"Помилка" message:@"Не вдалося додати подію у Ваш системний календар" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Закрити", nil] show];
            }];
            

            
        }
        else
        {
            [NSOperationQueue.mainQueue addOperationWithBlock:^(){
            [[[UIAlertView alloc] initWithTitle:@"Помилка" message:@"Не вдалося додати подію у Ваш системний календар" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Закрити", nil] show];
            }];
            

        }
        
        [NSOperationQueue.mainQueue addOperationWithBlock:^(){
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(contentModeButtons.count)
    {
        CGFloat btnWidth = menuView.frame.size.width/contentModeButtons.count;
        
        for(int i = 0; i < contentModeButtons.count; i++)
        {
            UIButton *btn = contentModeButtons[i];
            [menuView addSubview: btn];
            btn.frame = CGRectMake(i*btnWidth, 0, btnWidth, menuView.frame.size.height);
            
            btn.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
            
            [btn addTarget:self action:@selector(btnContentModeClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [self btnContentModeClick:contentModeButtons[0]];
    }
}

- (void)btnContentModeClick:(id) sender
{
    [NSOperationQueue.mainQueue addOperationWithBlock:^(){
        [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    }];
    
    NSString *text = @"";
    contentType = ((UIButton*)sender).tag;
    switch(contentType)
    {
        case ContentLiturgy:
            self.navigationItem.title = @"Служба";
            text = day.liturgy;
            //self.screenName = @"Liturgy";
            break;
        case ContentMorningHours:
            self.navigationItem.title = @"Утреня";
            text = day.morning;
            //self.screenName = @"Morning Hours";
            break;
        case ContentNightHours:
            self.navigationItem.title = @"Вечірня";
            text = day.night;
            //self.screenName = @"Night Hours";
            break;
        case ContentHours:
            self.navigationItem.title = @"Часи";
            text = day.hours;
            //self.screenName = @"Hours";
            break;
        case ContentReadings:
            self.navigationItem.title = @"Читання";
            text = day.readings;
            //self.screenName = @"Readings";
            break;
        case ContentHoliday:
            self.navigationItem.title = @"Свято";
            text = day.saints;
            //self.screenName = @"Holiday";
            break;
        default:
            break;
    }
    
    

    [webViewText loadHTMLString:text baseURL:nil];
    
    /*
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"UI"
                                                                                        action:[NSString stringWithFormat:@"Day content select: %@", self.navigationItem.title]
                                                                                         label:nil
                                                                                         value:nil] build]];
     */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)loadResources
{
    //day = [[DSData shared] loadResourcesForDay:self.day];
    contentModeButtons = [NSMutableArray new];
    for(NSNumber* n in contentModeIDs)
    {
        NSString *text = @"";
        NSString *btnImage = @"";
        switch ([n intValue]) {
            case ContentLiturgy:
                text = self.day.liturgy;
                btnImage = @"prayer_book";
                break;
            case ContentMorningHours:
                text = self.day.morning;
                btnImage = @"sunrise";
                break;
            case ContentNightHours:
                text = self.day.night;
                btnImage = @"candle";
                break;
            case ContentHours:
                text = self.day.hours;
                btnImage = @"minutes";
                break;
            case ContentReadings:
                text = self.day.readings;
                btnImage = @"Bible";
                break;
            case ContentHoliday:
                text = self.day.saints;
                btnImage = @"saint";
                break;
            default:
                break;
        }
        
        if(text&&[text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length!=0)
        {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            
            btn.tag = [n intValue];
            [btn setImage:[UIImage imageNamed:btnImage] forState:UIControlStateNormal];
            
            [contentModeButtons addObject:btn];
        }
    }
    
    if(contentModeButtons.count)
    {
        CGFloat btnWidth = menuView.frame.size.width/contentModeButtons.count;
        
        for(int i = 0; i < contentModeButtons.count; i++)
        {
            UIButton *btn = contentModeButtons[i];
            [menuView addSubview: btn];
            btn.frame = CGRectMake(i*btnWidth, 0, btnWidth, menuView.frame.size.height);
            
            btn.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
            
            [btn addTarget:self action:@selector(btnContentModeClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [self btnContentModeClick:contentModeButtons[0]];
    }
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if(webView == webViewText)
    {
        [self updateWithFontSize];
    }
}

-(void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [NSOperationQueue.mainQueue addOperationWithBlock:^(){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}


-(void)updateWithSizeUpFont
{
    if(mFontSize < 40)
    {
        [NSOperationQueue.mainQueue addOperationWithBlock:^(){
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        }];
        mFontSize++;
        [[NSUserDefaults standardUserDefaults] setInteger:mFontSize forKey:@"settings.font.size"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self updateWithFontSize];
    }
}

-(void)updateWithSizeDownFont
{
    if(mFontSize > 12)
    {
        [NSOperationQueue.mainQueue addOperationWithBlock:^(){
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        }];
        mFontSize--;
        [[NSUserDefaults standardUserDefaults] setInteger:mFontSize forKey:@"settings.font.size"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self updateWithFontSize];
    }
}

-(void)updateWithFontSize;
{
    JSContext *ctx = [webViewText valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    NSString *jsForTextSize = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%ld%%'", (long)mFontSize*100/(long)DEFAULTWEBVIEWFONTSIZE];
    
    [ctx evaluateScript:jsForTextSize];
    [NSOperationQueue.mainQueue addOperationWithBlock:^(){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

@end
