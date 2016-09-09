//
//  BZFavouritesViewController.m
//  Fridge
//
//  Created by User on 04.02.16.
//  Copyright © 2016 BZ. All rights reserved.
//

#import "BZFavouritesViewController.h"

#import "BZDish.h"
#import "BZRecipeFavouritesCell.h"
#import "BZDetailReceptViewController.h"
#import "RecipeCell.h"
#import "BZAddToFavouriteProtocol.h"

#import <MagicalRecord/MagicalRecord.h>

@interface BZFavouritesViewController() <RecipeCellProtocol>

@property (assign, nonatomic) NSInteger numberOfFavourites;
@property (assign, nonatomic) BOOL isNeedUpdate;
@property (strong, nonatomic) UIActivityIndicatorView *theProgressView;
@property (assign, nonatomic) CGPoint theLastContentOffset;

@end

static NSString* recipeFavouriteCellIdentifier = @"recipeFavouriteCellIdentifier";

@implementation BZFavouritesViewController

#pragma mark - Class Methods (Public)

#pragma mark - Class Methods (Private)

//- (void)changedFavourite:(BOOL)isFavourite
//{
//    [super changedFavourite:isFavourite];
//    BZRecipeFavouritesCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.currentSelecterRaw]];
//    if (isFavourite)
//    {
//        [cell.recipeButton setSelected:YES];
//    }
//    else
//    {
//        [cell.recipeButton setSelected:NO];
//    }
//}

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
    
    
//    [self.tableView setNeedsLayout];
//    [self.tableView layoutIfNeeded];
    
    UIActivityIndicatorView *theProgressView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:theProgressView];
    self.theProgressView = theProgressView;
    theProgressView.theWidth = 50;
    theProgressView.theHeight = theProgressView.theWidth;
    theProgressView.theMinY = 68;
    theProgressView.theCenterX = [UIScreen mainScreen].bounds.size.width / 2;
    [theProgressView startAnimating];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMenuDidOpenNotification:) name:keyNotifMenuDidOpen object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMenuDidCloseNotification:) name:keyNotifMenuDidClose object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveFavouriteChangeNotification:) name:theDishFavouriteKey object:nil];
    [self.tableView addObserver:self forKeyPath:@"contentInset" options:NSKeyValueObservingOptionNew context:nil];
//    [self.tableView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
//    [self.tableView addObserver:self forKeyPath:@"contentInset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeAll;

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
    UINavigationBar *navBar = self.navigationController.navigationBar;
    [navBar setTranslucent:YES];
    navBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    [navBar setBackgroundImage:[UIImage imageNamed:@"patternNav"] forBarMetrics:UIBarMetricsDefault];
    [navBar setShadowImage:[[UIImage alloc] init]];
    NSLog(@"Frame %f",  [UIScreen mainScreen].applicationFrame.origin.y);
    CGPoint theZeroPoint = [self.view convertPoint:CGPointMake(0, 0) toView:nil];
    if (theZeroPoint.y != 0)
    {
        self.tableView.theMinY = 0;
    }
    else
    {
        self.tableView.theMinY = 64;
    }
//    NSLog(@"table view frame %ld",(long)self.tableView.frame.origin.y);
//    NSLog(@"view frame %ld",(long)self.view.frame.origin.y);
//    NSLog(@"view ZERO POINT %ld",(long)theZeroPoint.y);
//    CGPoint theZeroPoint2 = [self.tableView convertPoint:CGPointMake(0, 0) toView:nil];
//    NSLog(@"table view ZERO POINT %ld",(long)theZeroPoint2.y);
//    NSLog(@"Table view top inset %ld",(long)self.tableView.contentInset.top);
//    NSLog(@"Header height %ld",(long)self.tableView.tableHeaderView.bounds.size.height);


////    NSLog(@"MinY %f", self.view.theMinY);
//    self.isNeedUpdate = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//    self.tableView.estimatedRowHeight = 80;
}

#pragma mark - Create Views & Variables

#pragma mark - Actions

#pragma mark - Notifications

- (void)receiveFavouriteChangeNotification:(NSNotification *)theNotification
{
    BZDish *theDish = theNotification.object;
    if ([theDish.isFavourite boolValue])
    {
        if (self.arrayOfDishes && ![self.arrayOfDishes containsObject:theDish])
        {
            [self.arrayOfDishes insertObject:theDish atIndex:0];
            [self.tableView reloadData];
        }
    }
    else
    {
        if (self.arrayOfDishes && [self.arrayOfDishes containsObject:theDish])
        {
            [self.arrayOfDishes removeObject:theDish];
            [self.tableView reloadData];
        }
    }
}

- (void)receiveMenuDidOpenNotification:(NSNotification *)theNotification
{
    
}

- (void)receiveMenuDidCloseNotification:(NSNotification *)theNotification
{
    if (!self.isLoading)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isFavourite == %@", [NSString stringWithFormat:@"%ld",(long)1]];
        self.numberOfFavourites = [BZDish MR_countOfEntitiesWithPredicate:predicate];
        if (self.numberOfFavourites != [self.arrayOfDishes count])
        {
            [self.arrayOfDishes removeAllObjects];
            if (!self.isLoading)
            {
                [self loadData];
                self.isLoading = YES;
            }
        }
        else
        {
            [self.theProgressView stopAnimating];
        }
//        __weak BZFavouritesViewController* weakSelf = self;
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
//                       {
//
//                           dispatch_async(dispatch_get_main_queue(), ^
//                                          {
////                                              [weakSelf.tableView reloadData];
//                                              NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isFavourite == %@", [NSString stringWithFormat:@"%ld",(long)1]];
//                                              weakSelf.numberOfFavourites = [BZDish MR_countOfEntitiesWithPredicate:predicate];
//                                              if (weakSelf.numberOfFavourites != [weakSelf.arrayOfDishes count])
//                                              {
//                                                  [weakSelf.arrayOfDishes removeAllObjects];
//                                                  if (!weakSelf.isLoading)
//                                                  {
//                                                      [weakSelf loadData];
//                                                      weakSelf.isLoading = YES;
//                                                  }
//                                              }
//                                          });
//                           
//                           
//                       });

    }
}

#pragma mark - RecipeCellDelegate

- (void)recipeCellRightButtonWasTapped:(RecipeCell * _Nonnull)theCell
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"nameOfDish == %@", theCell.theRecipeName];
    NSArray *dishes = [BZDish MR_findAllWithPredicate:predicate];
    BZDish *dish = [dishes objectAtIndex:0];
    NSInteger dd = [self.arrayOfDishes indexOfObject:dish];
    
    
    [self.arrayOfDishes removeObjectAtIndex:dd];
    dish.isFavourite= [NSNumber numberWithBool:NO];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    self.numberOfFavourites--;
    
    [self.tableView reloadData];
}

#pragma mark - Gestures

#pragma mark - Delegates (UITableViewDelegate & UITableViewDataSource)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecipeCell *cell = (RecipeCell*)[tableView dequeueReusableCellWithIdentifier:recipeFavouriteCellIdentifier];
    if (!cell)
    {
        cell = [[RecipeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:recipeFavouriteCellIdentifier];
    }
    cell.theDelegate = self;
    if (indexPath.section > ([self.arrayOfDishes count]-1))
    {
        return cell;
    }
    if (!self.arrayOfDishes || !self.arrayOfDishes.count || self.arrayOfDishes.count <= indexPath.section)
    {
        return cell;
    }
    BZDish *dish = [self.arrayOfDishes objectAtIndex:indexPath.section];
    cell.theRecipeName = dish.nameOfDish;
    cell.theRecipeImage = [UIImage imageNamed:[NSString stringWithFormat:@"c%@",dish.image]];
    cell.theRecipeDescription = dish.ingridients;
    [cell.theRightButton setImage:[UIImage imageNamed:@"closeViolet.png"]
                           forState:UIControlStateNormal];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecipeCell *theCell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"nameOfDish == %@", theCell.theRecipeName];
    NSArray *dishes = [BZDish MR_findAllWithPredicate:predicate];
    BZDish *dish = dishes[0];
    BZDetailReceptViewController *detailRecept = [[BZDetailReceptViewController alloc] init];
    detailRecept.dish = dish;
    detailRecept.delegate = self;
    self.currentSelecterRaw = indexPath.section;
    [self.navigationController pushViewController:detailRecept animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
        if (self.numberOfFavourites > [self.arrayOfDishes count])
        {
            [self loadData];
        }
    }
}

#pragma mark - Methods (Public)

#pragma mark - Methods (Private)

- (void)loadData
{
    if (!(self.isViewLoaded && self.view.window))
    {
        return;
    }
    self.isLoading = YES;
    __weak BZRecipeViewController *weakSelf = self;
    /*  NSPredicate* predicate = [NSPredicate predicateWithFormat:@"isFavourite == %@", [NSString stringWithFormat:@"%ld",(long)1]];
     NSFetchRequest *itemRequest = [BZDish MR_requestAllWithPredicate:predicate];
     [itemRequest setReturnsObjectsAsFaults:NO];*/
    NSArray *arrayOfLoadDishes = [self requestWithOffset:[weakSelf.arrayOfDishes count]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
                       //   NSArray* allDishes = [BZDish MR_findAllWithPredicate:predicate];
                       
                       if (!weakSelf.nonFirstLoad)
                       {
//                           sleep(1);
                           weakSelf.nonFirstLoad = YES;
                       }
                       
                       dispatch_async(dispatch_get_main_queue(), ^
                                      {
//                                          if ([self.refreshControl isRefreshing])
//                                          {
//                                              [self.refreshControl endRefreshing];
//                                          }
//                                          [self.refreshControl removeFromSuperview];
//                                          self.refreshControl = 4;
                                          [self.theProgressView stopAnimating];
                                          self.theProgressView.alpha = 0;
                                          weakSelf.isLoading = NO;
                                          [weakSelf.arrayOfDishes addObjectsFromArray:arrayOfLoadDishes];
                                          [weakSelf.tableView reloadData];
                                      });
                   });
    
}

- (NSArray *)requestWithOffset: (NSInteger)offset
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isFavourite == %@", [NSString stringWithFormat:@"%ld",(long)1]];
    NSFetchRequest *itemRequest = [BZDish MR_requestAllWithPredicate:predicate];
    [itemRequest setFetchLimit:15];
    [itemRequest setFetchOffset: offset];
    [itemRequest setReturnsObjectsAsFaults:NO];
    NSSortDescriptor *popularDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateAddedToFavourites" ascending:NO];
    [itemRequest setSortDescriptors:[NSArray arrayWithObject:popularDescriptor]];
    NSArray *items = [BZDish MR_executeFetchRequest:itemRequest];
    return items;
}


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

#pragma mark - Standard Methods

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end






























