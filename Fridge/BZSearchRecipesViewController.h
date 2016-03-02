//
//  BZSearchRecipesViewController.h
//  Fridge
//
//  Created by User on 06.02.16.
//  Copyright © 2016 BZ. All rights reserved.
//

#import "BZRecipeViewController.h"
#import "BZAddToFavouriteProtocol.h"

@interface BZSearchRecipesViewController : BZRecipeViewController<BZAddToFavouriteProtocol>

@property (strong,nonatomic) NSArray *theIngridientsArray;
@property (assign, nonatomic) NSInteger theCurrentSelecterRaw;

@end






























