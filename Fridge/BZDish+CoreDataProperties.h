//
//  BZDish+CoreDataProperties.h
//  
//
//  Created by User on 06.02.16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "BZDish.h"

NS_ASSUME_NONNULL_BEGIN

@interface BZDish (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *countOfIngridients;
@property (nullable, nonatomic, retain) NSDate *dateAddedToFavourites;
@property (nullable, nonatomic, retain) NSString *image;
@property (nullable, nonatomic, retain) NSString *ingridients;
@property (nullable, nonatomic, retain) NSNumber *isFavourite;
@property (nullable, nonatomic, retain) NSString *nameOfDish;
@property (nullable, nonatomic, retain) NSString *steps;
@property (nullable, nonatomic, retain) NSNumber *countOfMainIngridients;
@property (nullable, nonatomic, retain) NSSet<BZIngridient *> *arrayOfIngridients;

@end

@interface BZDish (CoreDataGeneratedAccessors)

- (void)addArrayOfIngridientsObject:(BZIngridient *)value;
- (void)removeArrayOfIngridientsObject:(BZIngridient *)value;
- (void)addArrayOfIngridients:(NSSet<BZIngridient *> *)values;
- (void)removeArrayOfIngridients:(NSSet<BZIngridient *> *)values;

@end

NS_ASSUME_NONNULL_END
