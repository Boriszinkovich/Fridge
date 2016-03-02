//
//  BZDetailDismissedProtocol.h
//  Fridge
//
//  Created by User on 08.02.16.
//  Copyright © 2016 BZ. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@protocol BZDetailDismissedProtocol <NSObject>

@required

- (void) detailViewDismissed;
- (void) changedFavourite:(BOOL)isFavourite;

@end






























