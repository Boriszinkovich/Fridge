//
//  BZDeleteFromFavouriteProtocol.h
//  Fridge
//
//  Created by User on 04.02.16.
//  Copyright © 2016 BZ. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class BZRecipeFavouritesCell;
@protocol BZDeleteFromFavouriteProtocol <NSObject>

@required
-(void) deleteFromFavouriteWithCell: (BZRecipeFavouritesCell *) cell;

@end





























