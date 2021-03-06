//
// Created by Stefan Walkner on 18.04.15.
// Copyright (c) 2015 Cashout App GbR. All rights reserved.
//

#import <LUKeychainAccess/LUKeychainAccess.h>
#import "COADataHelper.h"
#import "COAConstants.h"
#import "NSDate+MTDates.h"
#import "COADataFetcher.h"


@implementation COADataHelper

+ (COADataHelper *)instance {
    static COADataHelper *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}

- (NSDate *)toDateDayScaleForSymbol:(NSString *)symbol {
    NSDate *returnDate = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"day-%@", symbol]];

    if (!returnDate) {
        returnDate = [[NSDate date] mt_dateMonthsBefore:13];
    }

    return returnDate;
}

- (NSDate *)toDateHourScaleForSymbol:(NSString *)symbol {
    NSDate *returnDate = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"hour-%@", symbol]];

    if (!returnDate) {
        returnDate = [[NSDate date] mt_dateDaysBefore:6];
    }

    return returnDate;

}

- (NSDate *)toDateMinuteScaleForSymbol:(NSString *)symbol {
    NSDate *returnDate = [[NSDate date] mt_dateMinutesBefore:100];

    if (!returnDate) {
        returnDate = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"minute-%@", symbol]];
    }

    return returnDate;
}

- (void)tradeStarts {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"traderunning"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)tradeEnds {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"traderunning"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)tradeRunning {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"traderunning"];
}

- (void)setCurrentWinLoss:(double)winLoss {
    [[NSUserDefaults standardUserDefaults] setDouble:winLoss forKey:@"currentWinLoss"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (double)currentWinLoss {
    return [[NSUserDefaults standardUserDefaults] doubleForKey:@"currentWinLoss"];
}

- (void)saveDayScaleForSymbol:(NSString *)symbol date:(NSDate *)toDate {
    [[NSUserDefaults standardUserDefaults] setObject:toDate forKey:[NSString stringWithFormat:@"day-%@", symbol]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)saveHourScaleForSymbol:(NSString *)symbol date:(NSDate *)toDate {
    [[NSUserDefaults standardUserDefaults] setObject:toDate forKey:[NSString stringWithFormat:@"hour-%@", symbol]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)saveMinuteScaleForSymbol:(NSString *)symbol date:(NSDate *)toDate {
    [[NSUserDefaults standardUserDefaults] setObject:toDate forKey:[NSString stringWithFormat:@"minute-%@", symbol]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)saveMoney:(double)money {
    [[LUKeychainAccess standardKeychainAccess] setDouble:money forKey:MONEY_USER_SETTING];

    [[COADataFetcher instance] updateBalance];
}

- (double)money {
    return [[LUKeychainAccess standardKeychainAccess] doubleForKey:MONEY_USER_SETTING];
}

- (void)setTutorialSeen {
    [[NSUserDefaults standardUserDefaults] setDouble:YES forKey:TUTORIAL_SEEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)tutorialSeen {
    return [[NSUserDefaults standardUserDefaults] boolForKey:TUTORIAL_SEEN];
}

- (void)setOnboardingSeen {
    [[NSUserDefaults standardUserDefaults] setDouble:YES forKey:ONBOARDING_SEEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)onboardingSeen {
    return [[NSUserDefaults standardUserDefaults] boolForKey:ONBOARDING_SEEN];
}

@end