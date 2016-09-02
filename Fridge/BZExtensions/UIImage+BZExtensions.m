//
//  UIImage+BZExtensions.m
//  ScrollViewTask
//
//  Created by BZ on 2/16/16.
//  Copyright © 2016 BZ. All rights reserved.
//

#import "UIImage+BZExtensions.h"

#import "BZExtensionsManager.h"

@interface BZImageManager : NSObject

+ (BZImageManager * _Nonnull)sharedInstance;

//- (UIImage * _Nullable)getImageNamed:(NSString * _Nonnull)theImageNameString;

@property (nonatomic, strong, nonnull) NSMutableDictionary *theImageDictionary;

@end

@implementation BZImageManager

#pragma mark - Class Methods (Public)

+ (BZImageManager * _Nonnull)sharedInstance
{
    
    static BZImageManager *theMainBZImageManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      theMainBZImageManager = [[BZImageManager alloc] initSharedInstance];
                  });
    return theMainBZImageManager;
}

- (instancetype _Nonnull)initSharedInstance
{
    self = [super init];
    if (self)
    {
        [self methodInitBZImageManager];
    }
    return self;
}

- (void)methodInitBZImageManager
{
    _theImageDictionary = [NSMutableDictionary new];
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

#pragma mark - Notifications

#pragma mark - Delegates ()

#pragma mark - Methods (Public)

- (UIImage * _Nullable)getImageNamed:(NSString * _Nonnull)theImageNameString
{
    if (!theImageNameString)
    {
        BZAssert(nil);
    }
    [self methodDeleteNonActualImages];
    if (!self.theImageDictionary[theImageNameString])
    {
        UIImage *theResultImage = [self privateGetImageNamed:theImageNameString];
        if (theResultImage)
        {
            self.theImageDictionary[theImageNameString] = theResultImage;
        }
        [self methodDeleteNonActualImages];
        return theResultImage;
    }
    return self.theImageDictionary[theImageNameString];
}

#pragma mark - Methods (Private)

- (void)methodDeleteNonActualImages
{
    NSArray *theKeysArray = [self.theImageDictionary keysSortedByValueUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2)
                             {
                                 NSInteger theFirstRetainCount = ((NSObject *)obj1).theRetainCount;
                                 NSInteger theSecondRetainCount = ((NSObject *)obj2).theRetainCount;
                                 if (theFirstRetainCount < theSecondRetainCount)
                                 {
                                     return NSOrderedAscending;
                                 }
                                 else if (theFirstRetainCount == theSecondRetainCount)
                                 {
                                     return NSOrderedSame;
                                 }
                                 else
                                 {
                                     return NSOrderedDescending;
                                 }
                             }];
    for (int i = 0; i < theKeysArray.count; i++)
    {
        NSInteger theRetainCount = ((NSObject *)self.theImageDictionary[theKeysArray[i]]).theRetainCount;
        if (theRetainCount == 2)
        {
            [self.theImageDictionary removeObjectForKey:theKeysArray[i]];
        }
        else
        {
            break;
        }
    }
}

- (UIImage *)privateGetImageNamed:(NSString *)theImageName
{
    BZDevice theDevice;
    NSString *theFileName;
    //check for retina display
    if ([[UIScreen mainScreen] isRetinaDisplay])
    {
        theDevice = [BZExtensionsManager getDevice];
        switch (theDevice)
        {
            case BZDeviceUndefined:
            {
                theFileName = [NSString stringWithFormat:@"mipmap-xxhdpi/%@.png",theImageName];
            }
                break;
            case BZDeviceIphone6Plus:
            {
                theFileName = [NSString stringWithFormat:@"mipmap-xxxhdpi/%@.png",theImageName];
            }
                break;
            case BZDeviceIphone6:
            {
                theFileName = [NSString stringWithFormat:@"mipmap-xxhdpi/%@.png",theImageName];
            }
                break;
            case BZDeviceIphone5:
            {
                theFileName = [NSString stringWithFormat:@"mipmap-xxhdpi/%@.png",theImageName];
                
            }
                break;
            case BZDeviceIphone4:
            {
                theFileName = [NSString stringWithFormat:@"mipmap-xxhdpi/%@.png",theImageName];
            }
                break;
            case BZDeviceIpad:
            {
                theFileName = [NSString stringWithFormat:@"mipmap-xxhdpi/%@.png",theImageName];
            }
                break;
            case BZDeviceIpadPro:
            {
                theFileName = [NSString stringWithFormat:@"mipmap-xxhdpi/%@.png",theImageName];
            }
        }
    }
    else
    {
        if (theDevice == BZDeviceIphone6Plus)
        {
            theFileName = [NSString stringWithFormat:@"mipmap-xxxhdpi/%@.png",theImageName];

        }
        else
        {
            theFileName = [NSString stringWithFormat:@"mipmap-xhdpi/%@.png",theImageName];
        }
        // non-Retina display
    }
    UIImage *theImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]
                                                          pathForResource:theFileName ofType:nil]];
    return theImage;
}

#pragma mark - Standard Methods

@end

@implementation UIImage (BZExtensions)

#pragma mark - Class Methods (Public)

+ (UIImage * _Nullable)getImageNamed:(NSString * _Nonnull)theImageName
{
    return [[BZImageManager sharedInstance] getImageNamed:theImageName];
}

+ (UIImage *)getImageFromColor:(UIColor * _Nonnull)theColor
{
    if (!theColor)
    {
        BZAssert(nil);
    }
    CGRect theRect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(theRect.size);
    CGContextRef theContext = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(theContext, [theColor CGColor]);
    CGContextFillRect(theContext, theRect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
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

- (UIImage * __nonnull)getImageWithSize:(CGSize)theSize;
{
    size_t theWidth = theSize.width * [UIScreen mainScreen].scale;
    size_t theHeight = theSize.height * [UIScreen mainScreen].scale;
    
    CGColorSpaceRef theColorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGContextRef theContextRef = CGBitmapContextCreate(NULL, theWidth, theHeight, 8, theWidth*4, theColorSpaceRef, kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little);
    CGColorSpaceRelease(theColorSpaceRef);
    
    CGContextDrawImage(theContextRef, CGRectMake(0, 0, theWidth, theHeight), self.CGImage);
    CGImageRef theOutputImageRef = CGBitmapContextCreateImage(theContextRef);
    UIImage *theImage = [UIImage imageWithCGImage:theOutputImageRef];
    
    CGImageRelease(theOutputImageRef);
    CGContextRelease(theContextRef);
    return theImage;
}

#pragma mark - Methods (Private)

#pragma mark - Standard Methods

@end






























