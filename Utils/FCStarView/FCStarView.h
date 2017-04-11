//
//  FCStarView.h
//  FCUtils
//
//  Created by 宋明月 on 2017/4/10.
//  Copyright © 2017年 宋明月. All rights reserved.
//


#import <UIKit/UIKit.h>
@class FCStarView;
@protocol CWStarRateViewDelegate <NSObject>
@optional
- (void)starRateView:(FCStarView *)starRateView scroePercentDidChange:(CGFloat)newScorePercent;
@end

typedef NS_ENUM(NSInteger, ShowStarType) {//显示类型
    SHOW_STAR,//显示星星
    SHOW_DIAMOND//显示钻
};

@interface FCStarView : UIView
//得分值峰值
@property (nonatomic, assign) CGFloat maxValue;

//得分精确度（不是整星才有效果）
@property (nonatomic, assign) CGFloat accuracy;

//得分值
@property (nonatomic, assign) int currentValue;

//是否允许动画，默认为NO
@property (nonatomic, assign) BOOL hasAnimation;

//百分比
@property (nonatomic, assign) CGFloat scorePercent;

//评分时是否允许不是整星，默认为YES
@property (nonatomic, assign) BOOL allowIncompleteStar;

@property (nonatomic, assign)id<CWStarRateViewDelegate>delegate;
- (instancetype)initWithFrame:(CGRect)frame
            withNumberOfStars:(NSInteger)numberOfStars
                  withPercent:(CGFloat)percent
   withUserInteractionEnabled:(BOOL)interactionEnabled;

//添加分类，星星和钻显示方式
- (instancetype)initWithFrame:(CGRect)frame
            withNumberOfStars:(NSInteger)numberOfStars
                  withPercent:(CGFloat)percent
   withUserInteractionEnabled:(BOOL)interactionEnabled
             withShowStarType:(ShowStarType)showStarType;

- (void)refrushStarViewEnabled:(BOOL)interactionEnabled;
@end

