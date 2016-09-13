//
//  BZIngridient.m
//  
//
//  Created by User on 11.09.16.
//
//

#import "BZIngridient.h"

#import "BZDish.h"
#import "EnIngridient.h"
#import "BZAppDelegate.h"

@implementation BZIngridient

// Insert code here to add functionality to your managed object subclass

- (NSString *)methodGetLocalizedName
{
    BZAppDelegate *appDelegate = (BZAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.isRussian)
    {
        return self.nameOfIngridient;
    }
    else
    {
        return self.toEnIngridient.enNameOfIngridient;
    }
}

@end
