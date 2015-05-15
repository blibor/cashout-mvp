//
//  AppDelegate.m
//  Cash Out
//
//  Created by Stefan Walkner on 01.04.15.
//  Copyright (c) 2015 Cashout App GbR. All rights reserved.
//

#import <UIImage+ImageWithColor/UIImage+ImageWithColor.h>
#import <MTDates/NSDate+MTDates.h>
#import "AppDelegate.h"
#import "COStartViewController.h"
#import "COAConstants.h"
#import "COADataFetcher.h"
#import "COACurrencies.h"
#import "COADataHelper.h"
#import "COACountryDeterminator.h"
#import "COANotificationHelper.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <LUKeychainAccess/LUKeychainAccess.h>

@interface AppDelegate ()

@property (nonatomic, strong) UINavigationController *startNavigationController;
@property (nonatomic, strong) COACountryDeterminator *countryDeterminator;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];

    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    [NSTimeZone setDefaultTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];

    COStartViewController *startViewController = [[COStartViewController alloc] initWithNibName:nil bundle:nil];
    self.startNavigationController = [[UINavigationController alloc] initWithRootViewController:startViewController];

    self.window.rootViewController = self.startNavigationController;

    [self.startNavigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    self.startNavigationController.navigationBar.shadowImage = [UIImage new];
    self.startNavigationController.navigationBar.translucent = NO;
    self.startNavigationController.view.backgroundColor = [UIColor clearColor];
    self.startNavigationController.navigationBar.backgroundColor = [UIColor clearColor];

    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[COAConstants darkBlueColor]}];

    [self initializeUserDefaults];
    
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];

    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

    [self.window makeKeyAndVisible];

    [Fabric with:@[CrashlyticsKit]];
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    if ([COADataFetcher userId] == 0) {
        [[COADataFetcher instance] createUser];
    }

    self.countryDeterminator = [COACountryDeterminator instance];
    [[COADataHelper instance] tradeEnds];
}

- (void)initializeUserDefaults {
    [[LUKeychainAccess standardKeychainAccess] registerDefaults:@{MONEY_USER_SETTING : @(100000)}];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    UIApplication *app = [UIApplication sharedApplication];
    
    //create new uiBackgroundTask
    __block UIBackgroundTaskIdentifier bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    if ([[COADataHelper instance] tradeRunning]) {
        [AppDelegate sendWinLossNotification];
    }
    [[COADataHelper instance] tradeEnds];
}

+ (void)sendWinLossNotification {
    double winLoss = [[COADataHelper instance] currentWinLoss];
    NSString *formatString = winLoss >= 0 ? NSLocalizedString(@"notificationWon", @"") : NSLocalizedString(@"notificationLost", @"");

    if (winLoss < 0) {
        winLoss *= -1;
    }

    NSString *message = [NSString stringWithFormat:formatString, winLoss];
    [COANotificationHelper scheduleLocalNotificationWithKey:@"alsdkjflaksjf" onDate:[[NSDate date] mt_dateSecondsAfter:2] message:message];
}

@end
