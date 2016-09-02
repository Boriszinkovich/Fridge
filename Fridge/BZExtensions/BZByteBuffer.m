//
//  BZByteBuffer.m
//  ismc
//
//  Created by User on 10.05.16.
//  Copyright © 2016 itvsystems. All rights reserved.
//

#import "BZByteBuffer.h"

@interface BZByteBuffer()

@property (nonatomic, strong) NSMutableData *theData;
@property (nonatomic, assign) int theCapacity;
@property (nonatomic, assign) BZByteOrder theByteOrder;

@end

@implementation BZByteBuffer

#pragma mark - Class Methods (Public)

+ (NSData *)wrapWithData:(NSData *)theData withStartPosition:(NSInteger)theStartPosition withCount:(NSInteger)theCount
{
    Byte *theBytePtr = [theData.mutableCopy mutableBytes];
    Byte *theSecondBytePtr = malloc(theCount);
    for (int i = 0; i < theCount; i++)
    {
        theSecondBytePtr[i] = theBytePtr[theStartPosition + i];
    }
    return [NSData dataWithBytes:theSecondBytePtr length:theCount];
}

#pragma mark - Class Methods (Private)

#pragma mark - Init & Dealloc

+ (instancetype)initWithOrder:(BZByteOrder)order
{
    BZByteBuffer *theBuffer = [BZByteBuffer new];
    [theBuffer setOrder:order];
    return theBuffer;
}

- (id)init
{
    self = [super init];
    self.theData = [NSMutableData data];
    return self;
}

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

- (void)setOrder:(BZByteOrder)order
{
    self.theByteOrder = order;
}

- (void)put:(Byte)b
{
    [self.theData appendBytes:&b length:sizeof(b)];
}

- (void)putOnIndex:(NSInteger)theIndex byte:(Byte)b
{
    NSUInteger theLength = self.theData.length;
    unsigned char *theBytePtr = [self.theData mutableBytes];
    theBytePtr[theIndex] = b;
    self.theData = [[NSMutableData alloc] initWithBytes:theBytePtr length:theLength];
}

- (void)putByteBuffer:(BZByteBuffer*)bb
{
    [self.theData appendData:bb.convertNSMutableData];
}

- (void)putData:(NSData*)data
{
    [self.theData appendData:data];
}

- (void)putShort:(short)d
{
    short theTemp = d;
    if (self.theByteOrder == BZByteOrderBigEndian)
    {
        theTemp = CFSwapInt16HostToBig(d);
    }
    [self.theData appendBytes:&theTemp length:sizeof(d)];
}

- (void)putFloat:(float)f
{
    float theTemp = f;
    if (self.theByteOrder == BZByteOrderBigEndian)
    {
        theTemp = CFSwapInt16HostToBig(f);
    }
    [self.theData appendBytes:&theTemp length:sizeof(theTemp)];
}


- (void)putInt:(int)i
{
    int theTemp = i;
    if (self.theByteOrder == BZByteOrderBigEndian)
    {
        theTemp = CFSwapInt16HostToBig(i);
    }
    [self.theData appendBytes:&theTemp length:sizeof(i)];
}

- (void)putLongLong:(long long)l;
{
    long long theTemp = l;
    if (self.theByteOrder == BZByteOrderBigEndian)
    {
        theTemp = CFSwapInt64HostToBig(l);
    }
    else
    {
        theTemp = CFSwapInt64HostToLittle(l);
    }
    [self.theData appendBytes:&theTemp length:sizeof(l)];
}

- (Byte)get:(int)index
{
    char *theByte = (char *)self.theData.bytes;
    return theByte[index];
}

- (float)getFloat:(int)index
{
    float theTemp = 0;
    BZByteBuffer *theBuffer = [BZByteBuffer new];
    [theBuffer putData:[self.theData subdataWithRange:NSMakeRange(index, sizeof(theTemp))]];
    
    [theBuffer.convertNSMutableData getBytes:&theTemp length:sizeof(theTemp)];
    return theTemp;
}

- (int)getInt:(int)index
{
    int theTemp;
    [self.theData getBytes:&theTemp range:NSMakeRange(index, sizeof(theTemp))];
    
    return theTemp;
}

- (NSMutableData *)convertNSMutableData;
{
    return self.theData;
}

#pragma mark - Methods (Private)

#pragma mark - Standard Methods

@end





























