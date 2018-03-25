//
//  TGLDelegateManager.h
//  Fridge
//
//  Created by User on 17.03.2018.
//  Copyright © 2018 BZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TGLGuillotineMenuDelegate;

@interface TGLDelegateManager : NSObject

@property (nonatomic, weak, nullable) id<TGLGuillotineMenuDelegate> strongDelegate;

- (instancetype _Nullable)initWithViewControllers:(NSArray * _Nullable)vcs;

- (void)closeMenuWithIndex:(NSInteger)inex;
- (void)closeMenuWithButton;
- (void)menuHasClosed;
- (void)openMenu;

@end






























