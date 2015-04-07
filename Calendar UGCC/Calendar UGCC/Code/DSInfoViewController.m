//
//  DSInfoViewController.m
//  Calendar UGCC
//
//  Created by Max Gontar on 9/17/14.
//  Copyright (c) 2014 DyvenSvit. All rights reserved.
//

#import "DSInfoViewController.h"

@interface DSInfoViewController ()

@end

@implementation DSInfoViewController
@synthesize mWebView;

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
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }];
    
    
    self.screenName = @"Info";
    
    self.navigationItem.title = @"Інфо";
    
    NSURL *bundleURL = [[NSBundle mainBundle] resourceURL];
    NSURL * documentsPath = [bundleURL URLByAppendingPathComponent:@"Assets"];
    NSURL * yearPath = [documentsPath URLByAppendingPathComponent:@"about.html"];
    
    NSString* htmlString =[NSString stringWithContentsOfURL:yearPath encoding:
                                                        NSUTF8StringEncoding error:nil];
    
    mWebView.delegate =self;
    

    [mWebView loadHTMLString:htmlString baseURL:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [NSOperationQueue.mainQueue addOperationWithBlock:^(){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

-(void) webViewDidFinishLoad:(UIWebView *)webView
{
    [NSOperationQueue.mainQueue addOperationWithBlock:^(){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    
    return YES;
}

@end
