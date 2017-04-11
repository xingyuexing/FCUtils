//
//  DateLogic.h
//  FCUtils
//
//  Created by 宋明月 on 2017/4/10.
//  Copyright © 2017年 宋明月. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RelationId : NSObject

@property (strong, nonatomic) NSString *index;
@property (strong, nonatomic) NSString *name;

@end



@interface DateLogic : NSObject

/**获取当前时间的YYYYMMddHHmmss格式字符串*/
+ (NSString *)getCurrentYYYYMMddHHmmss;

// 根据出生日期的秒值计算年龄
+ (NSInteger)ageWithDateOfBirthSceond:(long long)bornDate;

//  根据出生日期计算年龄
+ (NSInteger)ageWithDateOfBirth:(NSDate *)date;

// 根据出生日期的String值计算年龄
+ (NSString *)birthdayChangeToAge:(NSString *) birthdayStr;

/** add by 2.9.0 20151204 xuyue
 *  描述:根据生日字符串，返回年龄(如年龄小月1个月，显示X天；如年龄小一年，X月X天；如年龄小于三年，显示X年X个月；大于三年仅显示X年)
 *  认证方式:	默认签名
 *  @param  birthdayStr 格式为yyyyMMdd生日字符串
 *  @return age         年龄
 */
+ (NSString *)birthdayChangeToLimitAge:(NSString *)birthdayStr;

+ (NSMutableArray *)relationIdArrayInit;

+ (NSString *)relationIDToString:(NSString *) relationID;

/**获取传入日期的yyyyMMdd格式日期*/
+ (NSString *)getStringWithDate:(NSDate *)date;

+ (NSString *)getStringWithDateLikeYYYYMMddHHmmss:(NSDate *)date;

//将YYYYMMddHHmmss字符串转成日期
+ (NSDate *)getDateByYYYYMMddHHmmss:(NSString *)yyyyMMddHHmmss;


+ (NSDate *)getDateByYYYYMMdd:(NSString *)yyyyMMdd;

+ (NSString *)getStringWithDate:(NSDate *)date withFormatter:(NSString *)formatterStr;
//获取当前日期的前一年返回yyyyMMdd格式日期
+ (NSString *)getLastYear;
//获取当前日期的前半年返回yyyyMMdd格式日期
+ (NSString *)getLastHalfYear;
//获取当前日期的前一个月返回yyyyMMdd格式日期
+ (NSString *)getLastMonth;

+ (NSDateComponents *)getComponentFromeDate:(NSDate *)date;

+ (NSDateComponents *)getComponentFromeTwoDate :(NSDate *)fromDate toDate:(NSDate *)toDate;

+(NSDate *)getDateWithDateStr:(NSString *)dateStr withFormatter:(NSString *)formatterStr;
//把服务器传回的日期格式转化为要显示的样式显示
+ (NSString *)getStringWithFormatter:(NSString *)formatterStr withServDateStr:(NSString *)servDateStr
                 andServFormatterStr:(NSString *)servFormatterStr;

/**获取当前时间若干年后的1月1日（年前传负数）*/
+ (NSDate *)getDateWithYearTimeIntervalSinceNow:(NSInteger)interval;

/**消息页 获得格式化的本地接收到的推送时间*/
+ (NSString *)getNoticeFormatMsgDateString:(NSString *)msgDateString;

/** 获取yy-MM-dd 格式时间字符串 */
+ (NSString *)getyyMMddFromyyyyMMddHHmmss:(NSString *)dateString;

//获取当前时间是否在设定的开始时间，结束时间段里
+ (BOOL)currentDateIsInDateSinceDate:(NSString *)fromDateStr toDate:(NSString *)toDateStr;

//获取当前时间是否大于结束时间
+ (BOOL)currentDateGreaterThanEndDate:(NSString *)endDateStr;

//获取星期
+ (NSString *)getWeekWithString:(NSString *)dateString;

//获取 yyyy-M-d EEEE
+ (NSString *)getWeekDayWith:(NSString *)dateString;
@end
