//
//  NSString+JudgementLawfulLogic.h
//  FCUtils
//
//  Created by 宋明月 on 2017/4/10.
//  Copyright © 2017年 宋明月. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString(NSString_JudgementLawfulLogic)

//手机号是否合法
- (BOOL)isLawfulPhoneNumber;

//身份证是否合法
- (BOOL)isLawfulIdNumber;

//身份证是男的吗
- (BOOL)isMan;

-(NSString *)birthdayStrFromIdentityCard;

/**钱的属性字符串*/
- (NSMutableAttributedString *)attributedStringWithDecimalBeforeFontSize:(float)beforeFontSize
                                                           afterFontSize:(float)afterFontSize
                                                         beforeFontColor:(UIColor *)beforeFontColor
                                                         afterFontColor:(UIColor *)afterFontColor;

/**钱的属性字符串带￥符号的*/
- (NSMutableAttributedString *)attributedStringWithDecimalAndMarkBeforeFontSize:(float)beforeFontSize
                                                                  afterFontSize:(float)afterFontSize
                                                                beforeFontColor:(UIColor *)beforeFontColor
                                                                 afterFontColor:(UIColor *)afterFontColor;

- (NSMutableAttributedString *)attributedStringWithDecimalBeforeFontSize:(float)beforeFontSize
                                                           afterFontSize:(float)afterFontSize;

//安全字符串
- (NSString *)safetyStringWithAfterRangeLength:(NSInteger)afterLengthNumber
                             beforeRangeLength:(NSInteger)beforeRangeNumber;

- (NSMutableAttributedString *)highlightKeyWordAttributedString:(NSString *)message
                                                        keyWord:(NSString *)keyWord;
@end
