//
// Created by Stefan Walkner on 13.04.15.
// Copyright (c) 2015 Cashout App GbR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface COAChartView : UIView

- (void)updateChartWithValues:(NSArray *)values fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;

@end