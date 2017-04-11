//
//  UILogic.m
//  FCUtils
//
//  Created by 宋明月 on 2017/4/10.
//  Copyright © 2017年 宋明月. All rights reserved.
//

#import "UILogic.h"
#import "FCUtils.h"
#import "FCAlertLabel.h"

static UILogic *sharedInstance = nil;
@implementation UILogic


+ (UILogic *)sharedInstance {
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[UILogic alloc] init];
        
    });
    
    return sharedInstance;
}

// 根据字体大小及行间距获取文字所占高度
- (CGFloat)getHeightByText:(NSString *)aString
                     width:(CGFloat)width
                  fontSize:(CGFloat)fontSize
                     space:(CGFloat)space {
    
    NSString *textStr = aString;
    if(!aString) {
        return 0;
    }
    
    // 字体的大小
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    
    // 设置字的间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    if (space > 0) {
        [paragraphStyle setLineSpacing:space];
    }
    
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:textStr
                                                                         attributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle}];
    
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){width, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                               context:nil];
    return ceil(rect.size.height)+1.0;
}

- (CGFloat)getWidthByText:(NSString *)aString
                     font:(UIFont *)font
                   height:(CGFloat)height {
    
    NSString *textStr = aString;
    if(!aString) {
        return 0;
    }
    
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:textStr
                                                                         attributes:@{NSFontAttributeName:font}];
    
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){CGFLOAT_MAX, height}
                                               options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                               context:nil];
    
    return ceil(rect.size.width)+1.0;
}

- (NSAttributedString *)attributedStringWithString:(NSString *)text
                                         textColor:(UIColor *)color
                                          fontSize:(UIFont *)font
                                          rowSpace:(CGFloat)space {
    
    if (text == nil) {
        text = @"";
    }
    
    // 设置字的间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:space];
    
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle, NSForegroundColorAttributeName:color}];
    
    return attributedText;
}

- (UIImage *)headImgByRelationId:(NSString *)relationId gender:(NSString *)gender {
    
    if (relationId == nil || [relationId isEqualToString:@""]) {
        return [UIImage imageNamed:@"family-midAge-Man"];
    }
    
    // 根据性别不同返回不同的自已图片
    if ([relationId isEqualToString:@"1"] || [relationId isEqualToString:@"8"] || [relationId isEqualToString:@"9"] || [relationId isEqualToString:@"10"]) {
        if (gender && ![gender isEqualToString:@""]) {
            if ([gender isEqualToString:@"1"]) {
                return [UIImage imageNamed:@"family-midAge-Man"];
            } else {
                return [UIImage imageNamed:@"family-midAge-Woman"];
            }
        } else {
            return [UIImage imageNamed:@"family-midAge-Man"];
        }
    }
    
    if ([relationId isEqualToString:@"4"]
        || [relationId isEqualToString:@"8"]
        || [relationId isEqualToString:@"9"]
        || [relationId isEqualToString:@"10"]) {
        
        return [UIImage imageNamed:@"family-midAge-Man"];
    } else if ([relationId isEqualToString:@"3"]) {
        
        return [UIImage imageNamed:@"family-oldMan"];
    } else if ([relationId isEqualToString:@"2"]) {
        
        return [UIImage imageNamed:@"family-oldWoman"];
    } else if ([relationId isEqualToString:@"11"]) {
        if (gender) {
            if ([gender isEqualToString:@"1"]) {
                return [UIImage imageNamed:@"family-midAge-Man"];
            } else {
                return [UIImage imageNamed:@"family-midAge-Woman"];
            }
        }
        return [UIImage imageNamed:@"family-midAge-Woman"];
    } else if ([relationId isEqualToString:@"6"]) {
        
        return [UIImage imageNamed:@"family-boy"];
    } else if ([relationId isEqualToString:@"7"]) {
        
        return [UIImage imageNamed:@"family-girl"];
    }  else if ([relationId isEqualToString:@"5"]) {
        
        return [UIImage imageNamed:@"family-midAge-Woman"];
    }
    
    return [UIImage imageNamed:@"family-midAge-Man"];
}

- (NSString *)getRelationShip:(NSString *)relationId  {
    if (relationId == nil || [relationId isEqualToString: @""]) {
        return NSLocalizedString(@"UnSelected", @"");
    }
    static NSString *relationShip = nil;
    if ([relationId isEqualToString:@"1"]) {
        relationShip = @"我";
    } else if ([relationId isEqualToString:@"2"]) {
        relationShip = NSLocalizedString(@"Mother", @"");
    } else if  ([relationId isEqualToString:@"3"]) {
        relationShip = NSLocalizedString(@"Father", @"");
    } else if  ([relationId isEqualToString:@"4"]) {
        relationShip = NSLocalizedString(@"Brothers", @"");
    } else if  ([relationId isEqualToString:@"5"]) {
        relationShip = NSLocalizedString(@"Sister", @"");
    } else if  ([relationId isEqualToString:@"6"]) {
        relationShip = NSLocalizedString(@"Son", @"");
    } else if  ([relationId isEqualToString:@"7"]) {
        relationShip = NSLocalizedString(@"Daughter", @"");
    } else if  ([relationId isEqualToString:@"8"]) {
        relationShip = NSLocalizedString(@"Relatives", @"");
    } else if  ([relationId isEqualToString:@"9"]) {
        relationShip = NSLocalizedString(@"Friend", @"");
    } else if  ([relationId isEqualToString:@"10"]) {
        relationShip = NSLocalizedString(@"Other", @"");
    } else if  ([relationId isEqualToString:@"11"]) {
        relationShip = NSLocalizedString(@"Spouse", @"");
    }
    return relationShip;
}

- (NSString *)stringByStringArray:(NSArray *)array {
    
    NSString *returnValue = @"";
    
    for (int i = 0; i < array.count; i ++) {
        
        NSString *temp = [array objectAtIndex:i];
        if (i == 0) {
            returnValue = [returnValue stringByAppendingFormat:@"%@",temp];
        } else {
            returnValue = [returnValue stringByAppendingFormat:@"、%@",temp];
        }
    }
    
    return returnValue;
}

// 获取血型 ID
- (NSString *)getBloodTypeID:(NSString *)bloodTypeStr {
    if ([bloodTypeStr isEqualToString:NSLocalizedString(@"UnKnownBloodType", @"")]) {
        
        return @"0";
        
    } else if ([bloodTypeStr isEqualToString:NSLocalizedString(@"ABloodType", @"")]) {
        
        return @"1";
        
    } else if ([bloodTypeStr isEqualToString:NSLocalizedString(@"BBloodType", @"")]) {
        
        return @"2";
        
    } else if ([bloodTypeStr isEqualToString:NSLocalizedString(@"OBloodType", @"")]) {
        
        return @"3";
        
    } else if ([bloodTypeStr isEqualToString:NSLocalizedString(@"ABBloodType", @"")]) {
        
        return @"4";
        
    } else if ([bloodTypeStr isEqualToString:NSLocalizedString(@"OtherBloodType", @"")])
    {
        return @"5";
    } else {
        return nil;
    }
}

// 获取血型
- (NSString *)getBloodTypeString:(NSString *)bloodTypeID {
    if ([bloodTypeID isEqualToString:@"0"]) {
        
        return NSLocalizedString(@"UnKnownBloodType", @"");
        
    } else if ([bloodTypeID isEqualToString:@"1"]) {
        
        return NSLocalizedString(@"ABloodType", @"");
        
    } else if ([bloodTypeID isEqualToString:@"2"]) {
        
        return NSLocalizedString(@"BBloodType", @"");
        
    } else if ([bloodTypeID isEqualToString:@"3"]) {
        
        return NSLocalizedString(@"OBloodType", @"");
        
    } else if ([bloodTypeID isEqualToString:@"4"]) {
        
        return NSLocalizedString(@"ABBloodType", @"");
        
    } else if ([bloodTypeID isEqualToString:@"5"])
    {
        return NSLocalizedString(@"OtherBloodType", @"");
        
    } else {
        return nil;
    }
}

// 数字大于万的表示为x.x万
- (NSString *)transNumToTenThousandsUnit:(NSString *)orginalNum {
    
    NSString *value = orginalNum;
    
    if (orginalNum == nil || [orginalNum isEqualToString:@""]) {
        return @"";
    }
    
    long long num = 0;
    if (orginalNum.length > 0) {
        num = orginalNum.longLongValue;
        // 超过100万再显示万
        if (num > 1000000) {
            CGFloat floatNum = num / 10000.0f;
            value = [NSString stringWithFormat:@"%.2f%@",floatNum,NSLocalizedString(@"TenThousands", @"")];
        }
    }
    
    return value;
}

- (void)customBackBarButtonItem:(UIViewController *)viewController title:(NSString *)title {
    NSString *text = (title.length > 0) ? title : NSLocalizedString(@"back", @"");
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backBtn setTitle:text forState:UIControlStateNormal];
    [backBtn setTitleColor:DEFAULT_BLUE_COLOR forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"doctor_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -13, 0, 20);
    backBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    if ([UIDevice currentDevice].systemVersion.floatValue > 9.9) {
        backBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    }
    viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}

- (void)backAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(backBarButtonItemAction)]) {
        [self.delegate backBarButtonItemAction];
    }
}

// titleView
- (UIView *)searchTitleView {
    CGFloat titleHeight = 30;
    CGRect titleRect = CGRectMake(0, 0, ScreenWidth-50, titleHeight);
    UIView *titleView = [[UIView alloc] initWithFrame:titleRect];
    titleView.backgroundColor = [UIColor whiteColor];
    titleView.layer.cornerRadius = 5;
    titleView.layer.borderWidth = 0.5;
    titleView.layer.borderColor = LIGHT_GRAY_TEXT_COLOR.CGColor;
    UIFont *textFont = [UIFont systemFontOfSize:14];
    NSString *searchText = NSLocalizedString(@"Hospital、Department、Doctor、Disease", @"");
    CGFloat titleWidth = [[UILogic sharedInstance] getWidthByText:searchText font:textFont height:titleHeight];
    
    UILabel *searchTextLabel = [[UILabel alloc] initWithFrame:CGRectMake((titleView.frame.size.width-titleWidth)/2, 0, titleWidth, titleHeight)];
    searchTextLabel.text = searchText;
    searchTextLabel.font = textFont;
    searchTextLabel.textColor = LIGHT_GRAY_TEXT_COLOR;
    [titleView addSubview:searchTextLabel];
    
    UIImage *image = [UIImage imageNamed:@"searchMagnifier"];
    UIImageView *searchImageView = [[UIImageView alloc] initWithImage:image];
    searchImageView.frame = CGRectMake(searchTextLabel.frame.origin.x - image.size.width - 10, (titleHeight - image.size.height)/2, image.size.width, image.size.height);
    [titleView addSubview:searchImageView];
    UIButton *searchButton = [[UIButton alloc] initWithFrame:titleRect];
    searchButton.backgroundColor = [UIColor clearColor];
    [searchButton addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:searchButton];
    return titleView;
}

- (void)searchAction {
    if ([self.delegate respondsToSelector:@selector(goSearchAction)]) {
        [self.delegate goSearchAction];
    }
}

- (UIWindow *)getNormalWindow {
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        if (window.tag == kAlertLabelTag) {
            window.hidden = YES;
        }
    }
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWindow in windows)
        {
            if (tmpWindow.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWindow;
                break;
            }
        }
    }
    return window;
}

- (NSString *)formatImageUrl:(NSString *)url {
    NSString *urlStr = url;
    if (url.length < 4) {
        return urlStr;
    }
    NSString *lastFourStr = [urlStr substringWithRange:NSMakeRange(url.length-4,4)];
    if (![lastFourStr isEqualToString:@".png"]) {
        urlStr = [NSString stringWithFormat:@"%@.png",urlStr];
    }
    return urlStr;
}

@end
