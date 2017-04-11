//
//  FCBottompopView.m
//  FCUtils
//
//  Created by 宋明月 on 2017/4/10.
//  Copyright © 2017年 宋明月. All rights reserved.
//

#import "FCBottompopView.h"

#define W CGRectGetWidth([UIScreen mainScreen].bounds)
#define H CGRectGetHeight([UIScreen mainScreen].bounds)

@interface itemView : UIView

@property (nonatomic) BOOL theDivider;

- (id)initWithFrame:(CGRect)frame theDivider:(BOOL)theDivider;
@end

@implementation itemView

- (id)initWithFrame:(CGRect)frame theDivider:(BOOL)theDivider {
    self = [super initWithFrame:frame];
    if (self) {
        _theDivider = theDivider;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    if (_theDivider) {
        UIBezierPath *b = [UIBezierPath bezierPath];
        [b moveToPoint:CGPointMake(0, CGRectGetHeight(self.frame) - .5)];
        [b addLineToPoint:CGPointMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - .1)];
        [[UIColor blackColor]set];
        self.layer.contentsScale = [UIScreen mainScreen].scale;
        [b setLineWidth:.1];
        [b stroke];
    }
    [super drawRect:rect];
}
@end

@interface FCBottompopView ()

@property (nonatomic, strong) UIView *bigView;
@property (nonatomic) CGFloat count;

@end

@implementation FCBottompopView


- (id)initWithTitleArray:(NSArray *)titleArray {
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
        self.bigView = [[UIView alloc]init];
        
        [self addSubview:_bigView];
        __weak typeof(self) selfBlock = self;
        
        _count = titleArray.count;
        [titleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            itemView *item;
            if (idx == (titleArray.count-1)) {
                item = [[itemView alloc]initWithFrame:CGRectMake(0, idx * 44, W, 44) theDivider:NO];
            }else{
                item = [[itemView alloc]initWithFrame:CGRectMake(0, idx * 44, W, 44) theDivider:YES];
            }
            item.userInteractionEnabled = YES;
            item.tag = 100 + idx;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
            [item addGestureRecognizer:tap];
            item.backgroundColor = [UIColor whiteColor];
            UILabel *titleLabel = [[UILabel alloc]init];
            titleLabel.frame = CGRectMake(15, 0, W/2, 44);
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.text = obj;
            titleLabel.textAlignment = NSTextAlignmentLeft;
            [item addSubview:titleLabel];
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(W-35, 13, 18, 18)];
            imageView.image = [UIImage imageNamed:@"check-blue"];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.hidden = YES;
            imageView.tag = 1000 + idx;
            [item addSubview:imageView];
            
            [selfBlock.bigView addSubview:item];
            
        }];
        
        
        _bigView.frame = CGRectMake(0,H + titleArray.count * 44 + 30, W, titleArray.count * 44);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dissmiss)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)tap:(UITapGestureRecognizer *)tapG {
    UIView *view = (UIView *)tapG.view;
    [self selectIndex:view.tag-100];
    [self.delegate selectIndex:view.tag-100];
    [self dissmiss];
}

- (void)setSelectIndex:(NSInteger)selectIndex
{
    if (index > 0) {
        for (int i = 0; i < _count; i++) {
            if (i == selectIndex) {
                ((UIImageView *)[self viewWithTag:1000+i]).hidden = NO;
            }else{
                ((UIImageView *)[self viewWithTag:1000+i]).hidden = YES;
            }
        }
    }
}

- (void)selectIndex:(NSInteger)index
{
    if (index > 0) {
        for (int i = 0; i < _count; i++) {
            if (i == index) {
                ((UIImageView *)[self viewWithTag:1000+i]).hidden = NO;
            }else{
                ((UIImageView *)[self viewWithTag:1000+i]).hidden = YES;
            }
        }
    }
}

- (void)show {
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    
    [window addSubview:self];
    
    [UIView animateWithDuration:.3 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        _bigView.transform = CGAffineTransformMakeTranslation(0, - 2 * (_count * 44 + 10 + 10) + 10);
    }];
}

- (void)dissmiss {
    [UIView animateWithDuration:.3 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        _bigView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
