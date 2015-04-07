//
//  UIViewController+Loading.m
//  Calendar UGCC
//
//  Created by Max Gontar on 8/15/14.
//  Copyright (c) 2014 DyvenSvit. All rights reserved.
//

#import "UIViewController+Dialog.h"


@implementation UIViewController (Dialog)

- (void)showAlert:(NSString*)title message:(NSString*)message {
    
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    
}

- (void)showException:(NSException*)exception {
    [self showAlert:exception.name message:exception.reason];
}

@end
