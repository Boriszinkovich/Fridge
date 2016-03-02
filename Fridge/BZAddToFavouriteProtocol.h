//
//  BZAddToFavouriteProtocol.h
//  Fridge
//
//  Created by User on 04.02.16.
//  Copyright © 2016 BZ. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@class BZRecipeCell;
@protocol BZAddToFavouriteProtocol <NSObject>

@required

-(void) addToFavouriteWithCell: (BZRecipeCell*) cell;

@end
