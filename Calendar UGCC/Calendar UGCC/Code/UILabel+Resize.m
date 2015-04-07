//
//  UILabel+Resize.m
//  Calendar UGCC
//
//  Created by Max Gontar on 8/15/14.
//  Copyright (c) 2014 DyvenSvit. All rights reserved.
//

#import "UILabel+Resize.h"

@implementation UILabel (Resize)

- (void) resizeUILableWithFont
{
    //NSAttributedString *attributedText =    [[NSAttributedString alloc] initWithString:self.text     attributes:@{     NSFontAttributeName: self.font      }];
    CGRect frame = self.frame;
    //Calculate the expected size based on the font and linebreak mode of your label
    // FLT_MAX here simply means no constraint in height
    CGSize maximumLabelSize = CGSizeMake(frame.size.width, FLT_MAX);
    
    CGSize expectedLabelSize;
    
    //if (IOS7){
        
        NSDictionary *attributes =@{NSFontAttributeName:self.font};
        
        expectedLabelSize = [self.text boundingRectWithSize:maximumLabelSize options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:attributes context:nil].size;
    //}
    //else {
     //   expectedLabelSize = [self.text sizeWithFont:self.font constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
   // }
    
    expectedLabelSize.height +=21;
    
    expectedLabelSize.width = MAX(expectedLabelSize.width, frame.size.width);
    
    frame.size = expectedLabelSize;
    self.frame = frame;
}

- (void) resizeUILableWidthWithFont
{
    
    CGRect frame = self.frame;
    
    CGSize maximumLabelSize = CGSizeMake(FLT_MAX, frame.size.height );
    
    CGSize expectedLabelSize;
    
    //if (IOS7){
        
        NSDictionary *attributes =@{NSFontAttributeName:self.font};
        
        expectedLabelSize = [self.text boundingRectWithSize:maximumLabelSize options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:attributes context:nil].size;
    //}
    //else {
    //    expectedLabelSize = [self.text sizeWithFont:self.font constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
    //}
    
    
    frame.size = expectedLabelSize;
    self.frame = frame;
}


- (void) resizeAttributedUILableWithFont
{
    CGRect frame = self.frame;
    frame.size = [self getSizeUILableForAttributedString:self.attributedText];
    self.frame = frame;
}

- (CGSize) getSizeUILableForAttributedString:(NSAttributedString*)as
{
    CGRect frame = self.frame;
    CGSize maximumLabelSize = CGSizeMake(frame.size.width, FLT_MAX);
    CGSize expectedLabelSize;
    //if (IOS7){
        
        expectedLabelSize = [as boundingRectWithSize:maximumLabelSize options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil].size;
    //}
    //else {
     //   expectedLabelSize = [[as string] sizeWithFont:self.font constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
    //}
    expectedLabelSize.height +=21;
    
    expectedLabelSize.width = MAX(expectedLabelSize.width, frame.size.width);
    
    return expectedLabelSize;
}

@end
