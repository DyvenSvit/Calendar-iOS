//
//  UILabel+Resize.h
//  Calendar UGCC
//
//  Created by Max Gontar on 8/15/14.
//  Copyright (c) 2014 DyvenSvit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Resize)

- (void) resizeUILableWithFont;
- (void) resizeAttributedUILableWithFont;
- (void) resizeUILableWidthWithFont;
- (CGSize) getSizeUILableForAttributedString:(NSAttributedString*)as;

@end