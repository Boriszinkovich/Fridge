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

#import <MagicalRecord/MagicalRecord.h>

@interface BZFavouritesViewController ()

@property (assign, nonatomic) NSInteger numberOfFavourites;

@end

static NSString* recipeFavouriteCellIdentifier = @"recipeFavouriteCellIdentifier";

@implementation BZFavouritesViewController

#pragma mark - Class Methods (Public)

#pragma mark - Class Methods (Private)

- (void)changedFavourite:(BOOL)isFavourite
{
    [super changedFavourite:isFavourite];
    BZRecipeFavouritesCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.currentSelecterRaw]];
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
    [self.tableView registerNib:[UINib nibWithNibName:@"BZFavouriteRecipeCell" bundle:nil]
         forCellReuseIdentifier:recipeFavouriteCellIdentifier];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl beginRefreshing];
    
    if (!self.isLoading)
    {
        self.isLoading = YES;
        [self loadData];
    }
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
    UINavigationBar *navBar = self.navigationController.navigationBar;
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
        __weak BZFavouritesViewController* weakSelf = self;
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

#pragma mark - Delegates (UITableViewDelegate & UITableViewDataSource)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *recipeFavouriteCellIdentifier = @"recipeFavouriteCellIdentifier";
    BZRecipeFavouritesCell *cell = (BZRecipeFavouritesCell*)[tableView dequeueReusableCellWithIdentifier:recipeFavouriteCellIdentifier];
    if (!cell)
    {
        cell = [[BZRecipeFavouritesCell alloc] initWithStyle:UITableViewCellStyleDefault
                                             reuseIdentifier:recipeFavouriteCellIdentifier];
        
    }
    BZDish *dish = [self.arrayOfDishes objectAtIndex:indexPath.section];
    NSLog(@"%@",dish);
    cell.originalName = dish.nameOfDish;
    cell.recipeName.text = dish.nameOfDish;
    cell.recipeDescription.text = dish.ingridients;
    NSLog(@"%@",dish.image);
    cell.recipeImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"c%@",dish.image]];
    cell.recipeImage.contentMode = UIViewContentModeScaleToFill;
    [cell.recipeButton setImage:[UIImage imageNamed:@"closeViolet.png"]
                       forState:UIControlStateNormal]; //  CloseGray
    cell.delegate = self;
    NSLog(@"%f",cell.recipeDescription.frame.size.width);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BZRecipeFavouritesCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"nameOfDish == %@", cell.originalName];
    NSArray *dishes = [BZDish MR_findAllWithPredicate:predicate];
    BZDish *dish = dishes[0];
    BZDetailReceptViewController *detailRecept = [[BZDetailReceptViewController alloc] init];
    detailRecept.dish = dish;
    detailRecept.delegate = self;
    self.currentSelecterRaw = indexPath.section;
    [self.navigationController pushViewController:detailRecept animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
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
                           sleep(1);
                           weakSelf.nonFirstLoad = YES;
                       }
                       
                       dispatch_async(dispatch_get_main_queue(), ^
                                      {
                                          if ([self.refreshControl isRefreshing]) [self.refreshControl endRefreshing];
                                          self.refreshControl= nil;
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


- (void)deleteFromFavouriteWithCell: (BZRecipeFavouritesCell*) cell
{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"nameOfDish == %@", cell.originalName];
    NSArray *dishes = [BZDish MR_findAllWithPredicate:predicate];
    BZDish *dish = [dishes objectAtIndex:0];
    NSInteger dd = [self.arrayOfDishes indexOfObject:dish];
    
    
    [self.arrayOfDishes removeObjectAtIndex:dd];
    dish.isFavourite= [NSNumber numberWithBool:NO];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    self.numberOfFavourites--;
    
    [self.tableView reloadData];
}

#pragma mark - Standard Methods

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end






























