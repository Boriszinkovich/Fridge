//
//  NSString+BZExtensions.m
//  VKMusicClient
//
//  Created by User on 12.03.16.
//  Copyright © 2016 BZ. All rights reserved.
//

#import "NSString+BZExtensions.h"

#import "BZExtensionsManager.h"

#import <CommonCrypto/CommonDigest.h>

#import <objc/runtime.h>

@interface NSString ()

@property (nonatomic, assign) BOOL isUndefined;

@end

static double theArrayIndex = -1;

@implementation NSString (BZExtensions)

#pragma mark - Class Methods (Public)

#pragma mark - Class Methods (Private)

#pragma mark - Init & Dealloc

#pragma mark - Setters (Public)

#pragma mark - Getters (Public)

- (double)theDeviceValue
{
    NSArray<NSString *> *theStringArray = [self componentsSeparatedByString:@" "];
    BZAssert((BOOL)(theStringArray.count == 6));
    if (theArrayIndex == -1)
    {
        BZDevice theDevice = [BZExtensionsManager getClothestDevice];
        switch (theDevice)
        {
            case BZDeviceIphone4:
            {
                theArrayIndex = 5;
            }
                break;
            case BZDeviceIphone5:
            {
                theArrayIndex = 4;
            }
                break;
            case BZDeviceIphone6:
            {
                theArrayIndex = 3;
            }
                break;
            case BZDeviceIphone6Plus:
            {
                theArrayIndex = 2;
            }
                break;
            case BZDeviceIpad:
            {
                theArrayIndex = 1;
            }
                break;
            case BZDeviceIpadPro:
            {
                theArrayIndex = 0;
            }
                break;
            case BZDeviceUndefined:
            {
                self.isUndefined = YES;
                BZAssert(nil);
            }
                break;
        };
    }
        return theStringArray[(int)theArrayIndex].doubleValue;
}

- (double)theDeviceUndefinedValue
{
    BZAssert((BOOL)([self componentsSeparatedByString:@" "].count == 6));
    return 0;
}

- (NSString *)MD5
{
    // Create pointer to the string as UTF8
    const char *ptr = [self UTF8String];
    
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(ptr, (unsigned)strlen(ptr), md5Buffer);
    
    // Convert MD5 value in the buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    
    return output;
}

- (NSString *)base64EncodedString
{
    NSData *theData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSString *theBase64String = [theData base64EncodedStringWithOptions:0];
    return theBase64String;
}

#pragma mark - Setters (Private)

- (void)setIsUndefined:(BOOL)isUndefined
{
    NSNumber *theNumber = [NSNumber numberWithBool:isUndefined];
    objc_setAssociatedObject(self, @selector(isUndefined), theNumber, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
#pragma mark - Getters (Private)

- (BOOL)isUndefined
{
    NSNumber *theNumber = objc_getAssociatedObject(self, @selector(isUndefined));
    if (!theNumber)
    {
        theNumber = [NSNumber numberWithBool:NO];
        objc_setAssociatedObject(self, @selector(isUndefined), theNumber, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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

- (void)methodCountUndefinedWithDevice:(BZDevice)theDevice
{
    
}

#pragma mark - Standard Methods

@end






























