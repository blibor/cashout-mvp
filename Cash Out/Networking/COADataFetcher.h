//
// Created by Stefan Walkner on 03.04.15.
// Copyright (c) 2015 Cashout App GbR. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface COADataFetcher : NSObject
+ (COADataFetcher *)instance;


- (void)fetchDataForSymbol:(NSString *)symbol;

@end