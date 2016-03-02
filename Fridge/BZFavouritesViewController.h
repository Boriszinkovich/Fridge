//
//  BZFavouritesViewController.h
//  Fridge
//
//  Created by User on 04.02.16.
//  Copyright © 2016 BZ. All rights reserved.
//

#import "BZRecipeViewController.h"
#import "BZDeleteFromFavouriteProtocol.h"

@interface BZFavouritesViewController : BZRecipeViewController <BZDeleteFromFavouriteProtocol>

@property (assign, nonatomic) NSInteger currentSelecterRaw;

@end






























