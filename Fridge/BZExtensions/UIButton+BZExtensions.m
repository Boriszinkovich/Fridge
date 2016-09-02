//
//  UIButton+BZExtensions.m
//  ismc
//
//  Created by User on 08.05.16.
//  Copyright © 2016 itvsystems. All rights reserved.
//

#import "UIButton+BZExtensions.h"

#import <objc/runtime.h>

@interface UIButton (BZExtensions_private)

@property (nonatomic, strong, nullable) UIColor *theNormalBackgroundColor;
@property (nonatomic, assign) BOOL isCalledInside;

@end

@implementation UIButton (BZExtensions_private)

#pragma mark - Class Methods (Public)

#pragma mark - Class Methods (Private)

#pragma mark - Init & Dealloc

#pragma mark - Setters (Public)

#pragma mark - Getters (Public)

#pragma mark - Setters (Private)

- (void)setTheNormalBackgroundColor:(UIColor *)theNormalBackgroundColor
{
    objc_setAssociatedObject(self, @selector(theNormalBackgroundColor), theNormalBackgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setIsCalledInside:(BOOL)isCalledInside
{
    objc_setAssociatedObject(self, @selector(isCalledInside), @(isCalledInside), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Getters (Private)

- (UIColor *)theNormalBackgroundColor
{
    UIColor *theColor = objc_getAssociatedObject(self, @selector(theNormalBackgroundColor));
    return theColor;
}

- (BOOL)isCalledInside
{
    NSNumber *theNumber = objc_getAssociatedObject(self, @selector(isCalledInside));
    if (!theNumber)
    {
        objc_setAssociatedObject(self, @selector(isCalledInside), @(NO), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        theNumber = @(NO);
    }
    return theNumber.boolValue;
}

#pragma mark - Lifecycle

#pragma mark - Create Views & Variables

#pragma mark - Actions

#pragma mark - Gestures

#pragma mark - Delegates ()

#pragma mark - Methods (Public)

#pragma mark - Methods (Private)

#pragma mark - Standard Methods

@end

@implementation UIButton (BZExtensions)

#pragma mark - Class Methods (Public)

#pragma mark - Class Methods (Private)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      Class class = [self class];
                      SEL originalSelector = nil;
                      SEL swizzledSelector = nil;
                      Method originalMethod = nil;
                      Method swizzledMethod = nil;
                      //        BOOL didAddMethod;
                      for (int i = 0; i < 2; i++)
                      {
                          if (i == 0)
                          {
                              originalSelector = @selector(setHighlighted:);
                              swizzledSelector = @selector(swizzledBZ_setHighlighted:);
                              originalMethod = class_getInstanceMethod(class, originalSelector);
                              swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
                          }
                          if (i == 1)
                          {
                              originalSelector = @selector(setBackgroundColor:);
                              swizzledSelector = @selector(swizzledBZ_setBackgroundColor:);
                              originalMethod = class_getInstanceMethod(class, originalSelector);
                              swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
                          }
                          BZAssert((BOOL)(originalMethod && swizzledMethod && originalSelector && swizzledSelector));
                          
                          BOOL didAddMethod =  class_addMethod(class,
                                                               originalSelector,
                                                               method_getImplementation(swizzledMethod),
                                                               method_getTypeEncoding(swizzledMethod));
                          if (didAddMethod)
                          {
                              class_replaceMethod(class,
                                                  swizzledSelector,
                                                  method_getImplementation(originalMethod),
                                                  method_getTypeEncoding(originalMethod));
                          }
                          else
                          {
                              method_exchangeImplementations(originalMethod, swizzledMethod);
                          }
                      }
                  });
}

#pragma mark - Init & Dealloc

#pragma mark - Setters (Public)

- (void)setTheHighlightedBackgroundColor:(UIColor *)theHighlightedBackgroundColor
{
    objc_setAssociatedObject(self, @selector(theHighlightedBackgroundColor), theHighlightedBackgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Getters (Public)

- (UIColor *)theHighlightedBackgroundColor
{
    UIColor *theColor = objc_getAssociatedObject(self, @selector(theHighlightedBackgroundColor));
    return theColor;
}

#pragma mark - Setters (Private)

- (void)swizzledBZ_setHighlighted:(BOOL)highlighted
{
    [self swizzledBZ_setHighlighted:highlighted];
    if (highlighted)
    {
        if (self.theHighlightedBackgroundColor)
        {
            self.isCalledInside = YES;
            self.backgroundColor = self.theHighlightedBackgroundColor;
        }
    }
    else
    {
        if (self.theNormalBackgroundColor)
        {
            self.isCalledInside = YES;
            self.backgroundColor = self.theNormalBackgroundColor;
        }
    }
}

- (void)swizzledBZ_setBackgroundColor:(UIColor *)theColor
{
    [self swizzledBZ_setBackgroundColor:theColor];
    if (self.isCalledInside)
    {
        self.isCalledInside = NO;
        return;
    }
    self.theNormalBackgroundColor = theColor;
}

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






























