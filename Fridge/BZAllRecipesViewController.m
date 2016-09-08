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

@interface BZAllRecipesViewController() <RecipeCellProtocol>

@property (assign, nonatomic) BOOL isNeedUpdate;
@property (assign, nonatomic) CGPoint theLastContentOffset;
@property (strong, nonatomic) UIActivityIndicatorView *theProgressView;

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
    RecipeCell *theCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.currentSelecterRaw]];
    if (isFavourite)
    {
        [theCell.theRightButton setSelected:YES];
    }
    else
    {
        [theCell.theRightButton setSelected:NO];
    }
//    BZRecipeCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.currentSelecterRaw]];
//    if (isFavourite)
//    {
//        [cell.recipeButton setSelected:YES];
//    }
//    else
//    {
//        [cell.recipeButton setSelected:NO];
//    }
}

- (void)detailViewDismissed
{
    self.isNeedUpdate = YES;
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
    
    UIActivityIndicatorView *theProgressView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:theProgressView];
    self.theProgressView = theProgressView;
    theProgressView.theWidth = 50;
    theProgressView.theHeight = theProgressView.theWidth;
    theProgressView.theMinY = 68;
    theProgressView.theCenterX = [UIScreen mainScreen].bounds.size.width / 2;
    [theProgressView startAnimating];
    // Do any additional setup after loading the view.
//    [self.tableView registerNib:[UINib nibWithNibName:@"BZAllRecipesCell" bundle:nil] forCellReuseIdentifier:recipeCellIdentifier];
//    self.refreshControl = [[UIRefreshControl alloc] init];
//    [self.tableView addSubview:self.refreshControl];
//    [self.refreshControl beginRefreshing];

    //    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.tableView.estimatedRowHeight = 80;

    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMenuDidOpenNotification:) name:keyNotifMenuDidOpen object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMenuDidCloseNotification:) name:keyNotifMenuDidClose object:nil];
    [self.tableView addObserver:self forKeyPath:@"contentInset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//    self.tableView.estimatedRowHeight = 80;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNeedsStatusBarAppearanceUpdate];
    self.edgesForExtendedLayout = UIRectEdgeTop;
    self.navigationController.navigationBar.hidden = NO;
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
    
    CGPoint theZeroPoint = [self.view convertPoint:CGPointMake(0, 0) toView:nil];
    if (theZeroPoint.y != 0)
    {
        self.tableView.theMinY = 0;
    }
    else
    {
        self.tableView.theMinY = 64;
    }
}

#pragma mark - Create Views & Variables

#pragma mark - Actions

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (isEqual(keyPath, @"contentInset"))
    {
        NSLog(@"%@", object);
        NSLog(@"%@", change);
        NSLog(@"%@", change[@"new"]);
        NSValue *theInsetsValue = (NSValue *)change[@"new"];
        UIEdgeInsets theEdgeInsets = [theInsetsValue UIEdgeInsetsValue];
        if (theEdgeInsets.top != 0)
        {
            self.tableView.contentInset = UIEdgeInsetsZero;
//            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
            if (!self.currentSelecterRaw)
            {
//                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                [self.tableView setContentOffset:self.theLastContentOffset];
            }
        }
    }
}

#pragma mark - Notifications

- (void)receiveMenuDidOpenNotification:(NSNotification *)theNotification
{
    
}

- (void)receiveMenuDidCloseNotification:(NSNotification *)theNotification
{
    if (!self.isLoading)
    {
        self.isLoading = YES;
        [self loadData];
//        __weak BZAllRecipesViewController* weakSelf = self;
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
//                       {
//                           dispatch_async(dispatch_get_main_queue(), ^
//                                          {
//                                              [weakSelf.tableView reloadData];
//                                          });
//                       });
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
    self.theLastContentOffset = tableView.contentOffset;
    [self.navigationController pushViewController:detailRecept animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    if (!self.nonFirstLoad)
    {
        return;
    }
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
//                           sleep(1);
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
                                          [self.theProgressView stopAnimating];
                                          self.theProgressView.alpha = 0;
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






























