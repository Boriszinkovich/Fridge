//
//  BZChoosePortionsViewController.m
//  Fridge
//
//  Created by User on 11.02.16.
//  Copyright © 2016 BZ. All rights reserved.
//

#import "BZChoosePortionsViewController.h"

@interface BZChoosePortionsViewController ()

@property (strong, nonatomic) NSArray *dataArray;

@end

@implementation BZChoosePortionsViewController

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
    self.dataArray = [NSArray arrayWithObjects:@"1 порция", @"2 порции",@"3 порции",@"4 порции",@"5 порций",@"6 порций",@"7 порций",@"8 порций",@"9 порций",@"10 порций",nil];
    // Do any additional setup after loading the view.
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor blueColor]];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor blueColor]];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)dealloc
{
    NSLog(@"portions controller dismissed");
}

#pragma mark - Create Views & Variables

#pragma mark - Actions

#pragma mark - Gestures

#pragma mark - Delegates (UITableViewDelegate & UITableViewDatasource)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.currentSelectedRaw == indexPath.row)
    {
        return;
    }
    UITableViewCell *currentCell = [tableView cellForRowAtIndexPath:indexPath];
    currentCell.accessoryType = UITableViewCellAccessoryCheckmark;
    [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentSelectedRaw inSection:0]].accessoryType = UITableViewCellAccessoryNone;
    self.currentSelectedRaw = indexPath.row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
    
}

#pragma mark - Methods (Public)

#pragma mark - Methods (Private)

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.currentSelectedRaw == indexPath.row)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
}

#pragma mark - Standard Methods

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end






























