//
//  BZDetailReceptViewController.h
//  Fridge
//
//  Created by User on 08.02.16.
//  Copyright © 2016 BZ. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XLHeaderView.h"
#import "BZDish.h"
#import "BZDetailDismissedProtocol.h"
#import "WYPopoverController.h"
#import "BZChoosePortionsViewController.h"

@interface BZDetailReceptViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *listTableV;
@property (nonatomic, strong) XLHeaderView *headerView;
@property (nonatomic, strong) BZDish *dish;
@property (nonatomic, weak) id<BZDetailDismissedProtocol> delegate;

@end






























