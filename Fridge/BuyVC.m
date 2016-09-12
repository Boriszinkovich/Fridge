//
//  BuyVC.m
//  Fridge
//
//  Created by User on 11.09.16.
//  Copyright © 2016 BZ. All rights reserved.
//

#import "BuyVC.h"

@interface BuyVC ()

@property (nonatomic, strong) UIButton *theRestoreButton;
@property (nonatomic, strong) UIButton *theBuyButton;
@property (nonatomic, strong) UIActivityIndicatorView *theRestoreButtonIndicatorView;
@property (nonatomic, strong) UIActivityIndicatorView *theBuyButtonIndicatorView;

@end

@implementation BuyVC

#pragma mark - Class Methods (Public)

#pragma mark - Class Methods (Private)

#pragma mark - Init & Dealloc

#pragma mark - Setters (Public)

#pragma mark - Getters (Public)

#pragma mark - Setters (Private)

#pragma mark - Getters (Private)

#pragma mark - Lifecycle

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNeedsStatusBarAppearanceUpdate];
    if (self.isFirstLoad)
    {
        [self createAllViews];
    }
}

#pragma mark - Create Views & Variables

- (void)createAllViews
{
    if (!self.isFirstLoad)
    {
        return;
    }
    self.isFirstLoad = NO;
    self.navigationController.navigationBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIView *theNavigationView = [UIView new];
    [self.view addSubview:theNavigationView];
    theNavigationView.theWidth = theNavigationView.superview.theWidth;
    theNavigationView.theHeight = 64;
    theNavigationView.backgroundColor = [UIColor getColorWithHexString:keyNavBarColor];
    
    UIButton *theRightButton = [UIButton new];
    [self.view addSubview:theRightButton];
    [theRightButton setTitle:NSLocalizedString(@"Done", @"") forState:UIControlStateNormal];
    [theRightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    theRightButton.titleLabel.font = [UIFont systemFontOfSize:@"25 24 21 20 19 18".theDeviceValue];
    [theRightButton sizeToFit];
    theRightButton.theMaxX = theRightButton.superview.theWidth - 20;
    theRightButton.theCenterY = ([BZExtensionsManager methodGetStatusBarHeight] + 64) / 2;
    [theRightButton addTarget:self action:@selector(actionRightButtonDidTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *theRestoreButton = [UIButton new];
    self.theRestoreButton = theRestoreButton;
    [self.view addSubview:theRestoreButton];
    [theRestoreButton setTitle:NSLocalizedString(@"Restore purchase", @"") forState:UIControlStateNormal];
    [theRestoreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    theRestoreButton.theWidth = theRestoreButton.superview.theWidth - 18 * 2;
    theRestoreButton.theHeight = 38;
    theRestoreButton.theMinX = 18;
    theRestoreButton.theMaxY = theRestoreButton.superview.theHeight - 25;
    theRestoreButton.backgroundColor = [UIColor getColorWithHexString:@"3399FF"];
    theRestoreButton.theHighlightedBackgroundColor = [UIColor whiteColor];
    [theRestoreButton addTarget:self action:@selector(actionRestoreButtonDidTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    UIActivityIndicatorView *theIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.theRestoreButtonIndicatorView = theIndicatorView;
    [self.theRestoreButton addSubview:theIndicatorView];
    theIndicatorView.theWidth = 30;
    theIndicatorView.theHeight = 30;
    theIndicatorView.theCenterX = theIndicatorView.superview.theWidth / 2;
    theIndicatorView.theCenterY = theIndicatorView.superview.theHeight / 2;
    
    UIButton *theBuyButton = [UIButton new];
    self.theBuyButton = theBuyButton;
    [self.view addSubview:theBuyButton];
    [theBuyButton setTitle:NSLocalizedString(@"Buy \"FULL Fridge\" for 0.99$ usd", @"") forState:UIControlStateNormal];
    [theBuyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    theBuyButton.theWidth = theRestoreButton.theWidth;
    theBuyButton.theHeight = 38;
    theBuyButton.theMinX = 18;
    theBuyButton.theMaxY = theRestoreButton.theMinY - 25;
    theBuyButton.backgroundColor = [UIColor getColorWithHexString:@"3399FF"];
    [theBuyButton addTarget:self action:@selector(actionBuyButtonDidTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    UIActivityIndicatorView *theBuyIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.theBuyButtonIndicatorView = theBuyIndicatorView;
    [self.theBuyButton addSubview:theBuyIndicatorView];
    theBuyIndicatorView.theWidth = 30;
    theBuyIndicatorView.theHeight = 30;
    theBuyIndicatorView.theCenterX = theBuyIndicatorView.superview.theWidth / 2;
    theBuyIndicatorView.theCenterY = theBuyIndicatorView.superview.theHeight / 2;
    
    UILabel *theMainLabel = [UILabel new];
    [self.view addSubview:theMainLabel];
    theMainLabel.text = NSLocalizedString(@"Buy \"FULL Fridge\" for 0.99$ usd and have ability to search the best recipes for chosed ingridients", @"");
    theMainLabel.font = [UIFont systemFontOfSize:@"26 24 23 22 20 19".theDeviceValue];
    theMainLabel.textColor = [UIColor blackColor];
    theMainLabel.textAlignment = NSTextAlignmentCenter;
    theMainLabel.numberOfLines = 0;
    theMainLabel.theWidth = theMainLabel.superview.theWidth - @"150 100 60 50 50 40".theDeviceValue;
    [theMainLabel sizeToFit];
    theMainLabel.theCenterX = theMainLabel.superview.theWidth / 2;
    theMainLabel.theCenterY = theMainLabel.superview.theHeight / 2;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGRect rect = self.view.frame;
    [path moveToPoint:CGPointMake(10, self.navigationController.navigationBar.frame.size.height + 30)];
    [path addLineToPoint:CGPointMake(rect.origin.x + 10, rect.size.height - 10)];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [path CGPath];
    shapeLayer.strokeColor = [[UIColor getColorWithHexString:@"FF6600"] CGColor];
    shapeLayer.lineWidth = 2.0;
    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    [self.view.layer addSublayer:shapeLayer];
    path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(10, self.navigationController.navigationBar.frame.size.height + 30)];
    [path addLineToPoint:CGPointMake(rect.size.width - 10, self.navigationController.navigationBar.frame.size.height + 30)];
    shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [path CGPath];
    shapeLayer.strokeColor = [[UIColor getColorWithHexString:@"FF6600"] CGColor];
    shapeLayer.lineWidth = 2.0;
    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    [self.view.layer addSublayer:shapeLayer];
    
    path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(rect.size.width - 10, self.navigationController.navigationBar.frame.size.height + 30)];
    [path addLineToPoint:CGPointMake(rect.size.width - 10, rect.size.height - 10)];
    shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [path CGPath];
    shapeLayer.strokeColor = [[UIColor getColorWithHexString:@"FF6600"] CGColor];
    shapeLayer.lineWidth = 2.0;
    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    [self.view.layer addSublayer:shapeLayer];
    
    path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(rect.origin.x + 10, rect.size.height - 10)];
    [path addLineToPoint:CGPointMake(rect.size.width - 10, rect.size.height - 10)];
    shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [path CGPath];
    shapeLayer.strokeColor = [[UIColor getColorWithHexString:@"FF6600"] CGColor];
    shapeLayer.lineWidth = 2.0;
    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    [self.view.layer addSublayer:shapeLayer];
}

#pragma mark - Actions

- (void)actionRightButtonDidTouchedUpInside:(UIButton *)theButton
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)actionRestoreButtonDidTouchedUpInside:(UIButton *)theButton
{
    theButton.backgroundColor = [UIColor whiteColor];
    theButton.layer.borderWidth = 2;
    theButton.layer.borderColor = [[UIColor getColorWithHexString:@"3399FF"] CGColor];
    [theButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.theBuyButton.backgroundColor = [UIColor whiteColor];
    self.theBuyButton.layer.borderWidth = 2;
    self.theBuyButton.layer.borderColor = [[UIColor getColorWithHexString:@"3399FF"] CGColor];
    [self.theBuyButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    [self.theRestoreButtonIndicatorView startAnimating];
}

- (void)actionBuyButtonDidTouchedUpInside:(UIButton *)theButton
{
    theButton.backgroundColor = [UIColor whiteColor];
    theButton.layer.cornerRadius = 2;
    theButton.layer.borderColor = [[UIColor getColorWithHexString:@"3399FF"] CGColor];
    
    self.theRestoreButton.backgroundColor = [UIColor whiteColor];
    self.theRestoreButton.layer.cornerRadius = 2;
    self.theRestoreButton.layer.borderColor = [[UIColor getColorWithHexString:@"3399FF"] CGColor];
    [self.theRestoreButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
}

#pragma mark - Gestures

#pragma mark - Delegates (UIWebViewDelegate)

#pragma mark - Methods (Public)

#pragma mark - Methods (Private)

- (void)methodStartRestoreButtonAction
{
    
}

#pragma mark - Standard Methods

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end






























