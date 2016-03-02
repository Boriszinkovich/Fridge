//
//  BZRecipeStepsCell.m
//  Fridge
//
//  Created by User on 08.02.16.
//  Copyright © 2016 BZ. All rights reserved.
//

#import "BZRecipeStepsCell.h"

@implementation BZRecipeStepsCell

#pragma mark - Class Methods (Public)

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.theRecipeStepsLabel setNeedsLayout];
    [self.theRecipeStepsLabel layoutIfNeeded];
}

#pragma mark - Class Methods (Private)

#pragma mark - Init & Dealloc

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        BZDynamicHeightUILabel *theLabel = [[BZDynamicHeightUILabel alloc] init];
        [self.contentView addSubview:theLabel];
        self.theRecipeStepsLabel = theLabel;
        self.theRecipeStepsLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.theRecipeStepsLabel.numberOfLines = 0;
        self.theRecipeStepsLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.theRecipeStepsLabel.font = [UIFont fontWithName:@"System" size:15];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-25-[bodyLabel]-25-|" options:0 metrics:nil views:@{ @"bodyLabel": self.theRecipeStepsLabel }]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[bodyLabel]-5-|" options:0 metrics:nil views:@{ @"bodyLabel": self.theRecipeStepsLabel }]];
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

#pragma mark - Methods (Private)

#pragma mark - Standard Methods

@end






























