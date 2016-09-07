//
//  FridgeViewController.h
//  Fridge
//
//  Created by User on 03.02.16.
//  Copyright © 2016 BZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BZFridgeViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate ,UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchIngridient;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *theFindButton;

- (IBAction)findRecipes:(id)sender;

@end






























