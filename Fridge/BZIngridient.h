//
//  BZIngridient.h
//  
//
//  Created by User on 11.09.16.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BZDish, EnIngridient;

NS_ASSUME_NONNULL_BEGIN

@interface BZIngridient : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

- (NSString *)methodGetLocalizedName;

@end

NS_ASSUME_NONNULL_END

#import "BZIngridient+CoreDataProperties.h"
