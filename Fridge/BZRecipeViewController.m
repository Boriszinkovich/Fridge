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

#import <MagicalRecord/MagicalRecord.h>

@interface BZRecipeViewController ()

@end


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
    self.maxNumberOfDishes = [BZDish MR_countOfEntities];
    self.tableView.contentInset = UIEdgeInsetsMake(54,0,20,0);
    self.setWithDishes = [NSMutableSet set];
    self.arrayOfDishes = [NSMutableArray array];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView setNeedsLayout];
    [self.tableView layoutIfNeeded];
    
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
    self.tableView.contentInset = UIEdgeInsetsMake(0,0,20,0);
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

#pragma mark - Table view data source

@end






























