//
//  DateLogic.m
//  FCUtils
//
//  Created by 宋明月 on 2017/4/10.
//  Copyright © 2017年 宋明月. All rights reserved.
//

#import "DateLogic.h"

@implementation RelationId

@end


typedef enum : NSInteger {
    AMMYear = 0,       // 年
    AMMMonth = 1,      // 月
    AMMDay = 2,        // 星期几
    AMMWeekDay = 3,    // 几号
    AMMHour = 4,       // 几点
    AMMMinute = 5,     // 几分
    AMMSecont = 6      // 几秒
} AMMDateComponent;

static NSMutableArray *relationIdArray = nil;

@implementation DateLogic

+ (NSString *)getCurrentYYYYMMddHHmmss {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    return [formatter stringFromDate:[NSDate date]];
}

+ (NSInteger)ageWithDateOfBirthSceond:(long long)bornDateSecond {
    NSDate *bornDate = [[NSDate alloc] initWithTimeIntervalSince1970:bornDateSecond/1000];
    return [self ageWithDateOfBirth:bornDate];
}

+ (NSInteger)ageWithDateOfBirth:(NSDate *)date {
    // 出生日期转换 年月日
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
    NSInteger brithDateYear  = [components1 year];
    NSInteger brithDateDay   = [components1 day];
    NSInteger brithDateMonth = [components1 month];
    
    // 获取系统当前 年月日
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    NSInteger currentDateYear  = [components2 year];
    NSInteger currentDateDay   = [components2 day];
    NSInteger currentDateMonth = [components2 month];
    
    // 计算年龄
    NSInteger iAge = currentDateYear - brithDateYear - 1;
    if ((currentDateMonth > brithDateMonth) || (currentDateMonth == brithDateMonth && currentDateDay >= brithDateDay)) {
        iAge ++;
    }
    
    return iAge;
}

// 根据生日计算年龄
+ (NSString *)birthdayChangeToAge:(NSString *) birthdayStr {
    if ([birthdayStr isEqualToString:@""] || birthdayStr == Nil) {
        return @"";
    }
    
    birthdayStr = [birthdayStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
    birthdayStr = [NSString stringWithFormat:@"%@000000", birthdayStr];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSDate *birthday = [formatter dateFromString:birthdayStr];
    
    if (birthday == nil) {
        if (birthdayStr.length > 4) {
            [formatter setDateFormat:@"yyyy"];
            birthdayStr = [birthdayStr substringToIndex:4];
            birthday = [formatter dateFromString:birthdayStr];
        }
    }
    if (birthday) {
        NSInteger bYear = [self getDateComponent:AMMYear date:birthday];
        NSInteger bMonth = [self getDateComponent:AMMMonth date:birthday];
        NSInteger bDay = [self getDateComponent:AMMDay date:birthday];
        
        NSDate *nowday = [NSDate date];
        NSInteger nYear = [self getDateComponent:AMMYear date:nowday];
        NSInteger nMonth = [self getDateComponent:AMMMonth date:nowday];
        NSInteger nDay = [self getDateComponent:AMMDay date:nowday];
        
        NSInteger age = nYear - bYear;
        if (nMonth < bMonth) {
            age --;
        } else if (nMonth == bMonth) {
            if (nDay < bDay) {
                age --;
            }
        }
        
        return [NSString stringWithFormat:@"%ld", (long)age];
    } else {
        return @"";
    }
}

//根据生日字符串，返回年龄(如年龄小月1个月，显示X天；如年龄小一年，X月X天；如年龄小于三年，显示X年X个月；大于三年仅显示X年)
+ (NSString *)birthdayChangeToLimitAge:(NSString *)birthdayStr {
    if ([birthdayStr isEqualToString:@""] || birthdayStr == Nil) {
        return @"";
    }
    birthdayStr = [NSString stringWithFormat:@"%@000000", birthdayStr];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSDate *birthday = [formatter dateFromString:birthdayStr];
    if (birthday == nil) {
        if (birthdayStr.length > 4) {
            [formatter setDateFormat:@"yyyy"];
            birthdayStr = [birthdayStr substringToIndex:4];
            birthday = [formatter dateFromString:birthdayStr];
        }
    }
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *compent = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:birthday toDate:[NSDate date] options:0];
    if (compent.year >= 3) {
        return [NSString stringWithFormat:@"%ld岁", (long)compent.year];
    } else if (compent.year >= 1 && compent.year < 3) {
        if (compent.month > 0) {
            return [NSString stringWithFormat:@"%ld岁%ld个月", (long)compent.year,(long)compent.month];
        } else {
            return [NSString stringWithFormat:@"%ld岁", (long)compent.year];
        }
        
    } else if (compent.year == 0) {
        if (compent.month == 0) {
            if (compent.day > 0) {
                return [NSString stringWithFormat:@"%ld天", (long)compent.day];
            } else {
                return [NSString stringWithFormat:@"1天"];
            }
        } else {
            if (compent.day > 0) {
                return [NSString stringWithFormat:@"%ld个月%ld天", (long)compent.month,(long)compent.day];
            } else {
                return [NSString stringWithFormat:@"%ld个月", (long)compent.month];
            }
        }
    } else {
        //其他情况
        return nil;
    }
}

// 获取一个NSDate中的年、月、日、时、分、秒
+ (NSInteger)getDateComponent:(AMMDateComponent)dateComponent date:(NSDate *)date {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:date];
    NSInteger year = [components year];
    NSInteger month = [components month];
    NSInteger day = [components day];
    NSInteger weekday = [components weekday]; // 1～7：周日～周六
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    NSInteger second = [components second];
    
    switch (dateComponent) {
        case AMMYear:
            return year;
            break;
        case AMMMonth:
            return month;
            break;
        case AMMDay:
            return day;
            break;
        case AMMWeekDay:
            return weekday;
            break;
        case AMMHour:
            return hour;
            break;
        case AMMMinute:
            return minute;
            break;
        case AMMSecont:
            return second;
            break;
            
        default:
            break;
    }
    
}

+ (NSMutableArray *)relationIdArrayInit {
    
    if (relationIdArray == nil) {
        relationIdArray = [NSMutableArray arrayWithCapacity:11];
        
        RelationId *relationIdTmp = [[RelationId alloc] init];
        relationIdTmp.index = @"1";
        relationIdTmp.name  = @"本人";
        [relationIdArray addObject:relationIdTmp];
        relationIdTmp = [[RelationId alloc] init];
        relationIdTmp.index = @"2";
        relationIdTmp.name  = @"母亲";
        [relationIdArray addObject:relationIdTmp];
        relationIdTmp = [[RelationId alloc] init];
        relationIdTmp.index = @"3";
        relationIdTmp.name  = @"父亲";
        [relationIdArray addObject:relationIdTmp];
        relationIdTmp = [[RelationId alloc] init];
        relationIdTmp.index = @"4";
        relationIdTmp.name  = NSLocalizedString(@"Brothers", @"");
        [relationIdArray addObject:relationIdTmp];
        relationIdTmp = [[RelationId alloc] init];
        relationIdTmp.index = @"5";
        relationIdTmp.name  = NSLocalizedString(@"Sister", @"");
        [relationIdArray addObject:relationIdTmp];
        relationIdTmp = [[RelationId alloc] init];
        relationIdTmp.index = @"6";
        relationIdTmp.name  = NSLocalizedString(@"Son", @"");
        [relationIdArray addObject:relationIdTmp];
        relationIdTmp = [[RelationId alloc] init];
        relationIdTmp.index = @"7";
        relationIdTmp.name  = NSLocalizedString(@"Daughter", @"");
        [relationIdArray addObject:relationIdTmp];
        relationIdTmp = [[RelationId alloc] init];
        relationIdTmp.index = @"8";
        relationIdTmp.name  = NSLocalizedString(@"Relatives", @"");
        [relationIdArray addObject:relationIdTmp];
        relationIdTmp = [[RelationId alloc] init];
        relationIdTmp.index = @"9";
        relationIdTmp.name  = NSLocalizedString(@"Friend", @"");
        [relationIdArray addObject:relationIdTmp];
        relationIdTmp = [[RelationId alloc] init];
        relationIdTmp.index = @"10";
        relationIdTmp.name  = NSLocalizedString(@"Other", @"");
        relationIdTmp = [[RelationId alloc] init];
        relationIdTmp.index = @"11";
        relationIdTmp.name  = NSLocalizedString(@"Spouse", @"");
        [relationIdArray addObject:relationIdTmp];
    }
    return relationIdArray;

}

+ (NSString *)relationIDToString:(NSString *) relationID {
    
    NSString *retString = @"";
    NSMutableArray * array = [DateLogic relationIdArrayInit];
    if (array) {
        for (int i=0; i<array.count; i++) {
            RelationId *tmp;
            if (relationIdArray.count > i) {
                tmp = [relationIdArray objectAtIndex:i];
            }
            if (tmp && [tmp.index isEqualToString:relationID]) {
                retString = tmp.name;
                break;
            }
        }
    }
    return retString;
}

+ (NSString *)getLastYear {
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSCalendarUnit dayInfoUnits  = NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *components = [gregorian components:dayInfoUnits fromDate:[NSDate date]];
    components.year --;
    
    NSDate * retDate =[gregorian dateFromComponents:components];
    
    return [DateLogic getStringWithDate:retDate];
}

+ (NSString *)getLastHalfYear {
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSCalendarUnit dayInfoUnits  = NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *components = [gregorian components:dayInfoUnits fromDate:[NSDate date]];
    components.month -= 6;
    
    NSDate * retDate =[gregorian dateFromComponents:components];
    
    return [DateLogic getStringWithDate:retDate];
}

+ (NSString *)getLastMonth {
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSCalendarUnit dayInfoUnits  = NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *components = [gregorian components:dayInfoUnits fromDate:[NSDate date]];
    components.month --;
    
    NSDate * retDate =[gregorian dateFromComponents:components];
    
    return [DateLogic getStringWithDate:retDate];
}


+ (NSString *)getStringWithDate:(NSDate *)date {
    
    NSDateFormatter *formatter        = [[NSDateFormatter alloc]init];
    formatter.dateFormat              = @"yyyyMMdd";
    if (date) {
        NSString* dateString = [formatter stringFromDate:date];
        return dateString;
    }
    return @"";
}

+ (NSString *)getStringWithDateLikeYYYYMMddHHmmss:(NSDate *)date {
    
    NSDateFormatter *formatter        = [[NSDateFormatter alloc]init];
    formatter.dateFormat              = @"YYYYMMddHHmmss";
    if (date) {
        NSString* dateString = [formatter stringFromDate:date];
        return dateString;
    }
    return @"";
}

+ (NSDate *)getDateByYYYYMMddHHmmss:(NSString *)yyyyMMddHHmmss {
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSDate* inputDate = [inputFormatter dateFromString:yyyyMMddHHmmss];
    
    return inputDate;
}


+ (NSDate *)getDateByYYYYMMdd:(NSString *)yyyyMMdd {
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc]init];
    [inputFormatter setDateFormat:@"yyyyMMdd"];
    NSDate *inputDate = [inputFormatter dateFromString:yyyyMMdd];
    return inputDate;
}

+ (NSString *)getStringWithDate:(NSDate *)date withFormatter:(NSString *)formatterStr {
    
    NSDateFormatter *formatter        = [[NSDateFormatter alloc]init];
    formatter.dateFormat              = formatterStr;
    if (date) {
        NSString* dateString = [formatter stringFromDate:date];
        return dateString;
    }
    return @"";
}

+ (NSDateComponents *)getComponentFromeDate:(NSDate *)date {
    
    if (date == nil) {
        return nil;
    }
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:date];

    return components;
}

+ (NSDateComponents *)getComponentFromeTwoDate :(NSDate *)fromDate toDate:(NSDate *)toDate {
    
    if (!fromDate || !toDate) {
        return nil;
    }
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setFirstWeekday:2];
    [gregorian rangeOfUnit:NSDayCalendarUnit startDate:&fromDate interval:nil forDate:fromDate];
    [gregorian rangeOfUnit:NSDayCalendarUnit startDate:&toDate interval:nil forDate:toDate];
    if (fromDate == nil || toDate == nil ) {
        return nil;
    }
    NSDateComponents *dayComponents = [gregorian components:NSDayCalendarUnit fromDate:fromDate toDate:toDate options:0];
    
    return dayComponents;
}

+ (NSDate *)getDateWithYearTimeIntervalSinceNow:(NSInteger)interval {
    NSDate *date = nil;
    if (!interval) {
        return nil;
    } else {
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat       = @"yyyy";
        NSInteger dateInteger = [formatter stringFromDate:[NSDate date]].integerValue;
        NSString *dateYear = [NSString stringWithFormat:@"%ld",(long)dateInteger + interval];
        NSString *dateStr = [dateYear stringByAppendingString:@"0101"];
        formatter.dateFormat = @"yyyyMMdd";
        date = [formatter dateFromString:dateStr];
        return date;
    }
}

+(NSDate *)getDateWithDateStr:(NSString *)dateStr withFormatter:(NSString *)formatterStr{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:formatterStr];
    NSDate* inputDate = [inputFormatter dateFromString:dateStr];
    
    return inputDate;
}

//把服务器传回的日期格式转化为要显示的样式显示
+ (NSString *)getStringWithFormatter:(NSString *)formatterStr withServDateStr:(NSString *)servDateStr
                 andServFormatterStr:(NSString *)servFormatterStr{
    NSDate *msgdate = [DateLogic getDateWithDateStr:servDateStr withFormatter:servFormatterStr];
    NSString *dateStr = [DateLogic getStringWithDate:msgdate withFormatter:formatterStr];
    
    return dateStr;
}

/**消息页 获得格式化的本地接收到的推送时间*/
+ (NSString *)getNoticeFormatMsgDateString:(NSString *)msgDateString {
    
    NSInteger eight = 8;
    NSString *msgDateStr;
    NSDate *msgdate = [DateLogic getDateByYYYYMMddHHmmss:msgDateString];
//    NSLog(@"推送时间:%@",msgDateString);
    if (msgDateString.length > eight) {
        
        NSString *yyyyMMddDateStr = [msgDateString substringToIndex:eight];
        
//        NSLog(@"推送时间前8位:%@",yyyyMMddDateStr);
        if ([yyyyMMddDateStr isEqualToString:[DateLogic getStringWithDate:[NSDate date]]]) {
            
            msgDateStr = [DateLogic getStringWithDate:msgdate withFormatter:@"HH:mm"];
        } else {
            msgDateStr = [DateLogic getStringWithDate:msgdate withFormatter:@"yyyy-MM-dd"];
        }
    } else {
//        msgDateStr = [DateLogic getStringWithDate:msgdate withFormatter:@"yyyy-MM-dd"];
        msgDateStr = msgDateString;
    }
    return msgDateStr;
}

// 获取yy-MM-dd 格式时间字符串
+ (NSString *)getyyMMddFromyyyyMMddHHmmss:(NSString *)dateString {
    NSInteger eight = 8;
    NSString *timeStr = nil;
    NSDate *date = [DateLogic getDateByYYYYMMddHHmmss:dateString];
    if (dateString.length > eight) {
        timeStr = [DateLogic getStringWithDate:date withFormatter:@"yy-MM-dd"];
    } else {
        timeStr = dateString;
    }
    return timeStr;
}

//获取当前时间是否在设定的开始时间，结束时间段里
+ (BOOL)currentDateIsInDateSinceDate:(NSString *)fromDateStr toDate:(NSString *)toDateStr{
    BOOL isInDate = NO;
    if (!fromDateStr || !toDateStr) {
        return isInDate;
    }
    NSDate *nowDate = [NSDate date];
    NSDate *fromDate = [self getDateByYYYYMMddHHmmss:fromDateStr];
    NSDate *endDate = [self getDateByYYYYMMddHHmmss:toDateStr];
    if (([nowDate compare:fromDate] == NSOrderedDescending || [nowDate compare:fromDate] == NSOrderedSame) && ([nowDate compare:endDate] == NSOrderedAscending || [nowDate compare:endDate] == NSOrderedSame)) {
        isInDate = YES;
    }
    
    return isInDate;
}

//获取当前时间是否大于结束时间
+ (BOOL)currentDateGreaterThanEndDate:(NSString *)endDateStr{
    BOOL isGreaterThan = NO;
    if (!endDateStr) {
        return isGreaterThan;
    }
    NSDate *nowDate = [NSDate date];
    NSDate *endDate = [self getDateByYYYYMMddHHmmss:endDateStr];
    if ([nowDate compare:endDate] == NSOrderedDescending) {
        isGreaterThan = YES;
    }
    return isGreaterThan;
}

+ (NSString *)getWeekWithString:(NSString *)dateString{
    NSString *string;
    NSDate *date                      = [self getDateByYYYYMMddHHmmss:dateString];
    NSInteger weekNo = [self getDateComponent:AMMWeekDay date:date];
    switch (weekNo) {
        case 1:
            string = NSLocalizedString(@"Sunday", @"");
            break;
        case 2:
            string = NSLocalizedString(@"Monday", @"");
            break;
        case 3:
            string = NSLocalizedString(@"Tuesday", @"");
            break;
        case 4:
            string = NSLocalizedString(@"Wednesday", @"");
            break;
        case 5:
            string = NSLocalizedString(@"Thursday", @"");
            break;
        case 6:
            string = NSLocalizedString(@"Friday", @"");
            break;
        case 7:
            string = NSLocalizedString(@"Saturday", @"");
            break;
        default:
            break;
    }
    return string;
}

//获取 yyyy-M-d EEEE
+ (NSString *)getWeekDayWith:(NSString *)dateString{
    NSString *string;
    NSDate *date                      = [self getDateByYYYYMMddHHmmss:dateString];
    NSString *weekStr = [self getWeekWithString:dateString];
    string = [NSString stringWithFormat:@"%@ %@",[self getStringWithDate:date withFormatter:@"yyyy-M-d"],weekStr];
    return string;
}
@end
