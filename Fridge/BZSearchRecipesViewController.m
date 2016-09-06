//
//  BZSearchRecipesViewController.m
//  Fridge
//
//  Created by User on 06.02.16.
//  Copyright © 2016 BZ. All rights reserved.
//

#import "BZSearchRecipesViewController.h"

#import "BZRecipeCell.h"
#import "BZDish.h"
#import "BZDetailReceptViewController.h"
#import "BZIngridient.h"
#import "RecipeCell.h"

#import <MagicalRecord/MagicalRecord.h>

@interface BZSearchRecipesViewController() <RecipeCellProtocol>

@property (strong, nonatomic) UIColor *myColorBlack;
@property (strong, nonatomic) UIColor *myColorGreen;

@end

@implementation BZSearchRecipesViewController

#pragma mark - Class Methods (Public)

#pragma mark - Class Methods (Private)

#pragma mark - Init & Dealloc

#pragma mark - Setters (Public)

#pragma mark - Getters (Public)

#pragma mark - Setters (Private)

#pragma mark - Getters (Private)

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.myColorBlack = [UIColor colorWithRed:39.f / 255.f
                                        green:39.f / 255.f
                                         blue:39.f / 255.f alpha:1.0];
    
    self.myColorGreen = [UIColor colorWithRed:176.f / 255.f
                                        green:191.f / 255.f
                                         blue:90.f / 255.f alpha:1.0];
    self.tableView.contentInset = UIEdgeInsetsMake(0,0,0,0);
//    [self.tableView registerNib:[UINib nibWithNibName:@"BZAllRecipesCell" bundle:nil] forCellReuseIdentifier:recipeCellIdentifier];
    self.arrayOfDishes = [NSMutableArray array];
    self.tableView.estimatedRowHeight = 80;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.tableView setNeedsLayout];
    [self.tableView layoutIfNeeded];
    [self.navigationItem setTitle:@"Рецепты"];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

    [self methodLoadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    NSLog(@"%ld",(long)self.tableView.frame.origin.y);
    self.edgesForExtendedLayout = UIRectEdgeNone;
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)])
    {
        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
        NSArray *list=self.navigationController.navigationBar.subviews;
        for (id obj in list)
        {
            if ([obj isKindOfClass:[UIImageView class]])
            {
                UIImageView *imageView=(UIImageView *)obj;
                imageView.alpha=1;
            }
        }
        
    }
    UINavigationBar* theNavigationBar = self.navigationController.navigationBar;
    [theNavigationBar setTranslucent:YES];
    theNavigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    [theNavigationBar setBackgroundImage:[UIImage imageNamed:@"patternNav"]
                 forBarMetrics:UIBarMetricsDefault];
    [theNavigationBar setShadowImage:[[UIImage alloc] init]];
    [self setNeedsStatusBarAppearanceUpdate];
    if (!self.isLoading)
    {
        __weak BZSearchRecipesViewController* theWeakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                       {
                           
                           sleep(1);
                           
                           
                           dispatch_async(dispatch_get_main_queue(), ^
                                          {
                                              [theWeakSelf.tableView reloadData];
                                          });
                       });
        
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - Create Views & Variables

#pragma mark - Actions

- (void) detailViewDismissed
{
    
}

- (void) changedFavourite:(BOOL)theIsFavourite
{
//    [super changedFavourite:theIsFavourite];
//    BZRecipeCell* theBZRecipeCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0
//                                                                                             inSection:self.theCurrentSelecterRaw]];
//    if (theIsFavourite)
//    {
//        [theBZRecipeCell.recipeButton setSelected:YES];
//    }
//    else
//    {
//       [theBZRecipeCell.recipeButton setSelected:NO];
//    }
    [super changedFavourite:theIsFavourite];
    RecipeCell *theCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.theCurrentSelecterRaw]];
    if (theIsFavourite)
    {
        [theCell.theRightButton setSelected:YES];
    }
    else
    {
        [theCell.theRightButton setSelected:NO];
    }
}

#pragma mark - Gestures

#pragma mark 

- (void)recipeCellRightButtonWasTapped:(RecipeCell * _Nonnull)theCell
{
    if ([theCell.theRightButton isSelected])
    {
        [theCell.theRightButton setSelected:NO];
        NSPredicate *thePredicate = [NSPredicate predicateWithFormat:@"nameOfDish == %@", theCell.theRecipeName];
        NSArray *theDishesArray = [BZDish MR_findAllWithPredicate:thePredicate];
        BZDish *theBZDish = [theDishesArray objectAtIndex:0];
        theBZDish.isFavourite = [NSNumber numberWithBool:NO];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }
    else
    {
        [theCell.theRightButton setSelected:YES];
        NSPredicate* thePredicate = [NSPredicate predicateWithFormat:@"nameOfDish == %@", theCell.theRecipeName];
        NSArray* theDishesArray = [BZDish MR_findAllWithPredicate:thePredicate];
        BZDish* theBZDish = theDishesArray[0];
        theBZDish.isFavourite= [NSNumber numberWithBool:YES];
        theBZDish.dateAddedToFavourites = [NSDate date];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }
}

#pragma mark - Delegates (UITableViewDelegate & UIDataSource)

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecipeCell *cell = [RecipeCell new];
    if (indexPath.section > ([self.arrayOfDishes count]-1))
    {
        return 100;
    }
    BZDish *dish = [self.arrayOfDishes objectAtIndex:indexPath.section];
    cell.theRecipeName = dish.nameOfDish;
    cell.theRecipeImage = [UIImage imageNamed:[NSString stringWithFormat:@"c%@",dish.image]];
    cell.theRecipeDescription = dish.ingridients;
    double theHeight = [cell methodGetHeight];
    return theHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    BZRecipeCell* theBZRecipeCell = (BZRecipeCell*)[tableView dequeueReusableCellWithIdentifier:recipeCellIdentifier];
//    if (!theBZRecipeCell)
//    {
//        theBZRecipeCell = [[BZRecipeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:recipeCellIdentifier];
//        
//    }
//    BZDish *theCurrentBZDish = [self.arrayOfDishes objectAtIndex:indexPath.section];
//    theBZRecipeCell.theOriginalNameString = theCurrentBZDish.nameOfDish;
//    theBZRecipeCell.recipeName.text = theCurrentBZDish.nameOfDish;
//    theBZRecipeCell.recipeDescription.text = theCurrentBZDish.ingridients;
//    NSString* theIngridientNameString = theCurrentBZDish.ingridients;
//    theBZRecipeCell.recipeImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"c%@",theCurrentBZDish.image]];
//    theBZRecipeCell.recipeImage.contentMode = UIViewContentModeScaleToFill;
//    theBZRecipeCell.theDelegate = self;
//    if ([theCurrentBZDish.isFavourite boolValue])
//    {
//        [theBZRecipeCell.recipeButton setSelected:YES];
//    }
//    else
//    {
//        [theBZRecipeCell.recipeButton setSelected:NO];
//    }
    RecipeCell *cell = (RecipeCell*)[tableView dequeueReusableCellWithIdentifier:recipeCellIdentifier];
    if (!cell)
    {
        cell = [[RecipeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:recipeCellIdentifier];
    }
    cell.theDelegate = self;
    if (indexPath.section > ([self.arrayOfDishes count]-1))
    {
        return cell;
    }
    BZDish *dish = [self.arrayOfDishes objectAtIndex:indexPath.section];
    cell.theRecipeName = dish.nameOfDish;
    cell.theRecipeImage = [UIImage imageNamed:[NSString stringWithFormat:@"c%@",dish.image]];
    cell.theRecipeDescription = dish.ingridients;
    [cell.theRightButton setImage:[UIImage imageNamed:@"likeEmpty"] forState:UIControlStateNormal];
    [cell.theRightButton setImage:[UIImage imageNamed:@"likeFull"] forState:UIControlStateSelected];
    if ([dish.isFavourite boolValue])
    {
        [cell.theRightButton setSelected:YES];
    }
    else
    {
        [cell.theRightButton setSelected:NO];
    }
        NSString* theIngridientNameString = dish.ingridients;

//    NSLog(@"%f",theBZRecipeCell.recipeDescription.frame.size.width);
    NSMutableSet *theIngridientsIntersectionNSSet = [NSMutableSet setWithArray:self.theIngridientsArray];
    [theIngridientsIntersectionNSSet intersectSet:dish.arrayOfIngridients];
    NSMutableAttributedString *theAttributedString = [[NSMutableAttributedString alloc]  initWithString:theIngridientNameString];
    for (BZIngridient* ingredient in theIngridientsIntersectionNSSet)
    {
        NSRange theIngridientNameRange = [theIngridientNameString rangeOfString:ingredient.nameOfIngridient options:NSCaseInsensitiveSearch];
        if (theIngridientNameRange.location == NSNotFound)
        {
            theIngridientNameRange = [theIngridientNameString rangeOfString:[ingredient.nameOfIngridient substringToIndex:[ingredient.nameOfIngridient length] - 1]
                                          options:NSCaseInsensitiveSearch];
        }
        if (theIngridientNameRange.location == NSNotFound)
        {
           theIngridientNameRange = [theIngridientNameString rangeOfString:[ingredient.nameOfIngridient substringToIndex:[ingredient.nameOfIngridient length] - 2]
                                         options:NSCaseInsensitiveSearch];
        }
        if (theIngridientNameRange.location == NSNotFound)
        {
            NSArray* words = [ingredient.nameOfIngridient componentsSeparatedByString:@" "];
            if ([words count] > 1)
            {
                NSString* firstWord = [words objectAtIndex:0];
                NSString* secondWord = [words objectAtIndex:0];
                theIngridientNameRange = [theIngridientNameString rangeOfString:firstWord options:NSCaseInsensitiveSearch];
                if (theIngridientNameRange.location == NSNotFound)
                {
                    theIngridientNameRange = [theIngridientNameString rangeOfString:[firstWord substringToIndex:[firstWord length] - 1] options:NSCaseInsensitiveSearch];
                }
                if (theIngridientNameRange.location == NSNotFound)
                {
                    theIngridientNameRange = [theIngridientNameString rangeOfString:[firstWord substringToIndex:[firstWord length] - 2] options:NSCaseInsensitiveSearch];
                }
                [theAttributedString addAttribute:NSForegroundColorAttributeName value:self.myColorGreen range:theIngridientNameRange];
                
                [theAttributedString addAttribute:NSBackgroundColorAttributeName value:self.myColorBlack range:theIngridientNameRange];
                theIngridientNameRange = [theIngridientNameString rangeOfString:secondWord options:NSCaseInsensitiveSearch];
                if (theIngridientNameRange.location == NSNotFound)
                {
                    theIngridientNameRange = [theIngridientNameString rangeOfString:[secondWord substringToIndex:[secondWord length] - 1] options:NSCaseInsensitiveSearch];
                }
                if (theIngridientNameRange.location == NSNotFound)
                {
                    theIngridientNameRange = [theIngridientNameString rangeOfString:[secondWord substringToIndex:[secondWord length] - 2] options:NSCaseInsensitiveSearch];
                }
                [theAttributedString addAttribute:NSForegroundColorAttributeName value:self.myColorGreen range:theIngridientNameRange];
                
                [theAttributedString addAttribute:NSBackgroundColorAttributeName value:self.myColorBlack range:theIngridientNameRange];
            }
        }
        else
        {
            [theAttributedString addAttribute:NSForegroundColorAttributeName value:self.myColorGreen range:theIngridientNameRange];
            
            [theAttributedString addAttribute:NSBackgroundColorAttributeName value:self.myColorBlack range:theIngridientNameRange];
        }
        
    }
    cell.theDescriptionLabel.attributedText= theAttributedString;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    BZRecipeCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
//    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"nameOfDish == %@", cell.theOriginalNameString];
//    NSArray* dishes = [BZDish MR_findAllWithPredicate:predicate];
//    BZDish* dish = [dishes objectAtIndex:0];
//    BZDetailReceptViewController* detailRecept = [[BZDetailReceptViewController alloc] init];
//    detailRecept.dish = dish;
//    detailRecept.delegate = self;
//    self.theCurrentSelecterRaw = indexPath.section;
//    [self.navigationController pushViewController:detailRecept animated:YES];
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RecipeCell *theCell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"nameOfDish == %@", theCell.theRecipeName];
    NSArray *dishes = [BZDish MR_findAllWithPredicate:predicate];
    BZDish *dish = [dishes objectAtIndex:0];
    BZDetailReceptViewController *detailRecept = [[BZDetailReceptViewController alloc] init];
    detailRecept.dish = dish;
    detailRecept.delegate = self;
    self.theCurrentSelecterRaw = indexPath.section;
    [self.navigationController pushViewController:detailRecept animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return [self.arrayOfDishes count];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.isLoading) if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height - 300)
    {
        
        //   if (maxNumberOfDishes > [self.arrayOfDishes count])
        //       [self loadData];
    }
}

#pragma mark - Methods (Public)

-(void) addToFavouriteWithCell: (BZRecipeCell*) theCell
{
//    if ([theCell.recipeButton isSelected])
//    {
//        [theCell.recipeButton setSelected:NO];
//        NSPredicate *thePredicate = [NSPredicate predicateWithFormat:@"nameOfDish == %@", theCell.theOriginalNameString];
//        NSArray *theDishesArray = [BZDish MR_findAllWithPredicate:thePredicate];
//        BZDish *theBZDish = [theDishesArray objectAtIndex:0];
//        theBZDish.isFavourite= [NSNumber numberWithBool:NO];
//        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
//    }
//    else
//    {
//        [theCell.recipeButton setSelected:YES];
//        NSPredicate* thePredicate = [NSPredicate predicateWithFormat:@"nameOfDish == %@", theCell.theOriginalNameString];
//        NSArray* theDishesArray = [BZDish MR_findAllWithPredicate:thePredicate];
//        BZDish* theBZDish = theDishesArray[0];
//        theBZDish.isFavourite= [NSNumber numberWithBool:YES];
//        theBZDish.dateAddedToFavourites = [NSDate date];
//        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
//    }
}


- (void)methodLoadData
{
    __weak BZSearchRecipesViewController *theWeakSelf = self;
    if (self.theIngridientsArray.count == 0)
    {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
        NSMutableDictionary *theIngridientsNameDictionary = [NSMutableDictionary dictionary];
        NSMutableDictionary *theMainIngridientsDictionary = [NSMutableDictionary dictionary];
        NSMutableArray *theDishesArray = [NSMutableArray array];
        
        for(BZIngridient *theCurrentIngridient in theWeakSelf.theIngridientsArray)
        {
            NSSet *theDishesSet = theCurrentIngridient.arrayOfDishes;
            for (BZDish *theCurrentDish in theDishesSet)
            {
                NSNumber *theIngridientsNSNumber = [theIngridientsNameDictionary objectForKey:theCurrentDish.nameOfDish];
                if (theIngridientsNSNumber != nil)
                {
                    [theIngridientsNameDictionary setObject:[NSNumber numberWithInteger:([theIngridientsNSNumber integerValue] + 1) ]
                             forKey:theCurrentDish.nameOfDish];
                    //  [dishesArray addObject:dish];
                    
                }
                else
                {
                    [theIngridientsNameDictionary setObject:[NSNumber numberWithInteger:1] forKey:theCurrentDish.nameOfDish];
                    [theDishesArray addObject:theCurrentDish];
                }
                if ([theCurrentIngridient.isMain integerValue] == 1)
                {
                    NSNumber* theMainIngridientsNumber = [theIngridientsNameDictionary objectForKey:theCurrentDish.nameOfDish];
                    if (theMainIngridientsNumber)
                    {
                        [theMainIngridientsDictionary setObject:[NSNumber numberWithInteger:([theMainIngridientsNumber integerValue] + 1) ]
                                               forKey:theCurrentDish.nameOfDish];
                    }
                    else
                    {
                        [theMainIngridientsDictionary setObject:[NSNumber numberWithInteger:1] forKey:theCurrentDish.nameOfDish];
                    }
                    
                }
            }
        }
        NSLog(@"%ld",(long)[theDishesArray count]);
        [theDishesArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2)
        {
            BZDish* theFirstDish = (BZDish*)obj1;
            BZDish* theSecondDish = (BZDish*)obj2;
            NSInteger theFirstNumber = [((NSNumber*)theIngridientsNameDictionary[theFirstDish.nameOfDish]) integerValue] ;
            NSInteger theSecondNumber = [((NSNumber*)theIngridientsNameDictionary[theSecondDish.nameOfDish]) integerValue] ;
            NSInteger theFirstMainNumber = [((NSNumber*)theMainIngridientsDictionary[theFirstDish.nameOfDish]) integerValue] ;
            NSInteger theSecondMainNumber = [((NSNumber*)theMainIngridientsDictionary[theFirstDish.nameOfDish]) integerValue] ;
            NSInteger theFirstIngridientsDeficite = [theFirstDish.countOfIngridients integerValue]- theFirstNumber;
            NSInteger theSecondIngridientsDeficite = [theSecondDish.countOfIngridients integerValue]- theSecondNumber;
            NSInteger theFirstMainIngridientsDeficite = [theFirstDish.countOfMainIngridients integerValue]- theFirstMainNumber;
            NSInteger theSecondMainIngridientsDeficite = [theSecondDish.countOfMainIngridients integerValue]- theSecondMainNumber;
            if ((theFirstMainIngridientsDeficite + 2.0/theFirstMainNumber) < (2.0/theSecondMainNumber + theSecondMainIngridientsDeficite)) return NSOrderedAscending;
            if ((theFirstMainIngridientsDeficite + 2.0/theFirstMainNumber) > (2.0/theSecondMainNumber + theSecondMainIngridientsDeficite))  return NSOrderedDescending;
            if ((theFirstMainIngridientsDeficite + 2.0/theFirstMainNumber) == (2.0/theSecondMainNumber + theSecondMainIngridientsDeficite))
            {
                if (theFirstIngridientsDeficite < theSecondIngridientsDeficite) return NSOrderedAscending;
                if (theFirstIngridientsDeficite > theSecondIngridientsDeficite) return NSOrderedDescending;
                return NSOrderedSame;
            }
            return NSOrderedSame;
        }];
        NSInteger theCounter = 0;
        for (BZDish* theCurrentDish in theDishesArray)
        {
            NSInteger firstMainNumber = [((NSNumber*)theMainIngridientsDictionary[theCurrentDish.nameOfDish]) integerValue] ;
            NSInteger firstMainIngridientsDeficite = [theCurrentDish.countOfMainIngridients integerValue]- firstMainNumber;
            if (firstMainIngridientsDeficite > 2)
            {
                break;
            }
            theCounter++;
        }
        if (theCounter <= 30)
        {
            if ([theDishesArray count] < 15 )
            {
              theWeakSelf.arrayOfDishes = theDishesArray;
            }
            else
            {
                theWeakSelf.arrayOfDishes = [NSMutableArray arrayWithArray:[theDishesArray subarrayWithRange:NSMakeRange(0, 15)]];
            }
        }
        if (theCounter > 30 && theCounter < 70)
        {
           theWeakSelf.arrayOfDishes = [NSMutableArray arrayWithArray:[theDishesArray subarrayWithRange:NSMakeRange(0, theCounter)]];
        }
        if (theCounter >= 70)
        {
            theWeakSelf.arrayOfDishes = [NSMutableArray arrayWithArray:[theDishesArray subarrayWithRange:NSMakeRange(0, 70)]];
        }
        dispatch_async(dispatch_get_main_queue(), ^
        {
            
            [theWeakSelf.tableView reloadData];
        });
    });
}

#pragma mark - Methods (Private)

#pragma mark - Standard Methods

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end






























