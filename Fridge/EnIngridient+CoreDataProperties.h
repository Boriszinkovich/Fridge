//
//  EnIngridient+CoreDataProperties.h
//  
//
//  Created by User on 11.09.16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "EnIngridient.h"

NS_ASSUME_NONNULL_BEGIN

@interface EnIngridient (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *enNameOfIngridient;
@property (nullable, nonatomic, retain) BZIngridient *toBZIngridient;

@end

NS_ASSUME_NONNULL_END
