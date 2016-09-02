//
//  RecipeCell.h
//  Fridge
//
//  Created by User on 24.06.16.
//  Copyright © 2016 BZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RecipeCellProtocol;

@interface RecipeCell : UITableViewCell

@property (nonatomic, strong, nonnull) NSString *theRecipeName;
@property (nonatomic, strong, nonnull) NSString *theRecipeDescription;
@property (nonatomic, strong, nonnull) UIImage *theRecipeImage;
@property (nonatomic, strong, nonnull) UIImage *theRecipeButtonImage;
@property (nonatomic, strong, nonnull) UIButton *theRightButton;
@property (nonatomic, weak, nullable) id<RecipeCellProtocol> theDelegate;

- (CGFloat)methodGetHeight;

@end

@protocol RecipeCellProtocol <NSObject>

@required

- (void)recipeCellRightButtonWasTapped:(RecipeCell * _Nonnull)theCell;

@end





























