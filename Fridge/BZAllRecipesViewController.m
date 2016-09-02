//
//  BZAllRecipesViewController.m
//  Fridge
//
//  Created by User on 04.02.16.
//  Copyright © 2016 BZ. All rights reserved.
//

#import "BZAllRecipesViewController.h"

#import "BZDish.h"
#import "BZRecipeCell.h"
#import "BZDetailReceptViewController.h"
#import "RecipeCell.h"

#import <MagicalRecord/MagicalRecord.h>

//@interface BZAllRecipesViewController ()
//
//@end
//
//const NSInteger criticalNumber = 400;
//const CGFloat cellSpacing = 20;
//const NSInteger recipesLoadNumber = 20;
//
//@implementation BZAllRecipesViewController
//
//#pragma mark - Class Methods (Public)
//
//#pragma mark - Class Methods (Private)
//
//- (void)changedFavourite:(BOOL) isFavourite
//{
//    [super changedFavourite:isFavourite];
//    BZRecipeCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.currentSelecterRaw]];
//    if (isFavourite)
//    {
//        [cell.recipeButton setSelected:YES];
//    }
//    else
//    {
//        [cell.recipeButton setSelected:NO];
//    }
//}
//
//#pragma mark - Init & Dealloc
//
//#pragma mark - Setters (Public)
//
//#pragma mark - Getters (Public)
//
//#pragma mark - Setters (Private)
//
//#pragma mark - Getters (Private)
//
//#pragma mark - Lifecycle
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    
//    // Do any additional setup after loading the view.
//    [self.tableView registerNib:[UINib nibWithNibName:@"BZAllRecipesCell" bundle:nil] forCellReuseIdentifier:recipeCellIdentifier];
//    self.refreshControl = [[UIRefreshControl alloc] init];
//    //  [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
//    [self.tableView addSubview:self.refreshControl];
//    [self.refreshControl beginRefreshing];
//    
//    if (!self.isLoading)
//    {
//        self.isLoading = YES;
//        [self loadData];
//    }
//    //    self.tableView.rowHeight = UITableViewAutomaticDimension;
//    self.tableView.estimatedRowHeight = 80;
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
//    
//    [self.tableView setNeedsLayout];
//    [self.tableView layoutIfNeeded];
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMenuDidOpenNotification:) name:keyNotifMenuDidOpen object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMenuDidCloseNotification:) name:keyNotifMenuDidClose object:nil];
//}
//
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [self setNeedsStatusBarAppearanceUpdate];
//    NSLog(@"%ld",(long)self.tableView.frame.origin.y);
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)])
//    {
//        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
//        NSArray *list=self.navigationController.navigationBar.subviews;
//        for (id obj in list)
//        {
//            if ([obj isKindOfClass:[UIImageView class]])
//            {
//                UIImageView *imageView=(UIImageView *)obj;
//                imageView.alpha=1;
//            }
//        }
//        
//    }
//    UINavigationBar* navBar = self.navigationController.navigationBar;
//    [navBar setTranslucent:YES];
//    navBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
//    [navBar setBackgroundImage:[UIImage imageNamed:@"patternNav"] forBarMetrics:UIBarMetricsDefault];
//    [navBar setShadowImage:[[UIImage alloc] init]];
//
//}
//
//#pragma mark - Create Views & Variables
//
//#pragma mark - Actions
//
//#pragma mark - Notifications
//
//- (void)receiveMenuDidOpenNotification:(NSNotification *)theNotification
//{
//    
//}
//
//- (void)receiveMenuDidCloseNotification:(NSNotification *)theNotification
//{
//    if (!self.isLoading)
//    {
//        __weak BZAllRecipesViewController* weakSelf = self;
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
//                       {                           
//                           dispatch_async(dispatch_get_main_queue(), ^
//                                          {
//                                              [weakSelf.tableView reloadData];
//                                          });
//                           
//                           
//                       });
//        
//    }
//}
//
//#pragma mark - Gestures
//
//#pragma mark - Delegates (UITableViewDelegate & UITableViewDatasource)
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    BZRecipeCell *cell = (BZRecipeCell*)[tableView dequeueReusableCellWithIdentifier:recipeCellIdentifier];
//    if (!cell)
//    {
//        cell = [[BZRecipeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:recipeCellIdentifier];
//        cell.recipeImage.contentMode = UIViewContentModeScaleToFill;
//        cell.theDelegate = self;
//        
//    }
//    cell.theDelegate = self;
//    if (indexPath.section > ([self.arrayOfDishes count]-1))
//    {
//        return cell;
//    }
//    BZDish *dish = [self.arrayOfDishes objectAtIndex:indexPath.section];
//    cell.theOriginalNameString = dish.nameOfDish;
//    cell.recipeName.text = dish.nameOfDish;
//    cell.recipeDescription.text = dish.ingridients;
//    cell.recipeImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"c%@",dish.image]];
//    
//    if ([dish.isFavourite boolValue])
//    {
//        [cell.recipeButton setSelected:YES];
//    }
//    else
//    {
//        [cell.recipeButton setSelected:NO];
//    }
//    
//    return cell;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    BZRecipeCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"nameOfDish == %@", cell.theOriginalNameString];
//    NSArray *dishes = [BZDish MR_findAllWithPredicate:predicate];
//    BZDish *dish = [dishes objectAtIndex:0];
//    BZDetailReceptViewController *detailRecept = [[BZDetailReceptViewController alloc] init];
//    detailRecept.dish = dish;
//    detailRecept.delegate = self;
//    self.currentSelecterRaw = indexPath.section;
//    [self.navigationController pushViewController:detailRecept animated:YES];
//}
//
//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 150;
//}
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if (!self.isLoading) if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height - 300)
//    {
//        
//        if (self.maxNumberOfDishes > [self.arrayOfDishes count])
//        {
//            if (criticalNumber > [self.arrayOfDishes count])
//            {
//                [self loadData];
//            }
//        }
//    }
//}
//
//#pragma mark - Methods (Public)
//
//#pragma mark - Methods (Private)
//
//- (void)loadData
//{
//    self.isLoading = YES;
//    __weak BZRecipeViewController *weakSelf = self;
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isFavourite == %@", [NSString stringWithFormat:@"%ld",(long)0]];
//    NSFetchRequest *itemRequest = [BZDish MR_requestAllWithPredicate:predicate];
//    [itemRequest setReturnsObjectsAsFaults:NO];
//    NSArray *allDishes = [BZDish MR_executeFetchRequest:itemRequest];
//    NSInteger countDishes = [allDishes count];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
//                   {
//                       //   NSArray* allDishes = [BZDish MR_findAllWithPredicate:predicate];
//                       
//                       if (!weakSelf.nonFirstLoad)
//                       {
//                           sleep(1);
//                           weakSelf.nonFirstLoad = YES;
//                       }
//                       NSMutableArray *arrayOfLoadDishes = [NSMutableArray array];
//                       NSInteger counter = 0;
//                       NSInteger numberToLoad =  0;
//                       if ([weakSelf.arrayOfDishes count] + recipesLoadNumber > self.maxNumberOfDishes )
//                       {
//                           numberToLoad = self.maxNumberOfDishes -  [weakSelf.arrayOfDishes count];
//                       }
//                       else
//                       {
//                           numberToLoad = recipesLoadNumber;
//                       }
//                       while (counter < numberToLoad)
//                       {
//                           NSInteger randomEntityIndex = arc4random() % countDishes; // выбираем рандомную категорию
//                           if (![weakSelf.setWithDishes containsObject:[NSNumber numberWithInteger:randomEntityIndex]])
//                           {
//                               [weakSelf.setWithDishes addObject:[NSNumber numberWithInteger:randomEntityIndex]];
//                               // [arrayOfLoadDishes addObject:[allDishes objectAtIndex:randomEntityIndex]];
//                               [arrayOfLoadDishes addObject:[allDishes objectAtIndex:randomEntityIndex]];
//                               counter++;
//                           }
//                       }
//                       
//                       
//                       dispatch_async(dispatch_get_main_queue(), ^
//                                      {
//                                          if ([self.refreshControl isRefreshing]) [self.refreshControl endRefreshing];
//                                          self.refreshControl = nil;
//                                          weakSelf.isLoading = NO;
//                                          [weakSelf.arrayOfDishes addObjectsFromArray:arrayOfLoadDishes];
//                                          //       [weakSelf.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
//                                          [weakSelf.tableView reloadData];
//                                      });
//                       
//                       
//                   });
//}
//
//- (void)addToFavouriteWithCell: (BZRecipeCell*) cell
//{
//    if ([cell.recipeButton isSelected])
//    {
//        [cell.recipeButton setSelected:NO];
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"nameOfDish == %@", cell.theOriginalNameString];
//        NSArray *dishes = [BZDish MR_findAllWithPredicate:predicate];
//        BZDish *dish = [dishes objectAtIndex:0];
//        dish.isFavourite= [NSNumber numberWithBool:NO];
//        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
//    }
//    else
//    {
//        [cell.recipeButton setSelected:YES];
//        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"nameOfDish == %@", cell.theOriginalNameString];
//        NSArray* dishes = [BZDish MR_findAllWithPredicate:predicate];
//        BZDish* dish = [dishes objectAtIndex:0];
//        dish.isFavourite= [NSNumber numberWithBool:YES];
//        dish.dateAddedToFavourites = [NSDate date];
//        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
//    }
//}
//
//#pragma mark - Standard Methods
//
//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//}
//
//@end

@interface BZAllRecipesViewController ()<RecipeCellProtocol>

@end

const NSInteger criticalNumber = 400;
const CGFloat cellSpacing = 20;
const NSInteger recipesLoadNumber = 20;

@implementation BZAllRecipesViewController

#pragma mark - Class Methods (Public)

#pragma mark - Class Methods (Private)

- (void)changedFavourite:(BOOL) isFavourite
{
    [super changedFavourite:isFavourite];
    BZRecipeCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.currentSelecterRaw]];
    if (isFavourite)
    {
        [cell.recipeButton setSelected:YES];
    }
    else
    {
        [cell.recipeButton setSelected:NO];
    }
}

#pragma mark - Init & Dealloc

#pragma mark - Setters (Public)

#pragma mark - Getters (Public)

#pragma mark - Setters (Private)

#pragma mark - Getters (Private)

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
//    [self.tableView registerNib:[UINib nibWithNibName:@"BZAllRecipesCell" bundle:nil] forCellReuseIdentifier:recipeCellIdentifier];
    self.refreshControl = [[UIRefreshControl alloc] init];
    //  [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl beginRefreshing];
    
    if (!self.isLoading)
    {
        self.isLoading = YES;
        [self loadData];
    }
    //    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 80;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.tableView setNeedsLayout];
    [self.tableView layoutIfNeeded];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMenuDidOpenNotification:) name:keyNotifMenuDidOpen object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMenuDidCloseNotification:) name:keyNotifMenuDidClose object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNeedsStatusBarAppearanceUpdate];
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
    UINavigationBar* navBar = self.navigationController.navigationBar;
    [navBar setTranslucent:YES];
    navBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    [navBar setBackgroundImage:[UIImage imageNamed:@"patternNav"] forBarMetrics:UIBarMetricsDefault];
    [navBar setShadowImage:[[UIImage alloc] init]];
    
}

#pragma mark - Create Views & Variables

#pragma mark - Actions

#pragma mark - Notifications

- (void)receiveMenuDidOpenNotification:(NSNotification *)theNotification
{
    
}

- (void)receiveMenuDidCloseNotification:(NSNotification *)theNotification
{
    if (!self.isLoading)
    {
        __weak BZAllRecipesViewController* weakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                       {
                           dispatch_async(dispatch_get_main_queue(), ^
                                          {
                                              [weakSelf.tableView reloadData];
                                          });
                           
                           
                       });
        
    }
}

#pragma mark - Gestures

#pragma mark - Delegates

- (void)recipeCellRightButtonWasTapped:(RecipeCell * _Nonnull)theCell
{
    if ([theCell.theRightButton isSelected])
    {
        [theCell.theRightButton setSelected:NO];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"nameOfDish == %@", theCell.theRecipeName];
        NSArray *dishes = [BZDish MR_findAllWithPredicate:predicate];
        BZDish *dish = [dishes objectAtIndex:0];
        dish.isFavourite= [NSNumber numberWithBool:NO];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }
    else
    {
        [theCell.theRightButton setSelected:YES];
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"nameOfDish == %@", theCell.theRecipeName];
        NSArray* dishes = [BZDish MR_findAllWithPredicate:predicate];
        BZDish* dish = [dishes objectAtIndex:0];
        dish.isFavourite= [NSNumber numberWithBool:YES];
        dish.dateAddedToFavourites = [NSDate date];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }
}

#pragma mark - Delegates (UITableViewDelegate & UITableViewDatasource)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecipeCell *theCell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"nameOfDish == %@", theCell.theRecipeName];
    NSArray *dishes = [BZDish MR_findAllWithPredicate:predicate];
    BZDish *dish = [dishes objectAtIndex:0];
    BZDetailReceptViewController *detailRecept = [[BZDetailReceptViewController alloc] init];
    detailRecept.dish = dish;
    detailRecept.delegate = self;
    self.currentSelecterRaw = indexPath.section;
    [self.navigationController pushViewController:detailRecept animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.isLoading) if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height - 300)
    {
        
        if (self.maxNumberOfDishes > [self.arrayOfDishes count])
        {
            if (criticalNumber > [self.arrayOfDishes count])
            {
                [self loadData];
            }
        }
    }
}

#pragma mark - Methods (Public)

#pragma mark - Methods (Private)

- (void)loadData
{
    self.isLoading = YES;
    __weak BZRecipeViewController *weakSelf = self;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isFavourite == %@", [NSString stringWithFormat:@"%ld",(long)0]];
    NSFetchRequest *itemRequest = [BZDish MR_requestAllWithPredicate:predicate];
    [itemRequest setReturnsObjectsAsFaults:NO];
    NSArray *allDishes = [BZDish MR_executeFetchRequest:itemRequest];
    NSInteger countDishes = [allDishes count];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
                       //   NSArray* allDishes = [BZDish MR_findAllWithPredicate:predicate];
                       
                       if (!weakSelf.nonFirstLoad)
                       {
                           sleep(1);
                           weakSelf.nonFirstLoad = YES;
                       }
                       NSMutableArray *arrayOfLoadDishes = [NSMutableArray array];
                       NSInteger counter = 0;
                       NSInteger numberToLoad =  0;
                       if ([weakSelf.arrayOfDishes count] + recipesLoadNumber > self.maxNumberOfDishes )
                       {
                           numberToLoad = self.maxNumberOfDishes -  [weakSelf.arrayOfDishes count];
                       }
                       else
                       {
                           numberToLoad = recipesLoadNumber;
                       }
                       while (counter < numberToLoad)
                       {
                           NSInteger randomEntityIndex = arc4random() % countDishes; // выбираем рандомную категорию
                           if (![weakSelf.setWithDishes containsObject:[NSNumber numberWithInteger:randomEntityIndex]])
                           {
                               [weakSelf.setWithDishes addObject:[NSNumber numberWithInteger:randomEntityIndex]];
                               // [arrayOfLoadDishes addObject:[allDishes objectAtIndex:randomEntityIndex]];
                               [arrayOfLoadDishes addObject:[allDishes objectAtIndex:randomEntityIndex]];
                               counter++;
                           }
                       }
                       
                       
                       dispatch_async(dispatch_get_main_queue(), ^
                                      {
                                          if ([self.refreshControl isRefreshing]) [self.refreshControl endRefreshing];
                                          self.refreshControl = nil;
                                          weakSelf.isLoading = NO;
                                          [weakSelf.arrayOfDishes addObjectsFromArray:arrayOfLoadDishes];
                                          //       [weakSelf.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
                                          [weakSelf.tableView reloadData];
                                      });
                       
                       
                   });
}

- (void)addToFavouriteWithCell: (BZRecipeCell*) cell
{
    if ([cell.recipeButton isSelected])
    {
        [cell.recipeButton setSelected:NO];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"nameOfDish == %@", cell.theOriginalNameString];
        NSArray *dishes = [BZDish MR_findAllWithPredicate:predicate];
        BZDish *dish = [dishes objectAtIndex:0];
        dish.isFavourite= [NSNumber numberWithBool:NO];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }
    else
    {
        [cell.recipeButton setSelected:YES];
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"nameOfDish == %@", cell.theOriginalNameString];
        NSArray* dishes = [BZDish MR_findAllWithPredicate:predicate];
        BZDish* dish = [dishes objectAtIndex:0];
        dish.isFavourite= [NSNumber numberWithBool:YES];
        dish.dateAddedToFavourites = [NSDate date];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }
}

#pragma mark - Standard Methods

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end






























