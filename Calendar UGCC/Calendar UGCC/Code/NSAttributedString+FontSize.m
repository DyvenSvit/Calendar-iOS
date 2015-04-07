//
//  NSAttributedString+FontSize.m
//  Calendar UGCC
//
//  Created by Max Gontar on 8/26/14.
//  Copyright (c) 2014 DyvenSvit. All rights reserved.
//

#import "NSAttributedString+FontSize.h"

@implementation NSAttributedString (FontSize)

- (NSAttributedString*) attributedStringWithFontSizeDelta:(CGFloat) fontSizeDelta
{
	NSMutableAttributedString* attributedString = [self mutableCopy];
    
	{
		[attributedString beginEditing];
        
		[attributedString enumerateAttribute:NSFontAttributeName inRange:NSMakeRange(0, attributedString.length) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
            
			UIFont* font = value;
			font = [font fontWithSize: font.pointSize + fontSizeDelta];
            
			[attributedString removeAttribute:NSFontAttributeName range:range];
			[attributedString addAttribute:NSFontAttributeName value:font range:range];
		}];
        
		[attributedString endEditing];
	}
    
	return [attributedString copy];
}

@end
