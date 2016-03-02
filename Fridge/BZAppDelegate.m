//
//  AppDelegate.m
//  Fridge
//
//  Created by User on 02.02.16.
//  Copyright © 2016 BZ. All rights reserved.
//

#import "BZAppDelegate.h"
#import "TGLGuillotineMenu.h"
#import "BZIngridient.h"
#import "BZHelpDevelopersViewController.h"
#import "BZFridgeViewController.h"
#import <MagicalRecord/MagicalRecord.h>
#import "BZAllRecipesViewController.h"
#import "BZDish.h"
#import "BZFavouritesViewController.h"
@interface BZAppDelegate ()<TGLGuillotineMenuDelegate>

@end

static NSString *fridgeViewControllerIdentifier = @"FridgeViewControllerIdentifier";
static NSString *recipeViewControllerIdentifier = @"RecipeViewControllerIdentifier";
static NSString *helpDevelopersControllerIdentifier = @"HelpDevelopersControllerIdentifier";

@implementation BZAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                             forBarMetrics:UIBarMetricsDefault];
    }
    
    NSURL *defaultStorePath = [NSPersistentStore MR_defaultLocalStoreUrl];
    defaultStorePath = [[defaultStorePath URLByDeletingLastPathComponent] URLByAppendingPathComponent:[MagicalRecord defaultStoreName]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:[defaultStorePath path]])
    {
        NSURL *seedPath = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Fridge" ofType:@"sqlite"]];
        NSLog(@"Core data store does not yet exist at: %@. Attempting to copy from seed db %@.", [defaultStorePath path], [seedPath path]);
        [self createPathToStoreFileIfNeccessary:defaultStorePath];
        
        NSError *err = nil;
        if (![fileManager copyItemAtURL:seedPath toURL:defaultStorePath error:&err])
        {
            NSLog(@"Could not copy seed data. error: %@", err);
        }
    }

    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"Fridge.sqlite"];
    
    [[UINavigationBar appearance] setBarTintColor:[self colorWithHexString:@"728AA8"]];
    NSLog(@"%ld",(long)[BZDish MR_countOfEntities]);
    
    
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    
    
    
    
    
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    BZHelpDevelopersViewController *helpDev = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:helpDevelopersControllerIdentifier];
   // BZAllRecipesViewController* recipeController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:recipeViewControllerIdentifier];
    BZAllRecipesViewController *recipeController = [[BZAllRecipesViewController alloc] init];
    BZFavouritesViewController *favouritesController = [[BZFavouritesViewController alloc] init];
    BZFridgeViewController *fridgeViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:fridgeViewControllerIdentifier];
    NSArray *vcArray        = [[NSArray alloc] initWithObjects:fridgeViewController, recipeController, favouritesController, helpDev, nil];
    NSArray *titlesArray    = [[NSArray alloc] initWithObjects:@"Холодильник", @"Рецепты", @"Избранное", @"Помощь разработчикам", nil];
    NSArray *imagesArray    = [[NSArray alloc] initWithObjects:@"bz_fridge", @"bz_recipes", @"bz_favourite", @"bz_helpForDev", nil];
    
    TGLGuillotineMenu *menuVC = [[TGLGuillotineMenu alloc] initWithViewControllers:vcArray MenuTitles:titlesArray andImagesTitles:imagesArray andStyle:TGLGuillotineMenuStyleTable];
    menuVC.delegate = self;
    
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:menuVC];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = navController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
}


- (void) createPathToStoreFileIfNeccessary:(NSURL *)urlForStore {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *pathToStore = [urlForStore URLByDeletingLastPathComponent];
    
    NSError *error = nil;
    [fileManager createDirectoryAtPath:[pathToStore path] withIntermediateDirectories:YES attributes:nil error:&error];
}
#pragma mark - Guillotine Menu Delegate

-(void)selectedMenuItemAtIndex:(NSInteger)index
{
    NSLog(@"Selected menu item at index %ld", (long)index);
}

-(void)menuDidOpen{
    NSLog(@"Menu did Open");
}

-(void)menuDidClose{
    NSLog(@"Menu did Close");
}

-(UIColor *)colorWithHexString:(NSString *)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString length] < 6) return [UIColor grayColor];
    
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

@end






























