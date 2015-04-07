//
//  UIViewController+Loading.h
//  Calendar UGCC
//
//  Created by Max Gontar on 8/15/14.
//  Copyright (c) 2014 DyvenSvit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Dialog)

- (void)showAlert:(NSString*)title message:(NSString*)message;
- (void)showException:(NSException*)exception;

@end
