//
//  UIScreen+BZExtensions.h
//  ismc
//
//  Created by User on 05.05.16.
//  Copyright © 2016 itvsystems. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScreen (BZExtensions)

- (CGRect)methodGetCurrentBounds;
- (CGRect)methodGetBoundsForOrientation:(UIInterfaceOrientation)theOrientation;
- (BOOL)isRetinaDisplay;

@end






























