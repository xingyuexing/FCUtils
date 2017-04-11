//
//  FCBottompopView.h
//  FCUtils
//
//  Created by 宋明月 on 2017/4/10.
//  Copyright © 2017年 宋明月. All rights reserved.
//  底部弹出窗口

#import <UIKit/UIKit.h>

@protocol FCBottompopViewDelegate <NSObject>

- (void)selectIndex:(NSInteger)index;

@end

@interface FCBottompopView : UIView

@property (nonatomic,assign) NSInteger selectIndex;
@property (nonatomic,assign) id<FCBottompopViewDelegate>delegate;

- (id)initWithTitleArray:(NSArray *)titleArray;


- (void)show;

@end

