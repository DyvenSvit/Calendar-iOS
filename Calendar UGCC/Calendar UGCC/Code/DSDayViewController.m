//
//  DSDayViewController.m
//  Calendar UGCC
//
//  Created by Max Gontar on 8/15/14.
//  Copyright (c) 2014 DyvenSvit. All rights reserved.
//

#import "DSDayViewController.h"


@implementation DSDayViewController

@synthesize day;

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
    
    UIBarButtonItem *addEventItem = [self getBarItemWithImageNamed:@"appbar_add_event" action:@selector(addEventItemClick)];
    UIBarButtonItem *sizeUpFontItem = [self getBarItemWithImageNamed:@"appbar_text_size_up" action:@selector(sizeUpFontItemClick)];
    UIBarButtonItem *sizeDownFontItem = [self getBarItemWithImageNamed:@"appbar_text_size_down" action:@selector(sizeDownFontItemClick)];
    NSArray *actionButtonItems = @[addEventItem, sizeDownFontItem, sizeUpFontItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
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

-(void)sizeUpFontItemClick
{
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"UI"
                                                                                        action:@"Size Up Font"
                                                                                         label:nil
                                                                                         value:nil] build]];
    for(DSDayContentViewController *vc in  [self viewControllers])
    {
        [vc updateWithSizeUpFont];
    }
}

-(void)sizeDownFontItemClick{
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"UI"
                                                                                        action:@"Size Down Font"
                                                                                         label:nil
                                                                                         value:nil] build]];
    for(DSDayContentViewController *vc in  [self viewControllers])
    {
        [vc updateWithSizeDownFont];
    }
}

-(void)addEventItemClick
{
    [NSOperationQueue.mainQueue addOperationWithBlock:^(){
        [MBProgressHUD showHUDAddedTo: self.parentViewController.view animated:YES];
    }];
    
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"UI"
                                                                                        action:@"Add Event"
                                                                                         label:nil
                                                                                         value:nil] build]];
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"dscal://%@", [day.date toString]]];
    
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    
    [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        
        
        if(granted)
        {
            
            NSDate *startEventDate =day.date;
            NSDate *endEventDate = [[NSDate alloc] initWithTimeInterval:60*60*24-1 sinceDate:day.date];
            
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
                                    [[[UIAlertView alloc] initWithTitle:@"Success" message:@"Event already exists" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil] show];
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
                newCalendarEvent.title = [day.holidayTitle string];
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
                    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to add event" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil] show];
                    }];
                    

                }
                else
                {
                    
                    [NSOperationQueue.mainQueue addOperationWithBlock:^(){
                    [[[UIAlertView alloc] initWithTitle:@"Success" message:@"Event successfully added" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil] show];
                    }];
                    

                }
            }
        }
        else if (error) {
            NSLog(@"CalendarIntegration.integrateDate: Error requesting access: %@", error);
            
            [NSOperationQueue.mainQueue addOperationWithBlock:^(){
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to add event" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil] show];
            }];
            

            
        }
        else
        {
            [NSOperationQueue.mainQueue addOperationWithBlock:^(){
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to add event" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil] show];
            }];
            

        }
        
        [NSOperationQueue.mainQueue addOperationWithBlock:^(){
            [MBProgressHUD hideAllHUDsForView:self.parentViewController.view animated:YES];
        }];
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    [self setSelectedIndex:ContentReadings];
    
    
    [self tabBar:self.tabBar didSelectItem:self.tabBar.selectedItem];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    switch([tabBar.items indexOfObject:item])
    {
        case ContentLiturgy:
            self.navigationItem.title = @"Служба";
            break;
        case ContentMorningHours:
            self.navigationItem.title = @"Утреня";
            break;
        case ContentNightHours:
            self.navigationItem.title = @"Вечірня";
            break;
        case ContentHours:
            self.navigationItem.title = @"Часи";
            break;
        case ContentReadings:
            self.navigationItem.title = @"Читання";
            break;
        case ContentHoliday:
            self.navigationItem.title = @"Свято";
            break;
        default:
            break;
    }
    
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"UI"
                                                                                        action:[NSString stringWithFormat:@"Tab Bar Item select: %@", self.navigationItem.title]
                                                                                         label:nil
                                                                                         value:nil] build]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)loadResources
{
    day = [[DSData shared] loadResourcesForDay:self.day];
    NSMutableArray *toRemove = [NSMutableArray new];
    for(DSDayContentViewController *vc in  [self viewControllers])
    {
        vc.day = day;
        vc.contentType = [[self viewControllers] indexOfObject:vc];
        
        
        NSString *text = @"";
        
        switch (vc.contentType) {
            case ContentLiturgy:
                text = self.day.dayLiturgy;
                break;
            case ContentMorningHours:
                text = self.day.dayMorningHours;
                break;
            case ContentNightHours:
                text = self.day.dayNightHours;
                break;
            case ContentHours:
                text = self.day.dayHours;
                break;
            case ContentReadings:
                text = self.day.dayReadings;
                break;
            case ContentHoliday:
                text = self.day.dayHoliday;
                break;
            default:
                break;
        }
        
        if(!text||[text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length==0)
        {
            [toRemove addObject:vc];
        }
    }
    
    
    NSMutableArray *newViewControllers = [NSMutableArray arrayWithArray:self.viewControllers];
    for(DSDayContentViewController *vc in toRemove)
    {
        [vc.webViewText removeFromSuperview];
        [newViewControllers removeObject:vc];
    }
    [NSOperationQueue.mainQueue addOperationWithBlock:^(){
        [self setViewControllers:newViewControllers];
    }];
    
    
}


@end
