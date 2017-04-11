//
//  UILogic.h
//  FCUtils
//
//  Created by 宋明月 on 2017/4/10.
//  Copyright © 2017年 宋明月. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol NXUILogicDelegate <NSObject>
@optional
- (void)backBarButtonItemAction;
/** 去搜索代理事件 */
- (void)goSearchAction;

@end

@interface UILogic : NSObject
@property (nonatomic, weak) id <NXUILogicDelegate> delegate;

+ (UILogic *)sharedInstance;

// 获取字符串所占的高度
- (CGFloat)getHeightByText:(NSString *)aString
                     width:(CGFloat)width
                  fontSize:(CGFloat)font
                     space:(CGFloat)space;

// 获取单行字所占的宽度
- (CGFloat)getWidthByText:(NSString *)aString
                     font:(UIFont *)font
                   height:(CGFloat)height;

- (NSAttributedString *)attributedStringWithString:(NSString *)text
                                         textColor:(UIColor *)color
                                          fontSize:(UIFont *)font
                                          rowSpace:(CGFloat)space;

- (UIImage *)headImgByRelationId:(NSString *)relationId gender:(NSString *)gender;

//返回与 我 的成员关系
- (NSString *)getRelationShip:(NSString *)relationId;

- (NSString *)stringByStringArray:(NSArray *)array;

// 获取血型 ID
- (NSString *)getBloodTypeID:(NSString *)bloodTypeStr;

// 获取血型
- (NSString *)getBloodTypeString:(NSString *)bloodTypeID;

// 数字大于万的表示为x.x万
- (NSString *)transNumToTenThousandsUnit:(NSString *)orginalNum;

/** custom backBarButtonItem */
- (void)customBackBarButtonItem:(UIViewController *)viewController title:(NSString *)title;

/** titleView */
- (UIView *)searchTitleView;

/** GetNormalWindow */
- (UIWindow *)getNormalWindow;

//判断如果头像URL无.png则添加 否则不添加
- (NSString *)formatImageUrl:(NSString *)url;

@end
