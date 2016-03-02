//
//  RecipeViewController.h
//  Fridge
//
//  Created by User on 03.02.16.
//  Copyright © 2016 BZ. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

#import "BZDetailDismissedProtocol.h"

@interface BZRecipeViewController : UITableViewController <BZDetailDismissedProtocol>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSOperation *currentOperation;
@property (strong, nonatomic) NSMutableArray *arrayOfDishes;
@property (strong, nonatomic) NSMutableSet *setWithDishes;
@property (assign, nonatomic) NSInteger maxNumberOfDishes;
@property (assign, nonatomic) BOOL nonFirstLoad;
@property (assign, nonatomic) BOOL isLoading;

- (void)loadData;

@end

static NSString* recipeCellIdentifier = @"recipeCellIdentifier";
const CGFloat cellSpacing = 20;
const NSInteger recipesLoadNumber = 20;





























