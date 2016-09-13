//
//  HideRecipeCell.h
//  Fridge
//
//  Created by Boris Zinkovich on 08.09.16.
//  Copyright © 2016 BZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HideRecipeCell : UITableViewCell

@property (nonatomic, strong, nonnull) NSString *theRecipeName;
@property (nonatomic, strong, nonnull) NSString *theOriginalRecipeName;
@property (nonatomic, strong, nonnull) NSString *theRecipeDescription;
@property (nonatomic, strong, nonnull) UIImage *theRecipeImage;
@property (nonatomic, strong, nonnull) UIImage *theRecipeButtonImage;
@property (nonatomic, strong, nonnull) UIButton *theRightButton;
@property (nonatomic, strong, nonnull) UILabel *theDescriptionLabel;

- (CGFloat)methodGetHeight;

@end































