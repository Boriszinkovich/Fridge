//
//  TGLDelegateManager.m
//  Fridge
//
//  Created by User on 17.03.2018.
//  Copyright © 2018 BZ. All rights reserved.
//

#import "TGLDelegateManager.h"

#import "TGLGuillotineMenu.h"

typedef NS_ENUM(NSUInteger, TGLScanningState) {
    TGLScanningStateOpen,
    TGLScanningStateNone,
    TGLScanningStateClose
};

@interface TGLDelegateManager ()

@property (nonatomic, weak) NSArray *vcs;
@property (nonatomic, assign) NSTimeInterval closeDelay;
@property (nonatomic, assign) NSTimeInterval openDelay;
@property (nonatomic, assign) TGLScanningState scanningState;
@property (nonatomic, assign) NSInteger lastChosedIndex;

@end

@implementation TGLDelegateManager

#pragma mark - Class Methods (Public)

#pragma mark - Class Methods (Private)

#pragma mark - Init & Dealloc

- (instancetype _Nullable)initWithViewControllers:(NSArray * _Nullable)vcs
{
    self = [super init];
    if (self)
    {
        _vcs = vcs;
        _scanningState = TGLScanningStateNone;
        switch (UI_USER_INTERFACE_IDIOM()) 
        {
            case UIUserInterfaceIdiomPad:
            {
                _closeDelay = 1;
                _openDelay = 2;
            }
                break;
            case UIUserInterfaceIdiomPhone:
            {
                _closeDelay = 0.45;
                CGFloat delayCoef = [UIScreen mainScreen].bounds.size.height / 568;
//                if (@available(iOS 11, *))
//                {
//                    if ([UIScreen mainScreen].bounds.size.height == 568)
//                    {
//                        _closeDelay = 0.45; // Will make 0.45 for iPhone 5s on latest versions
//                    }
//                }
                _openDelay = 0.8 *delayCoef;
            }
                break;
            default:
            {
                assert(nil);
            }
                break;
        }
    }
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

- (void)closeMenuWithIndex:(NSInteger)index
{
    self.lastChosedIndex = index;
    if ([self.strongDelegate respondsToSelector:@selector(selectedMenuItemAtIndex:)]) {
        [self.strongDelegate selectedMenuItemAtIndex:index];
    }
    [self methodStartScanningTimeoutMonitor:TGLScanningStateClose];
}

- (void)closeMenuWithButton
{
    [self methodStartScanningTimeoutMonitor:TGLScanningStateClose];
}

- (void)openMenu
{
    [[NSNotificationCenter defaultCenter] postNotificationName:keyNotifMenuWillOpen object:nil];
    [self methodStartScanningTimeoutMonitor:TGLScanningStateOpen];
}

- (void)menuHasClosed
{
    [self respondMenuDidCloseWithIndex:self.lastChosedIndex];
}

#pragma mark - Methods (Private)

// should run only on the main thread
- (void)methodStartScanningTimeoutMonitor:(TGLScanningState)scanningState
{
    if (scanningState == TGLScanningStateNone)
    {
        BZAssert(NO);
        return;
    }
    [self methodCancelScanningTimeoutMonitor];
    self.scanningState = scanningState;
    NSTimeInterval delay = scanningState == TGLScanningStateOpen ? _openDelay : _closeDelay;
    [self performSelector:@selector(methodScanningDidTimeout)
               withObject:nil
               afterDelay:delay];
}

// should run only on the main thread
- (void)methodCancelScanningTimeoutMonitor
{
    self.scanningState = TGLScanningStateNone;
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(methodScanningDidTimeout)
                                               object:nil];
}

// should run only on the main thread
- (void)methodScanningDidTimeout
{
    TGLScanningState state = self.scanningState;
    if (state == TGLScanningStateNone)
    {
        return;
    }
    [self methodCancelScanningTimeoutMonitor];
    switch (state)
    {
        case TGLScanningStateOpen:
        {
            [self respondMenuDidOpen];
        }
            break;
        case TGLScanningStateClose:
        {
            [self respondMenuDidCloseWithIndex:self.lastChosedIndex];
        }
            break;
        case TGLScanningStateNone:
            break;
    }
}

- (void)respondMenuDidOpen
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.vcs];
    [array addObject:self.strongDelegate];
    for (id delegate in array)
    {
        if ([delegate conformsToProtocol: @protocol(TGLGuillotineMenuDelegate)])
        {
            id<TGLGuillotineMenuDelegate> menuDelegate = delegate;
            if ([menuDelegate respondsToSelector:@selector(menuDidOpen)])
            {
                [menuDelegate menuDidOpen];
            }
        }
    }
}

- (void)respondMenuDidCloseWithIndex:(NSInteger)index
{
    if ([self.strongDelegate respondsToSelector:@selector(menuDidClose)])
    {
        [self.strongDelegate menuDidClose];
    }
    id delegate = self.vcs[self.lastChosedIndex];
    if ([delegate conformsToProtocol: @protocol(TGLGuillotineMenuDelegate)])
    {
        id<TGLGuillotineMenuDelegate> menuDelegate = delegate;
        if ([menuDelegate respondsToSelector:@selector(menuDidOpen)])
        {
            [menuDelegate menuDidClose];
        }
    }
}

#pragma mark - Standard Methods

@end






























