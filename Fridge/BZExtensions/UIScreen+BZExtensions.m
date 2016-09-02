//
//  UIScreen+BZExtensions.m
//  ismc
//
//  Created by User on 05.05.16.
//  Copyright © 2016 itvsystems. All rights reserved.
//

#import "UIScreen+BZExtensions.h"

@implementation UIScreen (BZExtensions)

#pragma mark - Class Methods (Public)

- (CGRect)methodGetCurrentBounds
{
    return [self methodGetBoundsForOrientation:
            [[UIApplication sharedApplication] statusBarOrientation]];
}

- (CGRect)methodGetBoundsForOrientation:(UIInterfaceOrientation)theOrientation
{
    CGRect theBounds = [self bounds];
    
    if (UIInterfaceOrientationIsLandscape(theOrientation))
    {
        CGFloat theBuffer = theBounds.size.width;
        
        theBounds.size.width = theBounds.size.height;
        theBounds.size.height = theBuffer;
    }
    return theBounds;
}

- (BOOL)isRetinaDisplay
{
    static dispatch_once_t predicate;
    static BOOL theAnswer;
    
    dispatch_once(&predicate, ^{
        theAnswer = ([self respondsToSelector:@selector(scale)] && [self scale] == 2);
    });
    return theAnswer;
}

#pragma mark - Class Methods (Private)

#pragma mark - Init & Dealloc

#pragma mark - Setters (Public)

#pragma mark - Getters (Public)

#pragma mark - Setters (Private)

#pragma mark - Getters (Private)

#pragma mark - Lifecycle

#pragma mark - Create Views & Variables

#pragma mark - Actions

#pragma mark - Gestures

#pragma mark - Delegates ()

#pragma mark - Methods (Public)

#pragma mark - Methods (Private)

#pragma mark - Standard Methods

@end































