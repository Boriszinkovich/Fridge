//
//  BZExtensionsManager.m
//  ScrollViewTask
//
//  Created by BZ on 2/15/16.
//  Copyright © 2016 BZ. All rights reserved.
//

#import "BZExtensionsManager.h"

BOOL isEqual(id _Nullable theObject1, id _Nullable theObject2)
{
    if (!theObject1 && !theObject2)
    {
        return YES;
    }
    return [theObject1 isEqual:theObject2];
}

NSString * _Nullable  sfs(SEL _Nonnull theSelector)
{
    if (!theSelector)
    {
        abort();
    }
    return NSStringFromSelector(theSelector);
}

NSString * _Nullable sfc(Class _Nonnull theClass)
{
    if (!theClass)
    {
        BZAssert(nil);
    }
    return NSStringFromClass(theClass);
}

@implementation BZExtensionsManager

#pragma mark - Class Methods (Public)

+ (void)methodDispatchAfterSeconds:(double)theSeconds
                         withBlock:(void (^ _Nonnull)())theBlock
{
    NSDate *theStartDate = [NSDate new];
    BZAssert(theBlock && theSeconds >= 0);
    BOOL isMainThread = [[NSThread currentThread] isMainThread];
        [BZExtensionsManager methodAsyncBackgroundWithBlock:^
         {
             NSDate *theCurrentDate = [NSDate new];
             [NSThread sleepForTimeInterval:theSeconds - [theCurrentDate timeIntervalSinceDate:theStartDate]];
             if (isMainThread)
             {
                 [BZExtensionsManager methodAsyncMainWithBlock:^
                  {
                      theBlock();
                  }];
             }
             else
             {
                 theBlock();
             }
         }];
}

+ (void)methodAsyncMainWithBlock:(void (^ _Nonnull)())theBlock
{
    if (!theBlock)
    {
        BZAssert(nil);
    }
    dispatch_async(dispatch_get_main_queue(), theBlock);
}

+ (void)methodAsyncBackgroundWithBlock:(void (^ _Nonnull)())theBlock
{
    if (!theBlock)
    {
        BZAssert(nil);
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), theBlock);
//    BZSyncBackground *theBZSyncBackground = [BZSyncBackground new];
//    [theBZSyncBackground methodSyncBackgroundWithBlock:theBlock];
}

+ (void)methodSyncMainWithBlock:(void (^ _Nonnull)())theBlock
{
    if (!theBlock)
    {
        BZAssert(nil);
    }
    dispatch_sync(dispatch_get_main_queue(), theBlock);
}

+ (BZDevice)getDevice
{
    UIInterfaceOrientation theDeviceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        CGSize theSize = [UIScreen mainScreen].bounds.size;
        double theSpecialMetric;
        if (theDeviceOrientation == UIInterfaceOrientationPortrait || theDeviceOrientation == UIInterfaceOrientationPortraitUpsideDown)
        {
            theSpecialMetric = theSize.height;
        }
        else
        {
            theSpecialMetric = theSize.width;
        }
        if (theSpecialMetric == 1024)
        {
            return BZDeviceIpad;
        }
        if (theSpecialMetric == 1366)
        {
            return BZDeviceIpadPro;
        }
        return BZDeviceIpad;
    }
    else
    {
        CGSize theSize = [UIScreen mainScreen].bounds.size;
        double theSpecialMetric;
        if (theDeviceOrientation == UIInterfaceOrientationPortrait || theDeviceOrientation == UIInterfaceOrientationPortraitUpsideDown)
        {
            theSpecialMetric = theSize.height;
        }
        else
        {
            theSpecialMetric = theSize.width;
        }
        if (theSpecialMetric == 480)
        {
            return BZDeviceIphone4;
        }
        if (theSpecialMetric == 568)
        {
            return BZDeviceIphone5;
        }
        if (theSpecialMetric == 667)
        {
            return BZDeviceIphone6;
        }
        if (theSpecialMetric == 736)
        {
            return BZDeviceIphone6Plus;
        }
    }
    return BZDeviceIpad;
}

+ (BZDevice)getClothestDevice
{
    UIInterfaceOrientation theDeviceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    CGSize theSize = [UIScreen mainScreen].bounds.size;
    double theSpecialMetric;
    if (theDeviceOrientation == UIInterfaceOrientationPortrait || theDeviceOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        theSpecialMetric = theSize.height;
    }
    else
    {
        theSpecialMetric = theSize.width;
    }
    NSMutableArray<NSNumber *> *theValuesArray = [NSMutableArray arrayWithObjects:@(480), @(568), @(667), @(736), @(1024), @(1366), nil];
    NSMutableArray<NSNumber *> *theFloorsArray = [NSMutableArray new];
    for (int i = 0; i < theValuesArray.count; i++)
    {
        double theValue = theValuesArray[i].doubleValue;
        theValue = fabs(theValue - theSpecialMetric);
        [theFloorsArray addObject:@(theValue)];
    }
    for (int i = 0; i < theFloorsArray.count; i++)
    {
        for (int j = 0; j < theFloorsArray.count - 1; j++)
        {
            if (theFloorsArray[j + 1].doubleValue < theFloorsArray[j].doubleValue)
            {
                NSNumber *theTemp = theFloorsArray[j+1];
                theFloorsArray[j+1] = theFloorsArray[j];
                theFloorsArray[j] = theTemp;
                NSNumber *theTemp2 = theValuesArray[j+1];
                theValuesArray[j+1] = theValuesArray[j];
                theValuesArray[j] = theTemp2;
            }
        }
    }
    theSpecialMetric = theValuesArray[0].doubleValue;
    if (theSpecialMetric == 480)
    {
        return BZDeviceIphone4;
    }
    if (theSpecialMetric == 568)
    {
        return BZDeviceIphone5;
    }
    if (theSpecialMetric == 667)
    {
        return BZDeviceIphone6;
    }
    if (theSpecialMetric == 736)
    {
        return BZDeviceIphone6Plus;
    }
    if (theSpecialMetric == 1024)
    {
        return BZDeviceIpad;
    }
    if (theSpecialMetric == 1366)
    {
        return BZDeviceIpadPro;
    }
    return BZDeviceIphone4;
    BZAssert(nil);
}

+ (void)methodPrintAllFonts
{
    for (NSString *theFamily in [UIFont familyNames])
    {
        NSLog(@"%@", theFamily);
        for (NSString *theName in [UIFont fontNamesForFamilyName:theFamily])
        {
            NSLog(@" %@", theName);
        }
    }
}

+ (double)methodGetStatusBarHeight
{
    return [UIApplication sharedApplication].statusBarFrame.size.height;
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

+ (void)selectorWithBlock:(void (^ _Nonnull)())theBlock
{
    theBlock();
}

#pragma mark - Standard Methods

@end






























