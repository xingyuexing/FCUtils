//
//  FCAlertLabel.m
//  FCUtils
//
//  Created by 宋明月 on 2017/4/10.
//  Copyright © 2017年 宋明月. All rights reserved.
//

#import "FCAlertLabel.h"
#import "FCUtils.h"

#define FCAlertLabelFont        15.0
#define FCAlertLabelWidthSpace  40.0
#define FCAlertLabelHeightSpace 20.0
#define FCAlertLabelMinShowTime 2.0
#define FCAlertLabelReadSpeed   20.0

@interface FCAlertLabel ()

@property (strong, nonatomic) UIView  *backView;
@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UIWindow *FCAlertLabelWindow;
@end

@implementation FCAlertLabel

static FCAlertLabel *alertLabel = nil;

+ (instancetype)sharedAlertLabel {
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        alertLabel                                 = [[FCAlertLabel alloc]init];
        
        alertLabel.backView                        = [[UIView alloc]init];
        alertLabel.backView.backgroundColor        = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        alertLabel.backView.layer.cornerRadius     = 5.0;
        alertLabel.backView.clipsToBounds          = YES;
        alertLabel.backView.hidden                 = YES;
        alertLabel.backView.userInteractionEnabled = NO;
        
        alertLabel.label                           = [[UILabel alloc]init];
        alertLabel.label.backgroundColor           = [UIColor clearColor];
        alertLabel.label.textColor                 = [UIColor whiteColor];
        alertLabel.label.textAlignment             = NSTextAlignmentCenter;
        alertLabel.label.font                      = [UIFont systemFontOfSize:FCAlertLabelFont];
        alertLabel.label.numberOfLines             = 0;
        alertLabel.label.lineBreakMode             = NSLineBreakByCharWrapping;
        alertLabel.label.userInteractionEnabled    = NO;
        
        [alertLabel.backView addSubview:alertLabel.label];
        
        if (alertLabel.FCAlertLabelWindow == nil) {
            alertLabel.FCAlertLabelWindow = [[UIWindow alloc] init];
            alertLabel.FCAlertLabelWindow.tag = kAlertLabelTag;
            alertLabel.FCAlertLabelWindow.backgroundColor = [UIColor clearColor];
            alertLabel.FCAlertLabelWindow.windowLevel = UIWindowLevelNormal;
            alertLabel.FCAlertLabelWindow.hidden = NO;
            alertLabel.FCAlertLabelWindow.alpha = 1.0;
            alertLabel.FCAlertLabelWindow.bounds = CGRectMake(0, (ScreenHeight-FCAlertLabelHeightSpace)/2, ScreenWidth, FCAlertLabelHeightSpace);
            alertLabel.FCAlertLabelWindow.center = [UIApplication sharedApplication].keyWindow.center;
            alertLabel.FCAlertLabelWindow.userInteractionEnabled = YES;
            [alertLabel.FCAlertLabelWindow makeKeyAndVisible];
            [alertLabel.FCAlertLabelWindow addSubview:alertLabel.backView];
        }
        
    });
    
    return alertLabel;
}

- (void)showAlertLabelWithAlertString:(NSString *)alertString {
    
    if (alertString.length < 1) {
        return;
    }
    
    NSTimeInterval showTime = alertString.length/FCAlertLabelReadSpeed;
    if (showTime < FCAlertLabelMinShowTime) {
        showTime = FCAlertLabelMinShowTime;
    }
    
    _label.text         = alertString;
    CGRect aStringRect  = [self getStringWidthWithString:alertString font:[UIFont systemFontOfSize:FCAlertLabelFont]];
    
    _backView.hidden    = NO;
    _backView.frame    = CGRectMake(0, 0, aStringRect.size.width + FCAlertLabelWidthSpace, aStringRect.size.height + FCAlertLabelHeightSpace);
    
    alertLabel.FCAlertLabelWindow.hidden = NO;
    alertLabel.FCAlertLabelWindow.bounds = _backView.bounds;
    _backView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    
    _label.frame = CGRectMake(FCAlertLabelWidthSpace/2, FCAlertLabelHeightSpace/2, _backView.bounds.size.width - FCAlertLabelWidthSpace, _backView.bounds.size.height - FCAlertLabelHeightSpace);
    
    
    [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:10 initialSpringVelocity:15 options:UIViewAnimationOptionCurveLinear animations:^{
        
        _backView.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
        
        [FCAlertLabel cancelPreviousPerformRequestsWithTarget:self];
        [self performSelector:@selector(alertLabelHidden) withObject:nil afterDelay:showTime];
    }];
}

- (void)hideAlertLabeImmediatelyIfShowing {
    
    alertLabel.FCAlertLabelWindow.hidden = YES;
}

- (void)alertLabelHidden {
    
    alertLabel.FCAlertLabelWindow.hidden = YES;
    [UIView animateWithDuration:0.1 animations:^{
        _backView.alpha = 0;
    } completion:^(BOOL finished) {
        
        _backView.hidden = YES;
        _backView.alpha  = 1;
    }];
}

- (CGRect)getStringWidthWithString:(NSString *)aString font:(UIFont *)aFont {
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:aFont forKey:NSFontAttributeName];
    
    CGSize stringSize  = CGSizeMake(ScreenWidth - (FCAlertLabelWidthSpace*2) , MAXFLOAT);
    
    CGRect aStringRect = [aString boundingRectWithSize:stringSize
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:attributes
                                               context:nil];
    
    return aStringRect;
}

@end
