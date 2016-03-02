//
//  BZDynamicHeightUILabel.m
//  Fridge
//
//  Created by User on 09.02.16.
//  Copyright © 2016 BZ. All rights reserved.
//

#import "BZDynamicHeightUILabel.h"

@implementation BZDynamicHeightUILabel

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.numberOfLines == 0 && self.preferredMaxLayoutWidth != CGRectGetWidth(self.frame))
    {
        self.preferredMaxLayoutWidth = self.frame.size.width;
        [self setNeedsUpdateConstraints];
    }
}

- (CGSize)intrinsicContentSize
{
    CGSize s = [super intrinsicContentSize];
    
    if (self.numberOfLines == 0)
    {
        s.height += 1;
    }
    
    return s;
}

@end
