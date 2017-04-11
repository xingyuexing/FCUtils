//
//  FCCalender.m
//  FCUtils
//
//  Created by 宋明月 on 2017/4/10.
//  Copyright © 2017年 宋明月. All rights reserved.
//  日历控件

#import "FCCalender.h"
#import "FCUtils.h"

#define ButtonNormalTitleColor [UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0f]
#define ButtonSelectTitleColor [UIColor colorWithRed:51/255.0f green:142/255.0f blue:213/255.0 alpha:1.0f]
#define ButtonCannotSelectTitleColor [UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0f]

@interface FCCalender ()<UIScrollViewDelegate>

{
    NSArray *weekStrArr;
    NSArray *definiteArr;
    NSArray *customWeeksArr;
    BOOL     isDefault;
    UIImageView *selectImageView;
    
    UIButton *selectButton;
}

@property (nonatomic ,strong) NSCalendar *calender;

@property (nonatomic ,strong) UIScrollView *dayScrollView;

@property (nonatomic ,strong) UILabel       *monthLabel;//月份显示
@property (nonatomic ,strong) UIImageView   *leftArrowImageView;
@property (nonatomic ,strong) UIImageView   *rightArrowImageView;



@end

@implementation FCCalender

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        
        
    }
    return self;
    
}

- (instancetype)initWithFrame:(CGRect)frame dataArr:(NSArray *)dataArr
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        weekStrArr = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
        if (dataArr == nil ||dataArr.count == 0) {
            isDefault = YES;
            definiteArr = [self getDateArr];
        }else{
            definiteArr = dataArr;
        }
        CGFloat scrollViewWidth = ScreenWidth-30;
        NSInteger page;
        if (definiteArr.count%7 == 0) {
            page = definiteArr.count/7;
        }else{
            page = definiteArr.count/7+1;
        }
        self.calender = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
        
        [self initWeekLabel];
        if (isDefault) {
            NSArray *weekTitleArr = [self sortWithWeek:[NSDate date]];
            for (int i = 0; i < 7; i ++) {
                if (i < weekTitleArr.count) {
                    ((UILabel *)[self viewWithTag:1000+i]).text = [weekTitleArr objectAtIndex:i];
                }
            }
        }else{
            NSMutableArray *customWeekArr = [[NSMutableArray alloc]initWithCapacity:0];
            CGFloat customCount = 0;
            for (int i = 0; i < ceilf(definiteArr.count/7.f); i ++) {
                NSMutableArray *singleWeekArr = [[NSMutableArray alloc]initWithCapacity:0];
                for (int j = 0; j < 7; j ++) {
                    if (i*7+j >= definiteArr.count) {
                        break;
                    }
                    [singleWeekArr addObject:[self getweekWith:[definiteArr objectAtIndex:i*7+j]]];
                    customCount = customCount +1;
                    if (customWeekArr.count == definiteArr.count) {
                        break;
                    }
                }
                [customWeekArr addObject:singleWeekArr];
            }
            customWeeksArr = customWeekArr;
            [self refreshWith:0];
        }
        
        self.monthLabel = [[UILabel alloc]init];
        self.monthLabel.frame = CGRectMake(15, 0, 80, 20);
        self.monthLabel.textAlignment = NSTextAlignmentLeft;
        self.monthLabel.textColor = ButtonSelectTitleColor;
        self.monthLabel.font = [UIFont systemFontOfSize:13.0f];
        [self addSubview:self.monthLabel];
        
        self.leftArrowImageView = [[UIImageView alloc]init];
        self.leftArrowImageView.frame = CGRectMake(7, 43, 8, 14);
        self.leftArrowImageView.image = [UIImage imageNamed:@"beforeDay"];
        self.leftArrowImageView.hidden = YES;
        self.leftArrowImageView.userInteractionEnabled = YES;
        [self addSubview:self.leftArrowImageView];
        UITapGestureRecognizer *leftTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(leftTap)];
        [self.leftArrowImageView addGestureRecognizer:leftTap];
        
        self.rightArrowImageView = [[UIImageView alloc]init];
        self.rightArrowImageView.frame = CGRectMake(ScreenWidth-15, 43, 8, 14);
        self.rightArrowImageView.image = [UIImage imageNamed:@"RightArrow"];
        self.rightArrowImageView.hidden = YES;
        self.rightArrowImageView.userInteractionEnabled = YES;
        [self addSubview:self.rightArrowImageView];
        UITapGestureRecognizer *rightTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rightTap)];
        [self.rightArrowImageView addGestureRecognizer:rightTap];
        
        CGRect scrollViewFrame = CGRectMake(15, 35, scrollViewWidth, 30);
        self.dayScrollView = [[UIScrollView alloc]initWithFrame:scrollViewFrame];
        self.dayScrollView.showsHorizontalScrollIndicator = NO;
        self.dayScrollView.userInteractionEnabled = YES;
        self.dayScrollView.pagingEnabled = YES;
        self.dayScrollView.contentSize = CGSizeMake(scrollViewWidth *page, 30);
        self.dayScrollView.delegate = self;
        self.dayScrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.dayScrollView];
        
        NSInteger dateCount = 0;
        for (int i = 0; i < page; i ++) {
            UIView *baseView = [[UIView alloc]init];
            CGRect baseViewFrame = CGRectMake(scrollViewWidth*i, 0, scrollViewWidth, 30);
            baseView.frame = baseViewFrame;
            baseView.backgroundColor = [UIColor whiteColor];
            [self.dayScrollView addSubview:baseView];
            
            for (int j = 0; j < 7; j ++) {
                if (j == definiteArr.count%7&&definiteArr.count == dateCount&&!isDefault) {
                    break;
                }
                UIButton *button = [[UIButton alloc]init];
                CGFloat buttonX = (scrollViewWidth-210)/14 + scrollViewWidth/7*j;
                button.frame = CGRectMake(buttonX, 0, 30, 30);
                button.clipsToBounds = YES;
                button.tag = 100+dateCount;
                button.titleLabel.textAlignment = NSTextAlignmentCenter;
                [button setBackgroundImage:[UIImage imageNamed:@"calender-Selected"] forState:UIControlStateSelected];
                [button setBackgroundImage:nil forState:UIControlStateNormal];
                //                NSString *buttonTitle = [self getdayWith:[definiteArr objectAtIndex:dateCount]];
                NSDate *temDate = nil;
                if (definiteArr.count > dateCount) {
                    temDate = [definiteArr objectAtIndex:dateCount];
                }
                NSString *buttonTitle = [self getdayWith:temDate];
                [button setTitle:buttonTitle forState:UIControlStateNormal];
                button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
                [button setTitleColor:ButtonNormalTitleColor forState:UIControlStateNormal];
                [button setTitleColor:ButtonSelectTitleColor forState:UIControlStateSelected];
                if (dataArr == nil && dateCount >= 30) {
                    button.userInteractionEnabled = NO;
                    [button setTitleColor:ButtonCannotSelectTitleColor forState:UIControlStateNormal];
                }
                [button addTarget:self action:@selector(clickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                [button.layer setCornerRadius:15.0f];
                [baseView addSubview:button];
                if (j<6 && i*7+j+1 != definiteArr.count) {
                    UIView *lineView = [[UIView alloc]init];
                    lineView.frame = CGRectMake(scrollViewWidth/7*(j+1), 8, 1, 14);
                    lineView.backgroundColor = [UIColor colorWithRed:229/255.0f green:229/255.0f blue:229/255.0f alpha:1.0f];
                    [baseView addSubview:lineView];
                }
                
                dateCount = dateCount + 1;
            }
            //            self.monthLabel.text = [self getMonth:[definiteArr objectAtIndex:0]];
            self.monthLabel.text = [self getMonth:definiteArr.firstObject];
        }
        if (definiteArr.count < 7) {
            self.leftArrowImageView.hidden = YES;
            self.rightArrowImageView.hidden = YES;
        }else{
            if (definiteArr.count == 7) {
                self.leftArrowImageView.hidden = YES;
                self.rightArrowImageView.hidden = YES;
            }else{
                self.leftArrowImageView.hidden = YES;
                self.rightArrowImageView.hidden = NO;
            }
            
        }
    }
    return self;
}

- (void)leftTap
{
    selectImageView = self.leftArrowImageView;
    self.leftArrowImageView.userInteractionEnabled = NO;
    CGFloat pageWidth = ScreenWidth-30;
    CGFloat scrollviewOffX = self.dayScrollView.contentOffset.x;
    scrollviewOffX = scrollviewOffX-pageWidth;
    CGPoint scrollViewPiont = CGPointMake(scrollviewOffX, 0);
    [self refresh:scrollViewPiont];
    [self.dayScrollView setContentOffset:scrollViewPiont animated:YES];
}
- (void)rightTap
{
    selectImageView = self.rightArrowImageView;
    self.rightArrowImageView.userInteractionEnabled = NO;
    
    CGFloat pageWidth = ScreenWidth-30;
    CGFloat scrollviewOffX = self.dayScrollView.contentOffset.x;
    scrollviewOffX = scrollviewOffX+pageWidth;
    CGPoint scrollViewPiont = CGPointMake(scrollviewOffX, 0);
    [self refresh:scrollViewPiont];
    [self.dayScrollView setContentOffset:scrollViewPiont animated:YES];
}

- (void)setSelectDate:(NSDate *)selectDate
{
    int selectDateNo = 0;
    for (int i = 0; i < definiteArr.count; i ++) {
        NSDate *compareDate = [definiteArr objectAtIndex:i];
        ((UIButton *)[self viewWithTag:100+i]).selected = [self dateCompare:selectDate SecondDate:compareDate];
        if ([self dateCompare:selectDate SecondDate:compareDate]) {
            selectDateNo = i;
        }
    }
    CGFloat currentPage = floorf(selectDateNo/7);
    if (currentPage == 0) {
        if (definiteArr.count < 7) {
            self.leftArrowImageView.hidden = YES;
            self.rightArrowImageView.hidden = YES;
        }else{
            if (definiteArr.count == 7) {
                self.leftArrowImageView.hidden = YES;
                self.rightArrowImageView.hidden = YES;
            }else{
                self.leftArrowImageView.hidden = YES;
                self.rightArrowImageView.hidden = NO;
            }
            
        }
    }else{
        if (isDefault) {
            if (currentPage == 4) {
                self.leftArrowImageView.hidden = NO;
                self.rightArrowImageView.hidden = YES;
            }else{
                self.leftArrowImageView.hidden = NO;
                self.rightArrowImageView.hidden = NO;
            }
        }else{
            NSInteger resultNum = definiteArr.count - (currentPage + 1)*7;
            if (resultNum >= 0&& resultNum<7) {
                self.leftArrowImageView.hidden = NO;
                self.rightArrowImageView.hidden = YES;
            } else {
                if (currentPage == ceilf(definiteArr.count/7)) {
                    self.leftArrowImageView.hidden = NO;
                    self.rightArrowImageView.hidden = YES;
                }else{
                    self.leftArrowImageView.hidden = NO;
                    self.rightArrowImageView.hidden = NO;
                }
            }
        }
    }
    
    
    CGFloat pageWidth = ScreenWidth-30;
    CGFloat scrollviewOffX = ceilf(selectDateNo/7)*pageWidth;
    self.dayScrollView.contentOffset = CGPointMake(scrollviewOffX, 0);
    [self.dayScrollView setContentOffset:CGPointMake(scrollviewOffX, 0) animated:NO];
    [self refreshWith:selectDateNo];
}

/*
 当为自定义日期时刷新星期表头
 */
- (void)refreshWith:(int)selectNo
{
    if (definiteArr.count > 0) {
        int index = floorf(selectNo/7)*7;
        if (index < definiteArr.count) {
            self.monthLabel.text = [self getMonth:[definiteArr objectAtIndex:index]];
        }
        if (!isDefault) {
            NSMutableArray *arr;
            if (floorf(selectNo/7.f) < customWeeksArr.count) {
                arr = [customWeeksArr objectAtIndex:floorf(selectNo/7.f)];
            }
            for (int i = 0; i < arr.count; i ++) {
                ((UILabel *)[self viewWithTag:1000+i]).text = [arr objectAtIndex:i];
                if (arr.count < 7 && i == arr.count-1) {
                    for (int j = 1; j <= 7-arr.count; j ++) {
                        ((UILabel *)[self viewWithTag:1000+i+j]).text = @"";
                    }
                }
            }
        }
    }
}

/*
 时间比较是否相同
 */
- (BOOL)dateCompare:(NSDate *)firstDate SecondDate:(NSDate *)secondDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    if ([[dateFormatter stringFromDate:firstDate] isEqualToString:[dateFormatter stringFromDate:secondDate]]) {
        return YES;
    }
    return NO;
}
/*
 创建星期表头
 */
- (void)initWeekLabel
{
    CGFloat pageWidth = ScreenWidth-30;
    for (int i = 0; i < 7; i ++) {
        UILabel *weekLabel = [[UILabel alloc]init];
        CGRect weekLabelFrame = CGRectMake(15+pageWidth/7*i, 20, pageWidth/7, 12);
        weekLabel.frame = weekLabelFrame;
        weekLabel.textAlignment = NSTextAlignmentCenter;
        weekLabel.tag = 1000+i;
        weekLabel.font = [UIFont systemFontOfSize:12.0];
        weekLabel.textColor = [UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0f];
        [self addSubview:weekLabel];
    }
}

/*
 点击按钮事件
 */
- (void)clickButtonAction:(UIButton *)button
{
    if (button.tag == selectButton.tag) {
        if (button.selected) {
            button.selected = NO;
            selectButton = nil;
            [self.delegate selectWithDate:nil];
        }else{
            button.selected = YES;
            NSDate *selectDate;
            if (button.tag-100 < definiteArr.count) {
                selectDate = [definiteArr objectAtIndex:button.tag-100];
            }
            [self.delegate selectWithDate:selectDate];
            self.selectDate = selectDate;
        }
    }else{
        for (int i = 0; i < definiteArr.count; i ++) {
            if (i == button.tag - 100) {
                ((UIButton *)[self viewWithTag:100+i]).selected = YES;
            }else{
                ((UIButton *)[self viewWithTag:100+i]).selected = NO;
            }
        }
        NSDate *selectDate;
        if (button.tag-100 < definiteArr.count) {
            selectDate = [definiteArr objectAtIndex:button.tag-100];
        }
        
        [self.delegate selectWithDate:selectDate];
        self.selectDate = selectDate;
    }
    
    
    selectButton = button;
}

/*
 根据date计算对应日期
 */

- (NSString *)getdayWith:(NSDate *)date
{
    NSString *dateStr;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd"];
    dateStr = [dateFormatter stringFromDate:date];
    return dateStr;
}

/*
 根据date计算对应月份
 */
- (NSString *)getMonth:(NSDate *)date
{
    NSString *monthStr;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM月"];
    monthStr = [dateFormatter stringFromDate:date];
    return monthStr;
}

/*
 根据date计算对应星期
 */
- (NSString *)getweekWith:(NSDate *)date
{
    NSString *weekStr;
    NSDateComponents *dateComponents = [self.calender components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSWeekOfMonthCalendarUnit | NSWeekOfYearCalendarUnit fromDate:date];
    for (int i = 0; i < 7; i ++) {
        if (i+1 == dateComponents.weekday) {
            if (i < weekStrArr.count) {
                weekStr = [weekStrArr objectAtIndex:i];
            }
            break;
        }
    }
    return weekStr;
}

/*
 生成五个星期
 */
- (NSArray *)getDateArr
{
    NSMutableArray *dateArr = [[NSMutableArray alloc]initWithCapacity:0];
    NSInteger days = 0;
    for (int i = 0; i < 35; i ++) {
        NSDateComponents *weeks = [[NSDateComponents alloc] init];
        weeks.day = days;
        NSDate *endDate = [[NSCalendar currentCalendar] dateByAddingComponents:weeks toDate:[self zeroOfDate] options:0];
        if (endDate != nil) {
            [dateArr addObject:endDate];
        }
        if (days == 35) {
            break;
        }
        days = days + 1;
    }
    return dateArr;
}
/*
 获取当天零点date
 */
- (NSDate *)zeroOfDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSUIntegerMax fromDate:[NSDate date]];
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    
    // components.nanosecond = 0 not available in iOS
    NSTimeInterval ts = (double)(int)[[calendar dateFromComponents:components] timeIntervalSince1970];
    return [NSDate dateWithTimeIntervalSince1970:ts];
}

/*
 根据传入的date所对应的星期作为开头生成星期排序数组
 */

- (NSArray *)sortWithWeek:(NSDate *)date
{
    NSMutableArray *weeksArr = [[NSMutableArray alloc]initWithCapacity:0];
    if (weekStrArr.count > 0) {
        [weeksArr addObjectsFromArray:weekStrArr];
    }
    NSString *weekStr = [self getweekWith:date];
    for (int i = 0;i < 7; i ++) {
        if (i < weekStrArr.count) {
            if ([[weekStrArr objectAtIndex:i]isEqualToString:weekStr]) {
                for (int j = 0; j < 7; j ++) {
                    if (j < i) {
                        //                        [weeksArr replaceObjectAtIndex:j+(7-i) withObject:[weekStrArr objectAtIndex:j]];
                        if (weeksArr.count > j+(7-i)) {
                            [weeksArr replaceObjectAtIndex:j+(7-i) withObject:[weekStrArr objectAtIndex:j]];
                        }
                        
                    }else if (j == i){
                        [weeksArr replaceObjectAtIndex:0 withObject:[weekStrArr objectAtIndex:j]];
                        
                    }else{
                        //                        [weeksArr replaceObjectAtIndex:j-i withObject:[weekStrArr objectAtIndex:j]];
                        if ((j-i) < weeksArr.count && j < weeksArr.count) {
                            [weeksArr replaceObjectAtIndex:j-i withObject:[weekStrArr objectAtIndex:j]];
                        }
                    }
                }
            }
        }
    }
    return weeksArr;
}

- (void)refresh:(CGPoint)targetContentOffset
{
    CGFloat pageWidth = ScreenWidth-30;
    int currentPage = ceil((targetContentOffset.x - pageWidth / 2) / pageWidth);
    if (currentPage == 0) {
        if (definiteArr.count < 7) {
            self.leftArrowImageView.hidden = YES;
            self.rightArrowImageView.hidden = YES;
        }else{
            if (definiteArr.count == 7) {
                self.leftArrowImageView.hidden = YES;
                self.rightArrowImageView.hidden = YES;
            }else{
                self.leftArrowImageView.hidden = YES;
                self.rightArrowImageView.hidden = NO;
            }
            
        }
    }else{
        if (isDefault) {
            if (currentPage == 4) {
                self.leftArrowImageView.hidden = NO;
                self.rightArrowImageView.hidden = YES;
            }else{
                self.leftArrowImageView.hidden = NO;
                self.rightArrowImageView.hidden = NO;
            }
        }else{
            NSInteger resultNum = definiteArr.count - (currentPage + 1)*7;
            if (resultNum >= 0&& resultNum<7) {
                self.leftArrowImageView.hidden = NO;
                self.rightArrowImageView.hidden = YES;
            } else {
                if (currentPage == ceilf(definiteArr.count/7)) {
                    self.leftArrowImageView.hidden = NO;
                    self.rightArrowImageView.hidden = YES;
                }else{
                    self.leftArrowImageView.hidden = NO;
                    self.rightArrowImageView.hidden = NO;
                }
            }
        }
    }
    [self refreshWith:currentPage*7+1];
}

#pragma mark ScrollViewDelegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    [self refresh:*targetContentOffset];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    selectImageView.userInteractionEnabled = YES;
}
@end
