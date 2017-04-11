//
//  FCCalender.h
//  FCUtils
//
//  Created by 宋明月 on 2017/4/10.
//  Copyright © 2017年 宋明月. All rights reserved.
//  日历控件

#import <UIKit/UIKit.h>
@protocol FCCalenderDelegate <NSObject>

//选择的日期
- (void)selectWithDate:(NSDate *)date;

@end

@interface FCCalender : UIView

@property (nonatomic ,assign) id<FCCalenderDelegate>delegate;
@property (nonatomic ,strong) NSDate *selectDate;

- (instancetype)initWithFrame:(CGRect)frame dataArr:(NSArray *)dataArr;

@end
