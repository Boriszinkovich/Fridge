//
//  BZRecipeFavouritesCell.h
//  Fridge
//
//  Created by User on 04.02.16.
//  Copyright © 2016 BZ. All rights reserved.
//

#import "BZRecipeViewController.h"
#import "BZDeleteFromFavouriteProtocol.h"
@interface BZRecipeFavouritesCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *recipeName;
@property (strong, nonatomic) IBOutlet UIImageView *recipeImage;
@property (strong, nonatomic) IBOutlet UILabel *recipeDescription;
@property (weak, nonatomic) IBOutlet UIButton *recipeButton;
@property (strong, nonatomic) NSString *originalName;
@property (weak, nonatomic) id <BZDeleteFromFavouriteProtocol> delegate;

- (IBAction)deleteFromFavourite:(id)sender;

@end






























