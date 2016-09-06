//
//  RecipeCell.m
//  Fridge
//
//  Created by User on 24.06.16.
//  Copyright © 2016 BZ. All rights reserved.
//

#import "RecipeCell.h"

#define cellMargin 10.0

@interface RecipeCell ()

@property (nonatomic, strong, nonnull) UILabel *theTitleLabel;
@property (nonatomic, strong, nonnull) UIImageView *theRecipeImageView;

@end

const NSString * theLabelsMaxXInset = @"28 25 20 18 15 12";

@implementation RecipeCell

#pragma mark - Class Methods (Public)

#pragma mark - Class Methods (Private)

#pragma mark - Init & Dealloc

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self methodInitRecipeCell];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self methodInitRecipeCell];
    }
    return self;
}

- (void)methodInitRecipeCell
{
    
}

#pragma mark - Setters (Public)

- (void)setTheRecipeName:(NSString *)theRecipeName
{
    if (isEqual(theRecipeName, _theRecipeName))
    {
        return;
    }
    _theRecipeName = theRecipeName;
    [self createAllViews];
    self.theTitleLabel.text = theRecipeName;
    self.theTitleLabel.theWidth = self.theRightButton.theMinX - self.theTitleLabel.theMinX - theLabelsMaxXInset.theDeviceValue;
    [self.theTitleLabel sizeToFit];
}

//- (void)setTheRecipeButtonImage:(UIImage *)theRecipeButtonImage
//{
//    if (isEqual(_theRecipeButtonImage, theRecipeButtonImage))
//    {
//        return;
//    }
//    _theRecipeButtonImage = theRecipeButtonImage;
//    self.theReCip
//    self.theRecipeImageView.image = theRecipeButtonImage;
//    self.theRecipeImageView.contentMode = UIViewContentModeScaleToFill;
//    self.theRecipeImageView.theMinY = self.theTitleLabel.theMaxY + @"9 8 6 5 5 5".theDeviceValue;
//}

- (void)setTheRecipeImage:(UIImage *)theRecipeImage
{
    if (isEqual(_theRecipeImage, theRecipeImage))
    {
        return;
    }
    _theRecipeImage = theRecipeImage;
    [self createAllViews];
    self.theRecipeImageView.image = theRecipeImage;
    self.theRecipeImageView.contentMode = UIViewContentModeScaleToFill;
    self.theRecipeImageView.theMinY = self.theTitleLabel.theMaxY + @"9 8 6 5 5 5".theDeviceValue;
}

- (void)setTheRecipeDescription:(NSString *)theRecipeDescription
{
    if (isEqual(_theRecipeDescription, theRecipeDescription))
    {
        return;
    }
    _theRecipeDescription = theRecipeDescription;
    [self createAllViews];
    self.theDescriptionLabel.text = theRecipeDescription;
    self.theDescriptionLabel.theMinX = self.theRecipeImageView.theMaxX + 10;
    self.theDescriptionLabel.theMinY = self.theRecipeImageView.theMinY + @"5 3 2 2 2 2".theDeviceValue;
    NSLog(@"%f", self.theRightButton.theMinY);
    self.theDescriptionLabel.theWidth = self.theRightButton.theMinX - theLabelsMaxXInset.theDeviceValue - self.theDescriptionLabel.theMinX;
    [self.theDescriptionLabel sizeToFit];

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
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    UIButton *theRightButton = [UIButton new];
    [self.contentView addSubview:theRightButton];
    self.theRightButton = theRightButton;
    theRightButton.theHeight = @"48 47 44 44 44 40".theDeviceValue;
    theRightButton.theWidth = theRightButton.theHeight;
    theRightButton.theMinY = @"12 10 9 8 8 8".theDeviceValue;
    theRightButton.theMaxX = theRightButton.superview.theWidth - @"20 18 16 15 14 14".theDeviceValue;
    [theRightButton addTarget:self action:@selector(actionRightButtonDidTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *theTitleLabel = [UILabel new];
    [self.contentView addSubview:theTitleLabel];
    self.theTitleLabel = theTitleLabel;
    self.theTitleLabel.theMinX = @"20 18 16 15 15 14".theDeviceValue;
    theTitleLabel.theMinY = @"6 6 5 4 4 4".theDeviceValue;
    theTitleLabel.theWidth = theRightButton.theMinX - theTitleLabel.theMinX - @"30 28 26 22 20 20".theDeviceValue;
    theTitleLabel.numberOfLines = 0;
    theTitleLabel.font = [UIFont systemFontOfSize:17];
    
    UIImageView *theRecipeImageView = [UIImageView new];
    [self.contentView addSubview:theRecipeImageView];
    self.theRecipeImageView = theRecipeImageView;
    theRecipeImageView.theWidth = 80;
    theRecipeImageView.theHeight = 80;
    theRecipeImageView.theMinX = 16;
    
    UILabel *theDescriptionLabel = [UILabel new];
    [self.contentView addSubview:theDescriptionLabel];
    self.theDescriptionLabel = theDescriptionLabel;
    theDescriptionLabel.numberOfLines = 0;
    theDescriptionLabel.font = [UIFont systemFontOfSize:10];
    
    self.contentView.layer.cornerRadius = 5.0;
    self.contentView.layer.borderColor = [UIColor grayColor].CGColor;
    self.contentView.layer.borderWidth = 0.5f;
}

#pragma mark - Actions

- (void)actionRightButtonDidTouchedUpInside:(UIButton *)theButton
{
    if ([self.theDelegate respondsToSelector:@selector(recipeCellRightButtonWasTapped:)])
    {
        [self.theDelegate recipeCellRightButtonWasTapped:self];
    }
}

#pragma mark - Gestures

#pragma mark - Delegates ()

#pragma mark - Methods (Public)

- (CGFloat)methodGetHeight
{
    double theHeight = self.theTitleLabel.theMinY + self.theTitleLabel.theHeight + 16;
    if (self.theRecipeImageView.theHeight > self.theDescriptionLabel.theHeight)
    {
        theHeight = theHeight + 10 + self.theRecipeImageView.theHeight;
    }
    else
    {
        theHeight = theHeight + 10 + self.theDescriptionLabel.theHeight;
    }
    return theHeight;
}

#pragma mark - Methods (Private)

#pragma mark - Standard Methods

- (void)setFrame:(CGRect)frame
{
    if (frame.origin.x != cellMargin)
    {
        frame.origin.x = cellMargin;
        frame.size.width -= 2 * cellMargin;
    }
    [super setFrame:frame];
}

@end






























