//
//  BZIngridient+CoreDataProperties.h
//  
//
//  Created by User on 11.09.16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "BZIngridient.h"

NS_ASSUME_NONNULL_BEGIN

@interface BZIngridient (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *dateAddedToFridge;
@property (nullable, nonatomic, retain) NSNumber *dishNumber;
@property (nullable, nonatomic, retain) NSString *imageOfIngridient;
@property (nullable, nonatomic, retain) NSNumber *isInFridge;
@property (nullable, nonatomic, retain) NSNumber *isMain;
@property (nullable, nonatomic, retain) NSString *nameOfIngridient;
@property (nullable, nonatomic, retain) NSSet<BZDish *> *arrayOfDishes;
@property (nullable, nonatomic, retain) EnIngridient *toEnIngridient;

@end

@interface BZIngridient (CoreDataGeneratedAccessors)

- (void)addArrayOfDishesObject:(BZDish *)value;
- (void)removeArrayOfDishesObject:(BZDish *)value;
- (void)addArrayOfDishes:(NSSet<BZDish *> *)values;
- (void)removeArrayOfDishes:(NSSet<BZDish *> *)values;

@end

NS_ASSUME_NONNULL_END
