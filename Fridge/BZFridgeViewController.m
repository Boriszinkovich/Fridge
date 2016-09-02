//
//  FridgeViewController.m
//  Fridge
//
//  Created by User on 03.02.16.
//  Copyright © 2016 BZ. All rights reserved.
//

#import "BZFridgeViewController.h"

#import "BZIngridient.h"
#import "BZIngridientCell.h"
#import "BZIngridientAddedCell.h"
#import "BZSearchRecipesViewController.h"

#import <MagicalRecord/MagicalRecord.h>

@interface BZFridgeViewController ()

@property (strong, nonatomic) NSMutableArray *sectionTitleArray;
@property (strong, nonatomic) NSMutableArray  *arrayForBool;
@property (assign, nonatomic) BOOL isLoading;
@property (assign, nonatomic) NSInteger searchInset;
@property (assign, nonatomic) NSInteger chosedInset;
@property (strong, nonatomic) NSOperation *currentOperation;
@property (strong, nonatomic) NSMutableArray *arrayOfSearchedIngridients;
@property (strong, nonatomic) NSMutableArray *arrayOfChosedIngridients;
@property (strong, nonatomic) UIColor *myColorBlack;
@property (strong, nonatomic) UIColor *myColorGreen;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (assign, nonatomic) NSInteger numberOfSearched;

@end

static NSString *ingridientCell = @"ingridientCell";
static NSString *ingridientAddedCell = @"ingridientAddedCell";

@implementation BZFridgeViewController

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
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.estimatedRowHeight = 50;
    
    [self.tableView setNeedsLayout];
    [self.tableView layoutIfNeeded];
    
    self.myColorBlack = [UIColor colorWithRed:39.f / 255.f
                                        green:39.f / 255.f
                                         blue:39.f / 255.f alpha:1.0];
    
    self.myColorGreen = [UIColor colorWithRed:176.f / 255.f
                                        green:191.f / 255.f
                                         blue:90.f / 255.f alpha:1.0];
    if (!self.sectionTitleArray)
    {
        self.sectionTitleArray = [NSMutableArray arrayWithObjects:@"Выбранные(0)", @"Поиск(642)", nil];
    }
    if (!self.arrayForBool)
    {
        self.arrayForBool    = [NSMutableArray arrayWithObjects:[NSNumber numberWithBool:NO],
                                [NSNumber numberWithBool:NO], nil];
    }
    self.arrayOfChosedIngridients = [NSMutableArray array];
    self.arrayOfSearchedIngridients = [NSMutableArray array];
    [self loadData];
    [self loadIngridientsDataWithSearchDescriptor:nil];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMenuDidOpenNotification:) name:keyNotifMenuDidOpen object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMenuDidCloseNotification:) name:keyNotifMenuDidClose object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self setNeedsStatusBarAppearanceUpdate];
}

#pragma mark - Create Views & Variables

#pragma mark - Actions

-(void)close:(UIButton *) button
{
    BZIngridient *ingridient = [self.arrayOfChosedIngridients objectAtIndex:button.tag];
    NSLog(@"%ld",(long)button.tag);
    ingridient.isInFridge = [NSNumber numberWithBool:NO];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    [self.arrayOfChosedIngridients removeObjectAtIndex:button.tag];
    [self.tableView reloadData];
}

#pragma mark - Notifications

- (void)receiveMenuDidOpenNotification:(NSNotification *)theNotification
{
    
}

- (void)receiveMenuDidCloseNotification:(NSNotification *)theNotification
{
    
}

#pragma mark - Gestures

- (void)sectionHeaderTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:gestureRecognizer.view.tag];
    if (indexPath.row == 0)
    {
        BOOL collapsed  = [[self.arrayForBool objectAtIndex:indexPath.section] boolValue];
        collapsed = !collapsed;
        [self.arrayForBool replaceObjectAtIndex:indexPath.section
                                     withObject:[NSNumber numberWithBool:collapsed]];
        
        NSRange range   = NSMakeRange(indexPath.section, 1);
        NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.tableView reloadSections:sectionToReload
                      withRowAnimation:UITableViewRowAnimationFade];
    }
}
- (void)sectionHeaderLongPressed:(UILongPressGestureRecognizer *)longPressedGesture
{
    
    if (longPressedGesture.state == UIGestureRecognizerStateEnded)
    {
        NSLog(@"UIGestureRecognizerStateEnded");
        //Do Whatever You want on End of Gesture
    }
    else if (longPressedGesture.state == UIGestureRecognizerStateBegan)
    {
        NSLog(@"UIGestureRecognizerStateBegan.");
        UIActionSheet *actSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                              delegate:self
                                                     cancelButtonTitle:@"Отменить"
                                                destructiveButtonTitle:@"Очистить все"
                                                     otherButtonTitles:@"Сортировать по популярности",@"Сортировать по дате добавления",nil];
        [actSheet showInView:self.view];
    }
    
}

#pragma mark - Delegates (UITableViewDelegate & UITableViewDataSource)

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sectionTitleArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[self.arrayForBool objectAtIndex:section] boolValue])
    {
        if (section == 0)
        {
            return [self.arrayOfChosedIngridients count];
        }
        else
        {
            return [self.arrayOfSearchedIngridients count];
        }
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    headerView.tag = section;
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *headerString = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-20-50, 50)];
    BOOL manyCells = [[self.arrayForBool objectAtIndex:section] boolValue];
    if (section == 0)
    {
        NSPredicate *predicate2 =[NSPredicate predicateWithFormat:@"isInFridge == 1"];
        NSInteger count = [BZIngridient MR_countOfEntitiesWithPredicate:predicate2];
        headerString.text = [NSString stringWithFormat:@"Выбранные(%ld)",(long)count];
        UILongPressGestureRecognizer* headerLongTapped = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                                       action:@selector(sectionHeaderLongPressed:)];
        [headerView addGestureRecognizer:headerLongTapped];
    }
    else
    {
        headerString.text = [NSString stringWithFormat:@"Поиск(%ld)",(long)self.numberOfSearched];
    }
    headerString.textAlignment      = NSTextAlignmentLeft;
    headerString.textColor          = [UIColor blackColor];
    [headerView addSubview:headerString];
    
    UITapGestureRecognizer  *headerTapped   = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(sectionHeaderTapped:)];
    [headerView addGestureRecognizer:headerTapped];
    
    //up or down arrow depending on the bool
    UIImageView *upDownArrow        = [[UIImageView alloc] initWithImage:manyCells ? [UIImage imageNamed:@"upArrowBlack"] : [UIImage imageNamed:@"downArrowBlack"]];
    upDownArrow.autoresizingMask    = UIViewAutoresizingFlexibleLeftMargin;
    upDownArrow.frame               = CGRectMake(self.view.frame.size.width-40, 10, 30, 30);
    [headerView addSubview:upDownArrow];
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer  = [[UIView alloc] initWithFrame:CGRectZero];
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.arrayForBool objectAtIndex:indexPath.section] boolValue])
    {
        return 50;
    }
    return 2;
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    BOOL manyCells  = [[self.arrayForBool objectAtIndex:indexPath.section] boolValue];
    if (!manyCells)
    {
        
        return cell;
    }
    else
    {
        if (indexPath.section == 0)
        {
            BZIngridientAddedCell *currentCell = [tableView dequeueReusableCellWithIdentifier:ingridientAddedCell];
            if (currentCell == nil)
            {
                currentCell = [[BZIngridientAddedCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                           reuseIdentifier:ingridientAddedCell];
            }
            BZIngridient *currentIngridient = [self.arrayOfChosedIngridients objectAtIndex:indexPath.row];
            currentCell.ingridientImage.image = [UIImage imageNamed:currentIngridient.imageOfIngridient];
            currentCell.ingridientNameLabel.text = currentIngridient.nameOfIngridient;
            [currentCell.deleteButton addTarget:self
                                         action:@selector(close:)
                               forControlEvents:UIControlEventTouchDown];
            currentCell.deleteButton.tag = indexPath.row;
            return currentCell;
        }
        else
        {
            BZIngridientCell *currentCell = [tableView dequeueReusableCellWithIdentifier:ingridientCell];
            if (currentCell == nil) {
                currentCell = [[BZIngridientCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                      reuseIdentifier:ingridientCell];
            }
            BZIngridient *currentIngridient = [self.arrayOfSearchedIngridients objectAtIndex:indexPath.row];
            currentCell.ingridientImage.image = [UIImage imageNamed:currentIngridient.imageOfIngridient];
            currentCell.ingridientNameLabel.text = currentIngridient.nameOfIngridient;
            if ([currentIngridient.isInFridge boolValue])
            {
                currentCell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            else
            {
                currentCell.accessoryType = UITableViewCellAccessoryNone;
                
            }
            if([self.searchIngridient.text length])
            {
                
                NSRange range = [currentIngridient.nameOfIngridient rangeOfString:self.searchIngridient.text options:NSCaseInsensitiveSearch];
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]  initWithString:currentIngridient.nameOfIngridient];
                [attributedString addAttribute:NSForegroundColorAttributeName
                                         value:self.myColorGreen range:range];
                
                [attributedString addAttribute:NSBackgroundColorAttributeName
                                         value:self.myColorBlack range:range];
                
                currentCell.ingridientNameLabel.attributedText = attributedString;
            }
            
            return currentCell;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1)
    {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark)
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            BZIngridient *ingridient = [self.arrayOfSearchedIngridients objectAtIndex:indexPath.row];
            ingridient.isInFridge = [NSNumber numberWithBool:NO];
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            [self.arrayOfChosedIngridients removeObject:ingridient];
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 1)];
            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            BZIngridient *ingridient = [self.arrayOfSearchedIngridients objectAtIndex:indexPath.row];
            ingridient.isInFridge = [NSNumber numberWithBool:YES];
            ingridient.dateAddedToFridge = [NSDate date];
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            [self.arrayOfChosedIngridients insertObject:ingridient atIndex:0];
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 1)];
            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.isLoading) if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height - 80)
    {
        BOOL manyCells  = [[self.arrayForBool objectAtIndex:1] boolValue];
        if (self.numberOfSearched >  [self.arrayOfSearchedIngridients count])
            if (manyCells)
            {
                [self loadData];
            }
    }
}

#pragma mark - Delegates (UISearchBarDelegate)

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    
    [searchBar setShowsCancelButton:YES animated:YES];
    NSArray *searchBarSubViews = [[self.searchIngridient.subviews objectAtIndex:0] subviews];
    UIButton *cancelButton;
    for (UIView *subView in searchBarSubViews)
    {
        if ([subView isKindOfClass:NSClassFromString(@"UINavigationButton")])
        {
            cancelButton = (UIButton*)subView;
            cancelButton.bounds = CGRectMake(cancelButton.bounds.origin.x - 10, cancelButton.bounds.origin.y, cancelButton.bounds.size.width + 10, cancelButton.bounds.size.height);
        }
    }
    if (cancelButton)
    {
        [cancelButton setTitle:@"Отмена" forState:UIControlStateNormal];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    searchBar.text = @"";
    [self loadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (self.currentOperation) if ([self.currentOperation isExecuting])
    {
        [self.currentOperation cancel];
    }
    [self.arrayOfSearchedIngridients removeAllObjects];
    self.searchInset = 0;
    [self loadData];
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

#pragma mark - Delegates (UIActionSheetDelegate)

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%@ (Кнопка по индексу %ld)",[actionSheet buttonTitleAtIndex:buttonIndex],(long)buttonIndex);
    if (buttonIndex == actionSheet.cancelButtonIndex) [actionSheet dismissWithClickedButtonIndex:actionSheet.cancelButtonIndex animated:YES];
    if (buttonIndex == 1)
    {
        [self.arrayOfChosedIngridients removeAllObjects];
        NSSortDescriptor *popularDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dishNumber" ascending:NO];
        [self loadIngridientsDataWithSearchDescriptor:popularDescriptor];
        
    }
    if (buttonIndex == 2)
    {
        [self.arrayOfChosedIngridients removeAllObjects];
        NSSortDescriptor *popularDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateAddedToFridge" ascending:NO];
        [self loadIngridientsDataWithSearchDescriptor:popularDescriptor];
        
    }
    if (buttonIndex == actionSheet.destructiveButtonIndex)
    {
        for (BZIngridient* ingridient in self.arrayOfChosedIngridients)
        {
            ingridient.isInFridge = [NSNumber numberWithBool:NO];
            
        }
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        [self.arrayOfChosedIngridients removeAllObjects];
        [self.tableView reloadData];
    }
    
}

#pragma mark - Methods (Public)

#pragma mark - Methods (Private)

- (void)loadData
{
    self.isLoading = YES;
    __weak BZFridgeViewController *weakSelf = self;
    
    self.currentOperation = [NSBlockOperation blockOperationWithBlock:^
                             {
                                 NSArray *arrayOfLoadDishes = [weakSelf requestSearchWithOffset:weakSelf.searchInset withWeakSelf: weakSelf];
                                 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                                                {
                                                    dispatch_async(dispatch_get_main_queue(), ^
                                                                   {
                                                                       weakSelf.isLoading = NO;
                                                                       [weakSelf.arrayOfSearchedIngridients addObjectsFromArray:arrayOfLoadDishes];
                                                                       //    [weakSelf.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
                                                                       [weakSelf.refreshControl endRefreshing];
                                                                       [weakSelf.tableView reloadData];
                                                                   });
                                                });
                             }];
    [self.currentOperation start];
}

-(NSArray *)requestSearchWithOffset: (NSInteger)offset withWeakSelf:(BZFridgeViewController *) weakSelf
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"nameOfIngridient contains[c] %@",self.searchIngridient.text];
    NSFetchRequest *itemRequest;
    
    //  if ([self.searchIngridient.text isEqual:@""]) itemRequest = [BZIngridient MR_requestAllWithPredicate:predicate2];
    if ([weakSelf.searchIngridient.text isEqual:@""])
    {
        itemRequest = [BZIngridient MR_requestAll];
        weakSelf.numberOfSearched = [BZIngridient MR_countOfEntities];
    }
    else
    {
        itemRequest = [BZIngridient MR_requestAllWithPredicate:predicate];
        weakSelf.numberOfSearched = [BZIngridient MR_countOfEntitiesWithPredicate:predicate];
    }
    [itemRequest setFetchLimit:20];
    [itemRequest setFetchOffset: offset];
    NSSortDescriptor *popularDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dishNumber" ascending:NO];
    [itemRequest setSortDescriptors:[NSArray arrayWithObject:popularDescriptor]];
    NSArray *items = [BZIngridient MR_executeFetchRequest:itemRequest];
    weakSelf.searchInset = weakSelf.searchInset + 20;
    return items;
}

- (void)loadIngridientsDataWithSearchDescriptor:(NSSortDescriptor *) descriptor
{
    // self.isLoading = YES;
    __weak BZFridgeViewController *weakSelf = self;
    
    NSArray *arrayOfLoadDishes = [self requestChosedWithOffset:weakSelf.chosedInset withWeakSelf:weakSelf withDescriptor:descriptor];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
                       dispatch_async(dispatch_get_main_queue(), ^
                                      {
                                          //   weakSelf.isLoading = NO;
                                          [weakSelf.arrayOfChosedIngridients addObjectsFromArray:arrayOfLoadDishes];
                                          //  [weakSelf.refreshControl endRefreshing];
                                          //  [weakSelf.tableView reloadData];
                                          NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 1)];
                                          [weakSelf.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
                                      });
                       
                       
                   });
}

-(NSArray *)requestChosedWithOffset:(NSInteger)offset
                       withWeakSelf:(BZFridgeViewController *)weakSelf
                     withDescriptor:(NSSortDescriptor *)descriptor
{
    NSPredicate *predicate2 =[NSPredicate predicateWithFormat:@"isInFridge == 1"];
    NSFetchRequest *itemRequest;
    
    itemRequest = [BZIngridient MR_requestAllWithPredicate:predicate2];
    [itemRequest setFetchOffset: offset];
    if (descriptor)
    {
        [itemRequest setSortDescriptors:[NSArray arrayWithObject:descriptor]];
    }
    NSArray *items = [BZIngridient MR_executeFetchRequest:itemRequest];
    weakSelf.searchInset = weakSelf.searchInset + 20;
    return items;
}

#pragma mark - Standard Methods

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - SearchBarDelegate

- (IBAction)findRecipes:(id)sender
{
    BZSearchRecipesViewController *searchRecipesController = [BZSearchRecipesViewController new];
    searchRecipesController.theIngridientsArray = self.arrayOfChosedIngridients;
    [self.navigationController pushViewController:searchRecipesController animated:YES];
}

@end































