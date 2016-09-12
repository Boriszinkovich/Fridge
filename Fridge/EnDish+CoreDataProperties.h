//
//  EnDish+CoreDataProperties.h
//  
//
//  Created by User on 11.09.16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "EnDish.h"

NS_ASSUME_NONNULL_BEGIN

@interface EnDish (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *enIngridients;
@property (nullable, nonatomic, retain) NSString *enNameOfDish;
@property (nullable, nonatomic, retain) NSString *enSteps;
@property (nullable, nonatomic, retain) BZDish *toBZDish;

@end

NS_ASSUME_NONNULL_END
