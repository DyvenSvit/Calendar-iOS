//
//  UIView+Utils.m
//  Calendar UGCC
//
//  Created by Max Gontar on 8/14/14.
//  Copyright (c) 2014 DyvenSvit. All rights reserved.
//

#import "UIView+Utils.h"

@implementation UIView (Utils)

-(void) setBackgroudGradientFrom:(UIColor*)from To:(UIColor*)to
{
CAGradientLayer *gradient = [CAGradientLayer layer];
gradient.frame = self.bounds ;
gradient.colors = [NSArray arrayWithObjects:(id)[from CGColor], (id)[to CGColor], nil];
[self.layer insertSublayer:gradient atIndex:0];
}
@end
