//
//  BZDish.h
//  
//
//  Created by User on 06.02.16.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BZIngridient;

NS_ASSUME_NONNULL_BEGIN
static NSString *theDishFavouriteKey = @"theDishFavouriteKey";

@interface BZDish : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "BZDish+CoreDataProperties.h"
