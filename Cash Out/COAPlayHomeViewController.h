//
// Created by Stefan Walkner on 01.04.15.
// Copyright (c) 2015 Cashout App GbR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "COAAbstractViewController.h"

@class COAButton;

@interface COAPlayHomeViewController : COAAbstractViewController

@property (nonatomic, strong, readonly) COAButton *tradeButton;

- (void)setCurrencySymbol:(NSString *)currencySymbol;

- (CGFloat)lowerNavigationBar;

- (CGFloat)upperScrollView;

- (CGFloat)lowerScrollView;

- (CGFloat)upperRiseButton;

- (CGFloat)lowerRiseButton;

- (CGFloat)upperPlayButton;

- (CGFloat)lowerPlayButton;

@end
