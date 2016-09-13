//
//  BZDish.h
//  
//
//  Created by User on 11.09.16.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BZIngridient, EnDish;

NS_ASSUME_NONNULL_BEGIN

@interface BZDish : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
- (NSString *)methodGetLocalizedName;
- (NSString *)methodGetLocalizedIngridients;
- (NSString *)methodGetLocalizedSteps;

@end

NS_ASSUME_NONNULL_END

#import "BZDish+CoreDataProperties.h"
