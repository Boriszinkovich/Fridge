//
//  RecipeViewController.m
//  Fridge
//
//  Created by User on 03.02.16.
//  Copyright © 2016 BZ. All rights reserved.
//

#import "BZRecipeViewController.h"

#import "BZRecipeCell.h"
#import "BZDish.h"
#import "TGLGuillotineMenu.h"

#import <MagicalRecord/MagicalRecord.h>

@interface BZRecipeViewController ()

@property (nonatomic, strong) TGLGuillotineMenu *menu;

@end

static CGFloat cellSpacing = 20;

@implementation BZRecipeViewController

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
    UITableView *tableView = [UITableView new];
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.theWidth = [UIScreen mainScreen].bounds.size.width;
    tableView.theHeight = [UIScreen mainScreen].bounds.size.height - 64;
    self.tableView = tableView;
    
    self.maxNumberOfDishes = [BZDish MR_countOfEntities];
    self.setWithDishes = [NSMutableSet set];
    self.arrayOfDishes = [NSMutableArray array];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    UINavigationController *rootNavVC = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    self.menu = (TGLGuillotineMenu *)rootNavVC.viewControllers.firstObject;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

- (void)dealloc
{
    NSLog(@"Oops, my view controller is released");
}

#pragma mark - Create Views & Variables

#pragma mark - Actions

#pragma mark - Gestures

#pragma mark - Delegates (UITableViewDelegate & UITableViewDatasource)

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.arrayOfDishes count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return cellSpacing;
}

- (void)changedFavourite:(BOOL) isFavourite
{
    
}

- (void)loadData
{
    
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section
{
    return cellSpacing;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view
       forSection:(NSInteger)section
{
    view.tintColor = [UIColor clearColor];
}

#pragma mark - Delegates (BZDetailDismissedProtocol)

- (void)detailViewDismissed
{
}

#pragma mark - Methods (Public)

#pragma mark - Methods (Private)

- (NSArray *)requestWithOffset:(int)offset
{
    
    NSFetchRequest *itemRequest = [BZDish MR_requestAll];
    [itemRequest setFetchLimit:15];
    [itemRequest setFetchOffset: offset];
    NSArray *items = [BZDish MR_executeFetchRequest:itemRequest];
    return items;
}

#pragma mark - Standard Methods

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)menuDidOpen
{
    
}

- (void)menuDidClose
{
    
}

- (void)selectedMenuItemAtIndex:(NSInteger)index
{
    
}

@end






























