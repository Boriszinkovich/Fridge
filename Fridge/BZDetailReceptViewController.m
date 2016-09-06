//
//  BZDetailReceptViewController.m
//  Fridge
//
//  Created by User on 08.02.16.
//  Copyright © 2016 BZ. All rights reserved.
//

#import "BZDetailReceptViewController.h"
#import "BZIngridientsCell.h"
#import "BZWayToCookCell.h"
#import "BZRecipeStepsCell.h"
#import <MagicalRecord/MagicalRecord.h>

@interface BZDetailReceptViewController () <WYPopoverControllerDelegate>

{
    WYPopoverController *choosePortionsPopoverController;
}
@property (strong,nonatomic) NSString *dishSteps;
@property (strong,nonatomic) NSString *ingridientsText;
@property (assign, nonatomic) NSInteger portionsCount;
@property (assign, nonatomic) BOOL isClosing;
@property (assign, nonatomic) BOOL isPresenting;

@end


static NSString *ingrsCellIdentidier = @"ingrsCellIdentidier";
static NSString *wayToCookCellIdentidier = @"wayToCookCellIdentidier";
static NSString *stepsCellIdentifier = @"stepsCellIdentifier";


@implementation BZDetailReceptViewController

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
    self.portionsCount = 1;
    self.ingridientsText = [NSString stringWithFormat:@"%@",self.dish.ingridients];
    UIImage *theNotSelectedImage = [UIImage imageNamed:@"likeWhiteEmpty.png"];
    UIImage *theSelectedImage = [UIImage imageNamed:@"likeWhiteFull.png"];
    UIButton *theFavouriteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [theFavouriteButton setImage:theNotSelectedImage forState:UIControlStateNormal];
    [theFavouriteButton setImage:theSelectedImage forState:UIControlStateSelected];
    [theFavouriteButton addTarget:self action:@selector(addToFavourite:) forControlEvents:UIControlEventTouchUpInside];
    [theFavouriteButton setFrame:CGRectMake(0, 0, 33, 33)];
    if ([self.dish.isFavourite boolValue]) [theFavouriteButton setSelected:YES];
    else [theFavouriteButton setSelected:NO];
    UIBarButtonItem *theFavouriteBurButtonItem = [[UIBarButtonItem alloc] initWithCustomView:theFavouriteButton];
    self.navigationItem.rightBarButtonItem = theFavouriteBurButtonItem;
    
    
    
    self.edgesForExtendedLayout = UIRectEdgeTop;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
        NSArray *list=self.navigationController.navigationBar.subviews;
        for (id obj in list)
        {
            if ([obj isKindOfClass:[UIImageView class]])
            {
                UIImageView *imageView=(UIImageView *)obj;
                imageView.alpha=0;
            }
        }
    }
    
    
    self.listTableV = [[UITableView alloc]initWithFrame:self.view.frame];
    self.listTableV.delegate = self;
    self.listTableV.dataSource = self;
    self.listTableV.scrollsToTop = YES;
    self.listTableV.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.listTableV];
    
    NSString* theRecipeName = [self.dish.nameOfDish stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        self.headerView = [[XLHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200) backGroudImageName:[NSString stringWithFormat:@"c%@",self.dish.image] subTitle:theRecipeName];
    else self.headerView = [[XLHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 300) backGroudImageName:[NSString stringWithFormat:@"c%@",self.dish.image] subTitle:theRecipeName];
    self.headerView.scrollView = self.listTableV;
    [self.view addSubview:self.headerView];
    
    [self.listTableV registerNib:[UINib nibWithNibName:@"BZDetailRecipeCells" bundle:nil] forCellReuseIdentifier:ingrsCellIdentidier];
    [self.listTableV registerNib:[UINib nibWithNibName:@"BZRecipeDetailCellWayToCook" bundle:nil] forCellReuseIdentifier:wayToCookCellIdentidier];
    NSString* theDishStepsString = [NSString stringWithString:self.dish.steps];
    theDishStepsString =  [theDishStepsString stringByReplacingOccurrencesOfString:@"&" withString:@"\n\n• "];
    theDishStepsString = [theDishStepsString substringToIndex:[theDishStepsString length] - 2];
    theDishStepsString = [NSString stringWithFormat:@"• %@",theDishStepsString];
    self.dishSteps = theDishStepsString;
    NSLog(@"%@",self.dish.ingridients);
    self.listTableV.estimatedRowHeight = 60;
    self.listTableV.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark - Create Views & Variables

#pragma mark - Actions

- (void)save:(id)sender
{
    UINavigationController *navController =  (UINavigationController*)choosePortionsPopoverController.contentViewController;
    BZChoosePortionsViewController *chosedPortions = [navController.viewControllers firstObject];
    self.portionsCount = chosedPortions.currentSelectedRaw + 1;
    [self methodChangePortions];
    [self.listTableV reloadData];
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    BZIngridientsCell *cell = [self.listTableV cellForRowAtIndexPath:path];
    [cell.buttonChangePortions setTitle:[NSString stringWithFormat:@"%ld",(long)self.portionsCount]forState:UIControlStateNormal];
    [self changePortionsLabel];
    
    
    [choosePortionsPopoverController dismissPopoverAnimated:YES completion:^
     {
         [self popoverControllerDidDismissPopover:choosePortionsPopoverController];
     }];
    
}

- (void)close:(id)theSender
{
    
    [choosePortionsPopoverController dismissPopoverAnimated:YES completion:^
     {
         [self popoverControllerDidDismissPopover:choosePortionsPopoverController];
     }];
}

- (void)addToFavourite:(UIButton *)theButton
{
    if ([theButton isSelected])
    {
        [theButton setSelected:NO];
        NSPredicate *thePredicate = [NSPredicate  predicateWithFormat:@"nameOfDish == %@", self.dish.nameOfDish];
        NSArray *theDishesArray = [BZDish MR_findAllWithPredicate:thePredicate];
        BZDish *theBZDish = [theDishesArray objectAtIndex:0];
        theBZDish.isFavourite= [NSNumber numberWithBool:NO];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        [self.delegate changedFavourite:NO];
    }
    else
    {
        [theButton setSelected:YES];
        NSPredicate *thePredicate = [NSPredicate  predicateWithFormat:@"nameOfDish == %@", self.dish.nameOfDish];
        NSArray *theDishesArray = [BZDish MR_findAllWithPredicate:thePredicate];
        BZDish *theBZDish = [theDishesArray objectAtIndex:0];
        theBZDish.isFavourite= [NSNumber numberWithBool:YES];
        theBZDish.dateAddedToFavourites = [NSDate date];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        [self.delegate changedFavourite:YES];
    }
}

- (void)changePortionsLabel
{
    NSIndexPath *thePath = [NSIndexPath indexPathForRow:0 inSection:0];
    BZIngridientsCell *theIngridientsCell = [self.listTableV cellForRowAtIndexPath:thePath];
    if (self.portionsCount == 1)
    {
        theIngridientsCell.portionLabel.text = @"Порция";
        return;
    }
    if (self.portionsCount < 5)
    {
        theIngridientsCell.portionLabel.text = @"Порции";
        return;
    }
    theIngridientsCell.portionLabel.text = @"Порций";
}

#pragma mark - Gestures

#pragma mark - Delegates (UITableViewDelgate & UITableViewDataSource)

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_headerView updateSubViewsWithScrollOffset:scrollView.contentOffset];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        BZIngridientsCell* theBZIngridientsCell = [self.listTableV dequeueReusableCellWithIdentifier:ingrsCellIdentidier];
        if (theBZIngridientsCell == nil)
        {
            theBZIngridientsCell = [[BZIngridientsCell alloc]
                                    initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:ingrsCellIdentidier];
        }
        [theBZIngridientsCell.buttonChangePortions addTarget:self
                                                      action:@selector(portionsChanged:)
                                            forControlEvents:UIControlEventTouchDown];
        theBZIngridientsCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return theBZIngridientsCell;
    }
    if (indexPath.row == 1)
    {
        BZRecipeStepsCell* theBZRecipeStepsCell = [self.listTableV dequeueReusableCellWithIdentifier:stepsCellIdentifier];
        if (!theBZRecipeStepsCell)
        {
            theBZRecipeStepsCell = [[BZRecipeStepsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:stepsCellIdentifier];
        }
        theBZRecipeStepsCell.theRecipeStepsLabel.text = self.ingridientsText;
        theBZRecipeStepsCell.theRecipeStepsLabel.numberOfLines = 0;
        theBZRecipeStepsCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return theBZRecipeStepsCell;
        
    }
    if (indexPath.row == 2)
    {
        BZWayToCookCell* theWayToCookCell = [self.listTableV dequeueReusableCellWithIdentifier:wayToCookCellIdentidier];
        if (theWayToCookCell == nil)
        {
            theWayToCookCell = [[BZWayToCookCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                      reuseIdentifier:wayToCookCellIdentidier];
        }
        theWayToCookCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return theWayToCookCell;
    }
    if (indexPath.row == 3)
    {
        BZRecipeStepsCell* theRecipeStepsCell = [self.listTableV dequeueReusableCellWithIdentifier:stepsCellIdentifier];
        if (!theRecipeStepsCell){
            theRecipeStepsCell = [[BZRecipeStepsCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                          reuseIdentifier:stepsCellIdentifier];
        }
        theRecipeStepsCell.selectionStyle = UITableViewCellSelectionStyleNone;
        theRecipeStepsCell.theRecipeStepsLabel.text = self.dishSteps;
        theRecipeStepsCell.theRecipeStepsLabel.numberOfLines = 0;
        return theRecipeStepsCell;
    }
    static NSString *theCellIdentifier = @"theCell";
    UITableViewCell *theTableViewCell = [tableView dequeueReusableCellWithIdentifier:theCellIdentifier ];
    if (theTableViewCell == nil)
    {
        theTableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:theCellIdentifier];
    }
    theTableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    theTableViewCell.textLabel.text = [NSString stringWithFormat:@"cell index %d",(int)indexPath.row];
    
    theTableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return theTableViewCell;
    
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.delegate detailViewDismissed];
    /*  if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
     [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
     NSArray *list=self.navigationController.navigationBar.subviews;
     for (id obj in list) {
     if ([obj isKindOfClass:[UIImageView class]]) {
     UIImageView *imageView=(UIImageView *)obj;
     imageView.alpha=1;
     }
     }
     
     }*/
    
}

#pragma mark - Delegates (WYPopoverControllerDelegate)

- (void)popoverControllerWasDeallocated
{
    self.isClosing = NO;
}

- (void)popoverControllerDidPresentPopover:(WYPopoverController *)controller
{
    self.isPresenting = NO;
    NSLog(@"popoverControllerDidPresentPopover");
}

- (BOOL)popoverControllerShouldDismissPopover:(WYPopoverController *)controller
{
    return YES;
}

- (void)popoverControllerDidDismissPopover:(WYPopoverController *)controller
{
    if (controller == choosePortionsPopoverController)
    {
        choosePortionsPopoverController.delegate = nil;
        choosePortionsPopoverController = nil;
        self.isClosing = NO;
    }
}

- (BOOL)popoverControllerShouldIgnoreKeyboardBounds:(WYPopoverController *)popoverController
{
    return YES;
}

- (void)popoverController:(WYPopoverController *)popoverController willTranslatePopoverWithYOffset:(double *)value
{
    // keyboard is shown and the popover will be moved up by 163 pixels for example ( *value = 163 )
    *value = 0; // set value to 0 if you want to avoid the popover to be moved
}

#pragma mark - Methods (Public)

#pragma mark - Methods (Private)

- (void)methodChangePortions
{
    NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789/,-%"];
    NSString *ingrStr = self.dish.ingridients;
    NSRange searchRange = NSMakeRange(0, [ingrStr length]);
    NSRange range;
    NSMutableArray *arrayOfRanges = [NSMutableArray array];
    NSRange currentRange = NSMakeRange(-2, 0);
    NSRange numberRange = NSMakeRange(-2, 0);
    NSMutableArray *arrayWithNumbers = [NSMutableArray array] ;
    while ((range = [ingrStr rangeOfCharacterFromSet:numbers options:0 range:searchRange]).location != NSNotFound)
    {
        if (currentRange.location == (range.location - 1))
        {
            numberRange = NSMakeRange(numberRange.location, numberRange.length + 1);
        }
        else
        {
            if(numberRange.location != -2)
            {
                [arrayOfRanges addObject:[NSValue valueWithRange:numberRange]];
            }
            numberRange = range;
        }
        currentRange = range;
        searchRange = NSMakeRange(NSMaxRange(range), [ingrStr length] - NSMaxRange(range));
    }
    if(numberRange.location != -2)
    {
        [arrayOfRanges addObject:[NSValue valueWithRange:numberRange]];
    }
    for (NSValue *value in arrayOfRanges)
    {
        NSRange range = [value rangeValue];
        [arrayWithNumbers addObject:[ingrStr substringWithRange:range]];
        NSLog(@"%@",[ingrStr substringWithRange:range]);
    }
    NSMutableArray *arrayWithChangedNumbers = [NSMutableArray array];
    for (NSString* str in arrayWithNumbers)
    {
        if ([str isEqual:@","])
        {
            [arrayWithChangedNumbers addObject:str];
            continue;
        }
        if ([str isEqual:@"-"])
        {
            [arrayWithChangedNumbers addObject:str];
            continue;
        }
        if ([str isEqual:@"/"])
        {
            [arrayWithChangedNumbers addObject:str];
            continue;
        }
        if ([str isEqual:@"%"])
        {
            [arrayWithChangedNumbers addObject:str];
            continue;
        }
        NSString *lastChar = [str substringFromIndex:[str length] - 1];
        if ([lastChar isEqual:@"%"])
        {
            [arrayWithChangedNumbers addObject:str];
            continue;
        }
        
        NSRange defizRange = [str rangeOfString:@"-"];
        if (defizRange.location != NSNotFound)
        {
            NSArray *separatedNumbers = [str componentsSeparatedByString:@"-"];
            NSInteger firstValue = [[separatedNumbers objectAtIndex:0] integerValue];
            NSInteger secondValue = [[separatedNumbers objectAtIndex:1] integerValue];
            firstValue = firstValue* self.portionsCount;
            secondValue = secondValue* self.portionsCount;
            NSString *newStr = [NSString stringWithFormat:@"%ld-%ld",(long)firstValue,(long)secondValue];
            [arrayWithChangedNumbers addObject:newStr];
            continue;
        }
        NSRange dotRange = [str rangeOfString:@","];
        if (dotRange.location != NSNotFound)
        {
            NSString *str2 = [str stringByReplacingOccurrencesOfString:@"," withString:@"."];
            float floatNumber = str2.floatValue;
            floatNumber *= self.portionsCount;
            str2 = [NSString stringWithFormat:@"%.2f",floatNumber];
            str2 = [str2 stringByReplacingOccurrencesOfString:@"." withString:@","];
            [arrayWithChangedNumbers addObject:str2];
            continue;
        }
        NSRange shtrihRange = [str rangeOfString:@"/"];
        if (shtrihRange.location != NSNotFound)
        {
            NSArray *separatedNumbers = [str componentsSeparatedByString:@"/"];
            NSInteger firstValue = [[separatedNumbers objectAtIndex:0] integerValue];
            NSInteger secondValue = [[separatedNumbers objectAtIndex:1] integerValue];
            firstValue = firstValue* self.portionsCount;
            NSString *newStr = [NSString stringWithFormat:@"%ld/%ld",(long)firstValue,(long)secondValue];
            [arrayWithChangedNumbers addObject:newStr];
            continue;
            
        }
        NSInteger strNumber = [str integerValue];
        strNumber *= self.portionsCount;
        NSString *newValue = [NSString stringWithFormat:@"%ld",(long)strNumber];
        [arrayWithChangedNumbers addObject:newValue];
    }
    NSArray *newArrayOfRanges = [[arrayOfRanges reverseObjectEnumerator] allObjects];
    NSArray *newArrayWithChangedNumbers = [[arrayWithChangedNumbers reverseObjectEnumerator] allObjects];
    for (int i = 0; i < [newArrayWithChangedNumbers count];i++)
    {
        NSValue *currentRangeValue = [newArrayOfRanges objectAtIndex:i];
        NSRange currentRange = [currentRangeValue rangeValue];
        ingrStr =  [ingrStr stringByReplacingCharactersInRange:currentRange withString:[newArrayWithChangedNumbers objectAtIndex:i]];
    }
    self.ingridientsText = ingrStr;
    for (NSString *strValue in arrayWithChangedNumbers)
    {
        NSLog(@"%@",strValue);
    }
}

#pragma mark - Standard Methods

-(void)portionsChanged:(UIButton*)theChangeButton
{
    if (self.isPresenting)
    {
        return;
    }
    if (choosePortionsPopoverController == nil)
    {
        UIView *theButtonView = theChangeButton;
        static NSString *theChangePortionsControllerIdentifier = @"changePortionsControllerIdentifier";
        BZChoosePortionsViewController *thePortionsViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:theChangePortionsControllerIdentifier];
        thePortionsViewController.preferredContentSize = CGSizeMake(320, 280);
        thePortionsViewController.currentSelectedRaw = self.portionsCount - 1;
        //  portionsViewController.title = @"Settings";
        
        [thePortionsViewController.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Сохранить"
                                                                                                        style:UIBarButtonItemStylePlain      target:self
                                                                                                       action:@selector(save:)]];
        
        [thePortionsViewController.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc]
                                                                         initWithTitle:@"Отмена"
                                                                         style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(close:)]];
        
        thePortionsViewController.modalInPopover = NO;
        
        UINavigationController *theNzvigationViewController = [[UINavigationController alloc] initWithRootViewController:thePortionsViewController];
        WYPopoverController *theWYPopoverController = [[WYPopoverController alloc] initWithContentViewController:theNzvigationViewController];
        choosePortionsPopoverController = theWYPopoverController;
        choosePortionsPopoverController.delegate = self;
        choosePortionsPopoverController.passthroughViews = @[theButtonView];
        choosePortionsPopoverController.popoverLayoutMargins = UIEdgeInsetsMake(10, 10, 10, 10);
        choosePortionsPopoverController.wantsDefaultContentAppearance = NO;
        self.isPresenting = YES;
        [choosePortionsPopoverController presentPopoverFromRect:theButtonView.bounds
                                                         inView:theButtonView
                                       permittedArrowDirections:WYPopoverArrowDirectionAny
                                                       animated:YES
                                                        options:WYPopoverAnimationOptionFadeWithScale];
    }
    else
    {
        if (self.isClosing)
        {
            return;
        }
        self.isClosing = YES;
        [self close:nil];
    }
    
    NSLog(@"buttonClicked");
}

@end






























