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
#import "EnDish.h"
#import "EnIngridient.h"

@interface BZAppDelegate ()<TGLGuillotineMenuDelegate>

@end

static NSString *fridgeViewControllerIdentifier = @"FridgeViewControllerIdentifier";
static NSString *recipeViewControllerIdentifier = @"RecipeViewControllerIdentifier";
static NSString *helpDevelopersControllerIdentifier = @"HelpDevelopersControllerIdentifier";

@implementation BZAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self methodConfigureLocale];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                             forBarMetrics:UIBarMetricsDefault];
    }
    
    NSURL *defaultStorePath = [NSPersistentStore MR_defaultLocalStoreUrl];
    defaultStorePath = [[defaultStorePath URLByDeletingLastPathComponent] URLByAppendingPathComponent:[MagicalRecord defaultStoreName]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSURL *seedPath = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Fridge" ofType:@"sqlite"]];
    NSLog(@"%@", [defaultStorePath path]);
    if (![fileManager fileExistsAtPath:[defaultStorePath path]])
    {
        NSError *err = nil;
//        NSURL *seedPath2 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Fridge" ofType:@"sqlite-shm"]];
//        if (![fileManager copyItemAtURL:seedPath2 toURL:defaultStorePath error:&err])
//        {
//            NSLog(@"Could not copy seed data. error: %@", err);
//        }
//        NSURL *seedPath3 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Fridge" ofType:@"sqlite-val"]];
//        if (![fileManager copyItemAtURL:seedPath3 toURL:defaultStorePath error:&err])
//        {
//            NSLog(@"Could not copy seed data. error: %@", err);
//        }
        NSURL *seedPath = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Fridge" ofType:@"sqlite"]];
        NSLog(@"Core data store does not yet exist at: %@. Attempting to copy from seed db %@.", [defaultStorePath path], [seedPath path]);
        [self createPathToStoreFileIfNeccessary:defaultStorePath];
        
        if (![fileManager copyItemAtURL:seedPath toURL:defaultStorePath error:&err])
        {
            NSLog(@"Could not copy seed data. error: %@", err);
        }

    }

    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"Fridge.sqlite"];
    
//    NSArray *theDishArray = [BZDish MR_findAll];
//    [self methodLoadDishFromDishArray:theDishArray withindex:0];
//    [self methodLoadDishStepsFromDishArray:theDishArray withindex:0];
//    [self methodLoadRealDishStepsFromDishArray:theDishArray withindex:0];
//    NSArray *theIngridientsArray = [BZIngridient MR_findAll];
//    [self methodLoadIndgridientFromIngridientsArray:theIngridientsArray withindex:0];
//    [[UINavigationBar appearance] setBarTintColor:[self colorWithHexString:@"728AA8"]];
//    NSLog(@"%ld",(long)[BZDish MR_countOfEntities]);
    
    
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    
    
    
    
    
    
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self methodInitStoreKit];
    


   // BZAllRecipesViewController* recipeController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:recipeViewControllerIdentifier];
    BZAllRecipesViewController *recipeController = [[BZAllRecipesViewController alloc] init];
    BZFavouritesViewController *favouritesController = [[BZFavouritesViewController alloc] init];
    BZFridgeViewController *fridgeViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:fridgeViewControllerIdentifier];
//        BZHelpDevelopersViewController *helpDev = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:helpDevelopersControllerIdentifier];
//    NSArray *vcArray        = [[NSArray alloc] initWithObjects:fridgeViewController, recipeController, favouritesController, helpDev, nil];
//    NSArray *titlesArray    = [[NSArray alloc] initWithObjects:@"Холодильник", @"Рецепты", @"Избранное", @"Помощь разработчикам", nil];
//    NSArray *imagesArray    = [[NSArray alloc] initWithObjects:@"bz_fridge", @"bz_recipes", @"bz_favourite", @"bz_helpForDev", nil];
    NSArray *vcArray        = [[NSArray alloc] initWithObjects:fridgeViewController, recipeController, favouritesController, nil];
    NSArray *titlesArray    = [[NSArray alloc] initWithObjects:NSLocalizedString(@"My fridge", @""), NSLocalizedString(@"Recipes", @""), NSLocalizedString(@"Favourite", @""), nil];
    NSArray *imagesArray    = [[NSArray alloc] initWithObjects:@"bz_fridge", @"bz_recipes", @"bz_favourite", nil];
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

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait) ;
}

- (void)methodInitStoreKit
{
    [[MKStoreKit sharedKit] startProductRequest];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitProductsAvailableNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note)
     {
         
         NSLog(@"Products available: %@", [[MKStoreKit sharedKit] availableProducts]);
     }];
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitProductPurchasedNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note)
     {
         
         NSLog(@"Purchased/Subscribed to product with id: %@", [note object]);
     }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitRestoredPurchasesNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note)
     {
         
         NSLog(@"Restored Purchases");
     }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitRestoringPurchasesFailedNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note)
     {
         
         NSLog(@"Failed restoring purchases with error: %@", [note object]);
     }];
}

- (void)methodLoadIndgridientFromIngridientsArray:(NSArray *)theIngridientsArray withindex:(NSInteger)theIndex
{
    BZURLSession *theSession = [BZURLSession new];
    NSString *theSpecialString = ((BZIngridient *)theIngridientsArray[theIndex]).nameOfIngridient;
    
    NSString *theLoadUrlString =  [NSString stringWithFormat:@"https://translate.yandex.net/api/v1.5/tr.json/translate?key=trnsl.1.1.20160911T105655Z.6116b12d6a1d3bee.fff9014233dacb60650ba28f6b8f1c2d28136cb3&lang=ru-en&text=%@", [theSpecialString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]] ;
    //    NSURL *theNSURL = [NSURL URLWithString:[theLoadUrlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]];
    NSURL *theNSURL = [NSURL URLWithString:theLoadUrlString];
    NSDictionary *theMapDictionary = [NSDictionary new];
    NSData *thePostData = [NSJSONSerialization dataWithJSONObject:theMapDictionary options:0 error:nil];
    [theSession methodStartPostTaskWithURL:theNSURL withPostData:thePostData progressBlock:nil completionBlockWithData:^(NSData * _Nullable data, NSError * _Nullable theError)
     {
         [BZExtensionsManager methodAsyncMainWithBlock:^
         {
             NSDictionary *theResultDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                                 options:kNilOptions
                                                                                   error:nil];
             NSLog(@"%@", theResultDictionary);
             NSLog(@"%@", theResultDictionary[@"text"][0]);
             BZIngridient *theCurrentingridient = theIngridientsArray[theIndex];
             NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
             
             
             // Somewhere else
             EnIngridient *p = [EnIngridient MR_createEntityInContext:context];
             
             // And in yet another method
             p.enNameOfIngridient = theResultDictionary[@"text"][0];
             p.toBZIngridient = theCurrentingridient;
             [context MR_saveToPersistentStoreAndWait];
             NSInteger theNewIndex = theIndex + 1;
             if (theNewIndex >= theIngridientsArray.count)
             {
                 return ;
             }
             [self methodLoadIndgridientFromIngridientsArray:theIngridientsArray withindex:theNewIndex];
         }];
     }];
}

- (void)methodLoadDishFromDishArray:(NSArray *)theDishArray withindex:(NSInteger)theIndex
{
    BZURLSession *theSession = [BZURLSession new];
    BZDish *theCurrentDish = theDishArray[theIndex];
    NSString *theSpecialString = theCurrentDish.nameOfDish;
    
    NSString *theLoadUrlString =  [NSString stringWithFormat:@"https://translate.yandex.net/api/v1.5/tr.json/translate?key=trnsl.1.1.20160911T105655Z.6116b12d6a1d3bee.fff9014233dacb60650ba28f6b8f1c2d28136cb3&lang=ru-en&text=%@", [theSpecialString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]] ;
    //    NSURL *theNSURL = [NSURL URLWithString:[theLoadUrlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]];
    NSURL *theNSURL = [NSURL URLWithString:theLoadUrlString];
    NSDictionary *theMapDictionary = [NSDictionary new];
    NSData *thePostData = [NSJSONSerialization dataWithJSONObject:theMapDictionary options:0 error:nil];
    [theSession methodStartPostTaskWithURL:theNSURL withPostData:thePostData progressBlock:nil completionBlockWithData:^(NSData * _Nullable data, NSError * _Nullable theError)
     {
         [BZExtensionsManager methodAsyncMainWithBlock:^
          {
              NSDictionary *theResultDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                                  options:kNilOptions
                                                                                    error:nil];
              NSLog(@"%@", theResultDictionary);
              NSLog(@"%@", theResultDictionary[@"text"][0]);
              NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
              
              
              // Somewhere else
              EnDish *p = [EnDish MR_createEntityInContext:context];
              
              // And in yet another method
              p.enNameOfDish = theResultDictionary[@"text"][0];
              p.toBZDish = theCurrentDish;
              [context MR_saveToPersistentStoreAndWait];
              NSInteger theNewIndex = theIndex + 1;
              if (theNewIndex >= theDishArray.count)
              {
                  return ;
              }
              [self methodLoadDishFromDishArray:theDishArray withindex:theNewIndex];
          }];
     }];
}

- (void)methodLoadDishStepsFromDishArray:(NSArray *)theDishArray withindex:(NSInteger)theIndex
{
    BZURLSession *theSession = [BZURLSession new];
    BZDish *theCurrentDish = theDishArray[theIndex];
    NSString *theSpecialString = theCurrentDish.ingridients;
    
    NSString *theLoadUrlString =  [NSString stringWithFormat:@"https://translate.yandex.net/api/v1.5/tr.json/translate?key=trnsl.1.1.20160911T105655Z.6116b12d6a1d3bee.fff9014233dacb60650ba28f6b8f1c2d28136cb3&lang=ru-en&text=%@", [theSpecialString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]] ;
    //    NSURL *theNSURL = [NSURL URLWithString:[theLoadUrlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]];
    NSURL *theNSURL = [NSURL URLWithString:theLoadUrlString];
    NSDictionary *theMapDictionary = [NSDictionary new];
    NSData *thePostData = [NSJSONSerialization dataWithJSONObject:theMapDictionary options:0 error:nil];
    [theSession methodStartPostTaskWithURL:theNSURL withPostData:thePostData progressBlock:nil completionBlockWithData:^(NSData * _Nullable data, NSError * _Nullable theError)
     {
         [BZExtensionsManager methodAsyncMainWithBlock:^
          {
              NSDictionary *theResultDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                                  options:kNilOptions
                                                                                    error:nil];
              NSLog(@"%@", theResultDictionary);
              NSLog(@"%@", theResultDictionary[@"text"][0]);
              NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
              
              
              // Somewhere else
              EnDish *p = theCurrentDish.toEnDish;
              
              // And in yet another method
              p.enIngridients = theResultDictionary[@"text"][0];
              [context MR_saveToPersistentStoreAndWait];
              NSInteger theNewIndex = theIndex + 1;
              if (theNewIndex >= theDishArray.count)
              {
                  return ;
              }
              [self methodLoadDishStepsFromDishArray:theDishArray withindex:theNewIndex];
          }];
     }];
}


- (void)methodLoadRealDishStepsFromDishArray:(NSArray *)theDishArray withindex:(NSInteger)theIndex
{
    BZURLSession *theSession = [BZURLSession new];
    BZDish *theCurrentDish = theDishArray[theIndex];
    NSString *theSpecialString = theCurrentDish.steps;
    theSpecialString = [theSpecialString stringByReplacingOccurrencesOfString:@"&" withString:@"\n"];
    NSLog(@"%@", theSpecialString);
    NSString *theLoadUrlString =  [NSString stringWithFormat:@"https://translate.yandex.net/api/v1.5/tr.json/translate?key=trnsl.1.1.20160911T105655Z.6116b12d6a1d3bee.fff9014233dacb60650ba28f6b8f1c2d28136cb3&lang=ru-en&text=%@", [theSpecialString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]] ;
    //    NSURL *theNSURL = [NSURL URLWithString:[theLoadUrlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]];
    NSURL *theNSURL = [NSURL URLWithString:theLoadUrlString];
    NSDictionary *theMapDictionary = [NSDictionary new];
    NSData *thePostData = [NSJSONSerialization dataWithJSONObject:theMapDictionary options:0 error:nil];
    [theSession methodStartPostTaskWithURL:theNSURL withPostData:thePostData progressBlock:nil completionBlockWithData:^(NSData * _Nullable data, NSError * _Nullable theError)
     {
         [BZExtensionsManager methodAsyncMainWithBlock:^
          {
              NSDictionary *theResultDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                                  options:kNilOptions
                                                                                    error:nil];
              NSLog(@"%@", theResultDictionary);
              NSLog(@"%@", theResultDictionary[@"text"][0]);
              if (!theResultDictionary[@"text"])
              {
                  return;
              }
              NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
              
              
              // Somewhere else
              EnDish *p = theCurrentDish.toEnDish;
              if (!p)
              {
                  return;
              }
              // And in yet another method
              p.enSteps = theResultDictionary[@"text"][0];
              [context MR_saveToPersistentStoreAndWait];
              NSInteger theNewIndex = theIndex + 1;
              if (theNewIndex >= theDishArray.count)
              {
                  return ;
              }
              [self methodLoadRealDishStepsFromDishArray:theDishArray withindex:theNewIndex];
          }];
     }];
}

- (void)methodConfigureLocale
{
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if (!language || isEqual(language, @""))
    {
        return;
    }
    NSArray *theArray = [language componentsSeparatedByString:@"-"];
    language = theArray[0];
    if (isEqual(language, @"ru") || isEqual(language, @"uk"))
    {
        self.isRussian = YES;
    }
    NSLog(@"%@", language);
}

@end






























