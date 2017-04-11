//
//  FCUtils.h
//  FCUtils
//
//  Created by 宋明月 on 2017/4/10.
//  Copyright © 2017年 宋明月. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for FCUtils.
FOUNDATION_EXPORT double FCUtilsVersionNumber;

//! Project version string for FCUtils.
FOUNDATION_EXPORT const unsigned char FCUtilsVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <FCUtils/PublicHeader.h>



#define  StatusBarHeight                 20.0
#define  NavigationBarHeight             44.0
#define  TabBarHeight                    49.0
#define  ScreenWidth                    ([UIScreen mainScreen].bounds.size.width)
#define  ScreenHeight                   ([UIScreen mainScreen].bounds.size.height)
#define  DefaultCellHeight               44.0
#define  DefaultSectionHeight            0.01
#define  DefaultMargin                   15.0
#define  TIMGroup_DrInfoKey             @"TIMGroup_DrInfoKey"

#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242,2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750,1334), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640,1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640,960), [[UIScreen mainScreen] currentMode].size) : NO)
// 颜色定义
#define DEFAULT_BACKGROUND_COLOR [UIColor colorWithRed:0xf5/255.0 green:0xf5/255.0 blue:0xf5/255.0 alpha:1.0]
#define DEFAULT_LINE_COLOR [UIColor colorWithRed:0xE5/255.0 green:0xE5/255.0 blue:0xE5/255.0 alpha:1.0]
#define DEFAULT_BLACK_TEXT_COLOR [UIColor colorWithRed:0x33/255.0 green:0x33/255.0 blue:0x33/255.0 alpha:1.0]
#define DEFAULT_BLUE_COLOR [UIColor colorWithRed:51/255.0 green:132/255.0 blue:214/255.0 alpha:1.0]
#define DEFAULT_GRAY_TEXT_COLOR [UIColor colorWithRed:0x66/255.0 green:0x66/255.0 blue:0x66/255.0 alpha:1.0]
#define LIGHT_GRAY_TEXT_COLOR [UIColor colorWithRed:0x99/255.0 green:0x99/255.0 blue:0x99/255.0 alpha:1.0]
#define GRAY_BODER_COLOR [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0]
#define WARN_RED_COLOR [UIColor colorWithRed:0xed/255.0 green:0x5e/255.0 blue:0x5e/255.0 alpha:1.0]
#define ORANGE_COLOR [UIColor colorWithRed:0xf5/255.0 green:0xb0/255.0 blue:0x15/255.0 alpha:1.0]
#define DEFAULT_BUTTON_UNENABLE_COLOR [UIColor colorWithRed:0xcc/255.0 green:0xcc/255.0 blue:0xcc/255.0 alpha:1.0]
//textField.placeholder颜色
#define PLACEHOLDER_TEXT_COLOR [UIColor colorWithRed:0xc7/255.0 green:0xc7/255.0 blue:0xcc/255.0 alpha:1.0]

#define CARD_COLOR_GREEN [UIColor colorWithRed:0x8c/255.0 green:0xd1/255.0 blue:0x49/255.0 alpha:1.0]

#define CARD_COLOR_BLUE [UIColor colorWithRed:0x4b/255.0 green:0xa1/255.0 blue:0xff/255.0 alpha:1.0]

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define APPDELEGATE_FCPViewDidAppearNotification @"APPDELEGATE_FCPViewDidAppearNotification"

