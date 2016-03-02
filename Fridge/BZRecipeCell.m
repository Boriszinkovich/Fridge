//
//  RecipeCell.m
//  Fridge
//
//  Created by User on 03.02.16.
//  Copyright © 2016 BZ. All rights reserved.
//

#import "BZRecipeCell.h"

#define cellMargin 10.0

@implementation BZRecipeCell

#pragma mark - Class Methods (Public)

- (void)setFrame:(CGRect)frame
{
    if (frame.origin.x != cellMargin)
    {
        frame.origin.x = cellMargin;
        frame.size.width -= 2 * cellMargin;
    }
    [super setFrame:frame];
}

#pragma mark - Class Methods (Private)

#pragma mark - Init & Dealloc

- (void)awakeFromNib
{
    // Initialization code
    
    self.contentView.layer.cornerRadius = 5.0;
    self.contentView.layer.borderColor = [UIColor grayColor].CGColor;
    self.contentView.layer.borderWidth = 0.5f;
    [self.recipeButton setImage:[UIImage imageNamed:@"likeEmpty.png"] forState:UIControlStateNormal];
    [self.recipeButton setImage:[UIImage imageNamed:@"likeFull.png"] forState:UIControlStateSelected];
    
}

#pragma mark - Setters (Public)

#pragma mark - Getters (Public)

#pragma mark - Setters (Private)

#pragma mark - Getters (Private)

#pragma mark - Lifecycle

//-(void)layoutSubviews
//{
//    
//    [super layoutSubviews];
//    [self.recipeName setNeedsLayout];
//    [self.recipeName layoutIfNeeded];
//    [self.recipeDescription setNeedsLayout];
//    [self.recipeDescription layoutIfNeeded];
//    
//    float indentPoints = self.indentationLevel * self.indentationWidth;
//    
//    self.contentView.frame = CGRectMake(
//                                        indentPoints/2,
//                                        self.contentView.frame.origin.y,
//                                        self.contentView.frame.size.width - indentPoints,
//                                        self.contentView.frame.size.height
//                                        );
//    self.contentView.layer.cornerRadius = 5.0;
//    self.contentView.layer.borderColor = [UIColor grayColor].CGColor;
//    self.contentView.layer.borderWidth = 0.5f;
//    self.layer.cornerRadius = 5.0;
//    self.layer.borderColor = [UIColor grayColor].CGColor;
//    self.layer.borderWidth = 0.5f;
//}

#pragma mark - Create Views & Variables

#pragma mark - Actions

- (IBAction)addToFavourite:(id)sender
{
    [self.theDelegate addToFavouriteWithCell:self];
}

#pragma mark - Gestures

#pragma mark - Delegates ()

#pragma mark - Methods (Public)

#pragma mark - Methods (Private)

#pragma mark - Standard Methods

@end






























