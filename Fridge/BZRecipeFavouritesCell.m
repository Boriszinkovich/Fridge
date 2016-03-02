//
//  BZRecipeFavouritesCell.m
//  Fridge
//
//  Created by User on 04.02.16.
//  Copyright © 2016 BZ. All rights reserved.
//

#import "BZRecipeFavouritesCell.h"

#define cellMargin 10.0
@implementation BZRecipeFavouritesCell

#pragma mark - Class Methods (Public)

//-(void)layoutSubviews{
//
//    [super layoutSubviews];
//    float indentPoints = self.indentationLevel * self.indentationWidth;
//
//     self.contentView.frame = CGRectMake(
//     indentPoints/2,
//     self.contentView.frame.origin.y,
//     self.contentView.frame.size.width - indentPoints,
//     self.contentView.frame.size.height
//     );
//     self.contentView.layer.cornerRadius = 5.0;
//     self.contentView.layer.borderColor = [UIColor grayColor].CGColor;
//     self.contentView.layer.borderWidth = 0.5f;
//     self.layer.cornerRadius = 5.0;
//     self.layer.borderColor = [UIColor grayColor].CGColor;
//     self.layer.borderWidth = 0.5f;
//}

- (void)setFrame:(CGRect)frame
{
    if (frame.origin.x != cellMargin)
    {
        frame.origin.x = cellMargin;
        frame.size.width -= 2 * cellMargin;
    }
    self.contentView.layer.cornerRadius = 5.0;
    self.contentView.layer.borderColor = [UIColor grayColor].CGColor;
    self.contentView.layer.borderWidth = 0.5f;
    [super setFrame:frame];
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

#pragma mark - Methods (Private)

#pragma mark - Standard Methods



- (IBAction)deleteFromFavourite:(id)sender
{
    [self.delegate deleteFromFavouriteWithCell:self];
}

@end






























