//
//  MenuCell.m
//  Fridge
//
//  Created by User on 05.09.16.
//  Copyright © 2016 BZ. All rights reserved.
//

#import "MenuCell.h"

@interface MenuCell ()

@property (nonatomic, strong, nonnull) UIImageView *theMenuImageView;
@property (nonatomic, strong, nonnull) UILabel *theMenuTitleLabel;

@end

const NSString * theMenuCellHeight = @"200 150 110 100 90 85";
const NSString * theMenuImageViewXInset = @"80 60 35 30 25 20";
const NSString * theMenuImageViewMetrick = @"60 55 50 48 45 45";

@implementation MenuCell

#pragma mark - Class Methods (Public)

#pragma mark - Class Methods (Private)

#pragma mark - Init & Dealloc

#pragma mark - Setters (Public)

- (void)setTheMenuName:(NSString *)theMenuName
{
    if (isEqual(_theMenuName, theMenuName))
    {
        return;
    }
    _theMenuName = theMenuName;
    [self createAllViews];
    self.theMenuTitleLabel.text = theMenuName;
    [self.theMenuTitleLabel sizeToFit];
    self.theMenuTitleLabel.theCenterY = theMenuCellHeight.theDeviceValue / 2;
}

- (void)setTheMenuImageName:(NSString *)theMenuImageName
{
    if (isEqual(_theMenuImageName, theMenuImageName))
    {
        return;
    }
    _theMenuImageName = theMenuImageName;
    [self createAllViews];
    self.theMenuImageView.image = [UIImage imageNamed:theMenuImageName];
}

#pragma mark - Getters (Public)

#pragma mark - Setters (Private)

#pragma mark - Getters (Private)

#pragma mark - Lifecycle

#pragma mark - Create Views & Variables

- (void)createAllViews
{
    if (!self.isFirstLoad)
    {
        return;
    }
    self.isFirstLoad = NO;
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView *theMenuImageView = [UIImageView new];
    self.theMenuImageView = theMenuImageView;
    [self.contentView addSubview:theMenuImageView];
    theMenuImageView.theMinX = theMenuImageViewXInset.theDeviceValue;
    theMenuImageView.theWidth = theMenuImageViewMetrick.theDeviceValue;
    theMenuImageView.theHeight = theMenuImageView.theWidth;
    theMenuImageView.theCenterY = theMenuCellHeight.theDeviceValue / 2;
    theMenuImageView.contentMode = UIViewContentModeCenter;
    
    UILabel *theMenuLabel = [UILabel new];
    self.theMenuTitleLabel = theMenuLabel;
    [self.contentView addSubview:theMenuLabel];
    theMenuLabel.theMinX = theMenuImageView.theMaxX + @"60 50 25 20 15 5".theDeviceValue;
    theMenuLabel.font = [UIFont fontWithName:@"Futura-Medium" size:@"32 29 23 22 21 19".theDeviceValue];
    theMenuLabel.textColor = [UIColor whiteColor];
}

#pragma mark - Actions

#pragma mark - Gestures

#pragma mark - Delegates ()

#pragma mark - Methods (Public)

+ (double)methodGetHeight
{
    return theMenuCellHeight.theDeviceValue;
}

#pragma mark - Methods (Private)

#pragma mark - Standard Methods

@end






























