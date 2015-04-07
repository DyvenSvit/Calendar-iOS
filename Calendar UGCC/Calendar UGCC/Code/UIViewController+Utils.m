//
//  UIViewController+Utils.m
//  Calendar UGCC
//
//  Created by Max Gontar on 8/15/14.
//  Copyright (c) 2014 DyvenSvit. All rights reserved.
//

#import "UIViewController+Utils.h"

@implementation UIViewController (Utils)


- (BOOL)isVisible {
    return [self isViewLoaded] && self.view.window;
}


@end
