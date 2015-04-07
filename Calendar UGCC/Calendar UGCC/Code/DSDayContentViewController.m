//
//  DSDayContentViewController.m
//  Calendar UGCC
//
//  Created by Max Gontar on 8/20/14.
//  Copyright (c) 2014 DyvenSvit. All rights reserved.
//

#import "DSDayContentViewController.h"

@interface DSDayContentViewController ()

@end


@implementation DSDayContentViewController

NSInteger mFontSize = 20;
NSInteger DEFAULTWEBVIEWFONTSIZE = 18;

@synthesize webViewText, contentType, scrollView;
@class DSLiturgyViewController;
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
    
    [NSOperationQueue.mainQueue addOperationWithBlock:^(){
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    }];
    
    NSString *text = @"";
    
    switch (contentType) {
        case ContentLiturgy:
            text = self.day.dayLiturgy;
            self.navigationItem.title = @"Служба Божа";
                self.screenName = @"Liturgy";
            break;
        case ContentMorningHours:
            text = self.day.dayMorningHours;
            self.navigationItem.title = @"Утреня";
            self.screenName = @"Morning Hours";
            break;
        case ContentNightHours:
            text = self.day.dayNightHours;
            self.navigationItem.title = @"Вечірня";
            self.screenName = @"Night Hours";
            break;
        case ContentHours:
            text = self.day.dayHours;
            self.navigationItem.title = @"Часи";
            self.screenName = @"Hours";
            break;
        case ContentReadings:
            text = self.day.dayReadings;
            self.navigationItem.title = @"Читання";
            self.screenName = @"Readings";
            break;
        case ContentHoliday:
            text = self.day.dayHoliday;
            self.navigationItem.title = @"Свято";
            self.screenName = @"Holiday";
            break;
        default:
            break;
    }
    
    webViewText.delegate = self;
    [webViewText loadHTMLString:text baseURL:nil];
    
    if(IOS7)
    {
        webViewText.paginationMode = UIWebPaginationModeLeftToRight;
        webViewText.paginationBreakingMode = UIWebPaginationBreakingModePage;
        webViewText.scrollView.pagingEnabled = YES;
        webViewText.scrollView.pagingEnabled = YES;
        webViewText.scrollView.alwaysBounceHorizontal = YES;
        webViewText.scrollView.alwaysBounceVertical = NO;
        webViewText.scrollView.bounces = YES;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
