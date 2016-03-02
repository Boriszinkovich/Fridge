//
//  RecipeCell.h
//  Fridge
//
//  Created by User on 03.02.16.
//  Copyright © 2016 BZ. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BZAddToFavouriteProtocol.h"

@interface BZRecipeCell : UITableViewCell

@property (weak, nonatomic) id <BZAddToFavouriteProtocol> theDelegate;
@property (strong, nonatomic) NSString *theOriginalNameString;
@property (weak, nonatomic) IBOutlet UILabel *recipeName;
@property (weak, nonatomic) IBOutlet UIImageView *recipeImage;
@property (weak, nonatomic) IBOutlet UILabel *recipeDescription;
@property (weak, nonatomic) IBOutlet UIButton *recipeButton;

- (IBAction)addToFavourite:(id)sender;

@end






























