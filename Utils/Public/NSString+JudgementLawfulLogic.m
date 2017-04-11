//
//  NSString+JudgementLawfulLogic.m
//  FCUtils
//
//  Created by 宋明月 on 2017/4/10.
//  Copyright © 2017年 宋明月. All rights reserved.
//

#import "NSString+JudgementLawfulLogic.h"
#import "FCUtils.h"

@implementation NSString(NSString_JudgementLawfulLogic)


//手机号是否合法
- (BOOL)isLawfulPhoneNumber {
    NSString *iRegex = @"^(13[0-9]|15[0-9]|14[0-9]|18[0-9]|17[0-9])[0-9]{8}$";
    NSPredicate *iTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", iRegex];
    if ([iTest evaluateWithObject:self]) {
        return YES;
    }
    else{
        return NO;
    }
}


#pragma mark -判断身份证号码中的地区码是否在下列地区码中

-(NSString *)getStringWithRange:(NSString *)str Value1:(NSInteger)value1 Value2:(NSInteger)value2

{
    
    return [str substringWithRange:NSMakeRange(value1, value2)];
    
}


//身份证是男的吗
- (BOOL)isMan {
    if (self == nil | self.length == 0) {
        return NO;
    }
    if (self.length == 15) {
        
        int idEndNumber = [[self substringFromIndex:self.length-1] intValue];
        if (idEndNumber%2 == 1) {
            return YES;
        }else{
            return NO;
        }
    }else if (self.length == 18) {
        NSString *subStr = [self substringFromIndex:16];
        NSString *thisStr = [subStr substringToIndex:1];
        if (thisStr == nil || thisStr.length == 0) {
            return NO;
        }else{
            int idEndNumber = [thisStr intValue];
            if (idEndNumber%2 == 1) {
                return YES;
            }else{
                return NO;
            }
        }
    }else{
        return NO;
    }
}

//钱的属性字符串
- (NSMutableAttributedString *)attributedStringWithDecimalBeforeFontSize:(float)beforeFontSize
                                                           afterFontSize:(float)afterFontSize
                                                         beforeFontColor:(UIColor *)beforeFontColor
                                                          afterFontColor:(UIColor *)afterFontColor {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:self];

    if (self.length < 1 || [self rangeOfString:@"."].location == NSNotFound ) {
        return attributedString;
    }
    if (beforeFontColor == nil) {
        beforeFontColor = [UIColor blackColor];
    }
    if (afterFontColor == nil) {
        afterFontColor = [UIColor blackColor];
    }
    NSArray *stringArray = [self componentsSeparatedByString:@"."];
    NSString *beforeString = [stringArray firstObject];
    NSString *afterString = [stringArray objectAtIndex:stringArray.count-1];
    
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:beforeFontSize] range:NSMakeRange(0, beforeString.length)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:afterFontSize] range:NSMakeRange(beforeString.length+1, afterString.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:beforeFontColor range:NSMakeRange(0, beforeString.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:afterFontColor range:NSMakeRange(beforeString.length+1, afterString.length)];
    
    return attributedString;
}


//钱的属性字符串
- (NSMutableAttributedString *)attributedStringWithDecimalAndMarkBeforeFontSize:(float)beforeFontSize
                                                           afterFontSize:(float)afterFontSize
                                                         beforeFontColor:(UIColor *)beforeFontColor
                                                          afterFontColor:(UIColor *)afterFontColor {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:self];
    
    if (self.length < 1 || [self rangeOfString:@"."].location == NSNotFound ) {
        return attributedString;
    }
    if (beforeFontColor == nil) {
        beforeFontColor = [UIColor blackColor];
    }
    if (afterFontColor == nil) {
        afterFontColor = [UIColor blackColor];
    }
    NSArray *stringArray = [self componentsSeparatedByString:@"."];
    NSString *beforeString = [stringArray firstObject];
    NSString *afterString = [stringArray objectAtIndex:stringArray.count-1];
    
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:beforeFontSize] range:NSMakeRange(0, beforeString.length)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:afterFontSize] range:NSMakeRange(beforeString.length+1, afterString.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:beforeFontColor range:NSMakeRange(0, beforeString.length+1)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:afterFontColor range:NSMakeRange(beforeString.length+1, afterString.length)];
    
    NSMutableAttributedString *markString = [[NSMutableAttributedString alloc]initWithString:@"￥"];
    [markString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:afterFontSize] range:NSMakeRange(0, 1)];
    [markString addAttribute:NSForegroundColorAttributeName value:afterFontColor range:NSMakeRange(0, 1)];
    [attributedString insertAttributedString:markString atIndex:0];
    
    return attributedString;
}

//钱的属性字符串
- (NSMutableAttributedString *)attributedStringWithDecimalBeforeFontSize:(float)beforeFontSize
                                                           afterFontSize:(float)afterFontSize {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:self];
    
    if (self.length < 1 || [self rangeOfString:@"."].location == NSNotFound ) {
        return attributedString;
    }

    NSArray *stringArray = [self componentsSeparatedByString:@"."];
    NSString *beforeString = [stringArray firstObject];
    NSString *afterString = [stringArray objectAtIndex:stringArray.count-1];
    
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:beforeFontSize] range:NSMakeRange(0, beforeString.length)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:afterFontSize] range:NSMakeRange(beforeString.length+1, afterString.length)];
    
    return attributedString;
}

//安全字符串
- (NSString *)safetyStringWithAfterRangeLength:(NSInteger)afterLengthNumber
                             beforeRangeLength:(NSInteger)beforeRangeNumber {
    
    NSInteger safeLength = self.length - afterLengthNumber - beforeRangeNumber;
    
    if (safeLength < 1) {
        
        return self;
        
    } else {
        
        NSMutableString *mutableStr = [[NSMutableString alloc]init];
        
        for (int i = 0; i < safeLength ; i ++) {
            [mutableStr appendString:@"*"];
        }
        
        NSString * string = [self stringByReplacingCharactersInRange:NSMakeRange(afterLengthNumber, safeLength) withString:mutableStr];
        
        return string;
    }
}


- (BOOL)isValidNumber:(NSString*)value{
    const char *cvalue = [value UTF8String];
    for (int i = 0; i < self.length; i++) {
        if(!isnumber(cvalue[i])){
            return NO;
        }
    }
    return YES;
}


-(NSString *)birthdayStrFromIdentityCard {
    NSString * numberStr = self;
    if(!numberStr)
        return nil;
    NSMutableString *result = [NSMutableString stringWithCapacity:0];
    NSString *year = nil;
    NSString *month = nil;
    
    BOOL isAllNumber = YES;
    NSString *day = nil;
    if([numberStr length]<14)
        return result;
    
    if(numberStr.length>15) {
        //**截取前14位
        NSString *fontNumer = [numberStr substringWithRange:NSMakeRange(0, 13)];
        
        //**检测前14位否全都是数字;
        const char *str = [fontNumer UTF8String];
        const char *p = str;
        while (*p!='\0') {
            if(!(*p>='0'&&*p<='9'))
                isAllNumber = NO;
            p++;
        }
        
        if(!isAllNumber)
            return result;
        
        year = [numberStr substringWithRange:NSMakeRange(6, 4)];
        month = [numberStr substringWithRange:NSMakeRange(10, 2)];
        day = [numberStr substringWithRange:NSMakeRange(12,2)];
        
        [result appendString:year];
//        [result appendString:@"-"];
        [result appendString:month];
//        [result appendString:@"-"];
        [result appendString:day];
        
    } else {
        
        NSString *year = [NSString stringWithFormat:@"%d",[numberStr substringWithRange:NSMakeRange(6,2)].intValue +1900];
        
        NSString * month = [numberStr substringWithRange:NSMakeRange(8, 2)];
        NSString * day = [numberStr substringWithRange:NSMakeRange(10,2)];
        
        [result appendString:year];
//        [result appendString:@"-"];
        [result appendString:month];
//        [result appendString:@"-"];
        [result appendString:day];
    }
    
    return result;
}

- (BOOL)isLawfulIdNumber {
    
    NSString * value = self;
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSUInteger length = 0;
    if (!value) {
        return NO;
    }else {
        length = value.length;
        
        if (length !=15 && length !=18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag =NO;
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }
    
    if (!areaFlag) {
        return false;
    }
    
    
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    
    int year =0;
    switch (length) {
        case 15:
            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
            
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                       options:NSRegularExpressionCaseInsensitive
                                                                         error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                       options:NSRegularExpressionCaseInsensitive
                                                                         error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                              options:NSMatchingReportProgress
                                                                range:NSMakeRange(0, value.length)];
            
            
            if(numberofMatch >0) {
                return YES;
            }else {
                return NO;
            }
        case 18:
            
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}(19|20)[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                       options:NSRegularExpressionCaseInsensitive
                                                                         error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}(19|20)[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                                                       options:NSRegularExpressionCaseInsensitive
                                                                         error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                              options:NSMatchingReportProgress
                                                                range:NSMakeRange(0, value.length)];
            
            
            if(numberofMatch >0) {
                int S = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                int Y = S %11;
                NSString *M =@"F";
                NSString *JYM =@"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
                if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
                    return YES;// 检测ID的校验位
                }else {
                    return NO;
                }
                
            }else {
                return NO;
            }
        default:
            return NO;
    }
}

- (NSMutableAttributedString *)highlightKeyWordAttributedString:(NSString *)message
                                                        keyWord:(NSString *)keyWord {
    
    if (message == nil) {
        message = @"";
    }
    
    if (keyWord == nil) {
        keyWord = @"";
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:self];
    
    BOOL hasNotNext = YES;
    NSString *tmepString = self;
    NSUInteger searchIndex = 0;
    
    while (hasNotNext && searchIndex < attributedString.length) {
        
        NSRange range = [tmepString rangeOfString:keyWord];
        
        if (range.location != NSNotFound) {
            // 找到的情况
            NSRange attributedRange = {searchIndex + range.location,range.length};
            [attributedString addAttribute:NSForegroundColorAttributeName
                                     value:DEFAULT_BLUE_COLOR
                                     range:attributedRange];
            
            searchIndex += (range.location + range.length);
            tmepString = [tmepString substringFromIndex:(range.location + range.length)];
        } else {
            // 没找到的情况
            hasNotNext = NO;
        }
    }
    
    return attributedString;
}

@end
