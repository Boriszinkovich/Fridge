//
//  NSDate+BZExtensions.m
//  ismc
//
//  Created by Boris Zinkovich on 21.06.16.
//  Copyright © 2016 itvsystems. All rights reserved.
//

#import "NSDate+BZExtensions.h"

@implementation NSDate (BZExtensions)

#pragma mark - Class Methods (Public)

#pragma mark - Class Methods (Private)

#pragma mark - Init & Dealloc

#pragma mark - Setters (Public)

#pragma mark - Getters (Public)

#pragma mark - Setters (Private)

#pragma mark - Getters (Private)

#pragma mark - Lifecycle

#pragma mark - Create Views & Variables

#pragma mark - Actions

#pragma mark - Gestures

#pragma mark - Delegates ()

#pragma mark - Methods (Public)

#pragma mark - Methods (Private)

- (BOOL)_occuredDaysBeforeToday:(NSUInteger) nDaysBefore
{
    NSDate *now = [NSDate date];  // now
    NSDate *today;
    [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit // beginning of this day
                                    startDate:&today // save it here
                                     interval:NULL
                                      forDate:now];
    
    NSDateComponents *comp = [[NSDateComponents alloc] init];
    comp.day = -nDaysBefore;      // lets go N days back from today
    NSDate * before = [[NSCalendar currentCalendar] dateByAddingComponents:comp
                                                                    toDate:today
                                                                   options:0];
    if ([self compare: before] == NSOrderedDescending) {
        if ( [self compare:today] == NSOrderedAscending ) {
            return YES;
        }
    }
    return NO;
}


- (BOOL)dayOccuredDuringLast7Days
{
    return [self _occuredDaysBeforeToday:7];
}

- (BOOL)dayWasYesterday
{
    return [self _occuredDaysBeforeToday:1];
}

#pragma mark - Standard Methods

@end






























