//
//  NSDictionary+KeySort.m
//  FCUtils
//
//  Created by 宋明月 on 2017/4/10.
//  Copyright © 2017年 宋明月. All rights reserved.
//

#import "NSDictionary+KeySort.h"

@implementation NSDictionary(NSDictionary_KeySort)

- (NSArray *)allSortStirngKeys {
    NSArray *sortArray = [[self allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    return sortArray;
}

@end
