//
//  FCAlertLabel.h
//  FCUtils
//
//  Created by 宋明月 on 2017/4/10.
//  Copyright © 2017年 宋明月. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


static CGFloat kAlertLabelTag = 100;
@interface FCAlertLabel : NSObject

/**
 *  创建AlertLabel实例
 *
 *  @return AlertLabel对象
 */
+ (instancetype)sharedAlertLabel;

/**
 *  弹出AlertLabel
 *
 *  @param alertString AlertLabel上显示的字
 */
- (void)showAlertLabelWithAlertString:(NSString *)alertString;
- (void)hideAlertLabeImmediatelyIfShowing;

@end
