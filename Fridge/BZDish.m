//
//  BZDish.m
//  
//
//  Created by User on 11.09.16.
//
//

#import "BZDish.h"

#import "BZIngridient.h"
#import "EnDish.h"
#import "BZAppDelegate.h"

@implementation BZDish

// Insert code here to add functionality to your managed object subclass
- (NSString *)methodGetLocalizedName
{
    BZAppDelegate *appDelegate = (BZAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.isRussian)
    {
        return self.nameOfDish;
    }
    else
    {
        return self.toEnDish.enNameOfDish;
    }
}

- (NSString *)methodGetLocalizedIngridients
{
    BZAppDelegate *appDelegate = (BZAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.isRussian)
    {
        return self.ingridients;
    }
    else
    {
        return self.toEnDish.enIngridients;
    }
}

- (NSString *)methodGetLocalizedSteps
{
    BZAppDelegate *appDelegate = (BZAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.isRussian)
    {
        return self.steps;
    }
    else
    {
        return self.toEnDish.enSteps;
    }
}

@end
