//
//  BZByteBuffer.h
//  ismc
//
//  Created by User on 10.05.16.
//  Copyright © 2016 itvsystems. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Foundation/Foundation.h>

typedef enum
{
    BZByteOrderBigEndian,
    BZByteOrderLittleEndian,
} BZByteOrder;

@interface BZByteBuffer : NSObject

+ (instancetype)initWithOrder:(BZByteOrder)order;

+ (NSData *)wrapWithData:(NSData *)theData withStartPosition:(NSInteger)theStartPosition withCount:(NSInteger)theCount;

- (void)setOrder:(BZByteOrder)order;

- (void)put:(Byte)b;

- (void)putOnIndex:(NSInteger)theIndex byte:(Byte)b;

- (void)putByteBuffer:(BZByteBuffer *)theByteBuffer;

- (void)putData:(NSData*)data;

- (void)putShort:(short)d;

- (void)putFloat:(float)f;

- (void)putInt:(int)i;

- (void)putLongLong:(long long)l;

- (Byte)get:(int)index;

- (float)getFloat:(int)index;

- (int)getInt:(int)index;

- (NSMutableData *)convertNSMutableData;

@end






























