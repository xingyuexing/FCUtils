//
//  UIView+XYLayout.h
//  FCUtils
//
//  Created by 宋明月 on 2017/4/10.
//  Copyright © 2017年 宋明月. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (XYLayout)

- (CGFloat)mssLeft;
- (CGFloat)mssRight;
- (CGFloat)mssBottom;
- (CGFloat)mssTop;
- (CGFloat)mssHeight;
- (CGFloat)mssWidth;

- (void)setMssX:(CGFloat)mssX;
- (void)setMssY:(CGFloat)mssY;
- (void)setMssWidth:(CGFloat)mssWidth;
- (void)setMssHeight:(CGFloat)mssHeight;

- (void)mss_setFrameInSuperViewCenterWithSize:(CGSize)size;

@end
