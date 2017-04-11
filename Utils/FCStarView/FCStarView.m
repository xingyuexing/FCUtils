//
//  FCStarView.m
//  FCUtils
//
//  Created by 宋明月 on 2017/4/10.
//  Copyright © 2017年 宋明月. All rights reserved.
//


#import "FCStarView.h"
#define DEFALUT_STAR_NUMBER 5
#define ANIMATION_TIME_INTERVAL 0.2
#define FOREGROUND_STAR_IMAGE_NAME @"star"
#define BACKGROUND_STAR_IMAGE_NAME @"star_Select"//@"star-no"
#define FOREGROUND_DIAMONDS_IMAGE_NAME @"doctor_Diamonds_1"
#define BACKGROUND_DIAMONDS_IMAGE_NAME @"doctor_Diamonds"
@interface FCStarView ()

@property (nonatomic, strong) UIView *foregroundStarView;
@property (nonatomic, strong) UIView *backgroundStarView;
@property (nonatomic, assign) NSInteger numberOfStars;
@property (nonatomic, assign) ShowStarType showStarType;

@end
@implementation FCStarView
@synthesize scorePercent = scorePercent;
#pragma mark - Init Methods
- (instancetype)init
{
    NSAssert(NO, @"You should never call this method in this class. Use initWithFrame: instead!");
    return nil;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame
             withNumberOfStars:DEFALUT_STAR_NUMBER
                   withPercent:1.f
   withUserInteractionEnabled :NO];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        _numberOfStars = DEFALUT_STAR_NUMBER;
        [self buildUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
            withNumberOfStars:(NSInteger)numberOfStars
                  withPercent:(CGFloat)percent
   withUserInteractionEnabled:(BOOL)interactionEnabled
{
    return [self initWithFrame:frame withNumberOfStars:numberOfStars withPercent:percent withUserInteractionEnabled:interactionEnabled withShowStarType:SHOW_STAR];
}

- (instancetype)initWithFrame:(CGRect)frame
            withNumberOfStars:(NSInteger)numberOfStars
                  withPercent:(CGFloat)percent
   withUserInteractionEnabled:(BOOL)interactionEnabled
             withShowStarType:(ShowStarType)showStarType
{
    if (self = [super initWithFrame:frame])
    {
        //初始化
        _numberOfStars = numberOfStars;
        scorePercent = percent;
        self.userInteractionEnabled = interactionEnabled;
        
        //默认值
        _maxValue = 5.0;
        _accuracy = 1.0;
        _hasAnimation = YES;//默认为YES
        _allowIncompleteStar = YES;//默认为YES
        self.currentValue = self.scorePercent * self.maxValue;
        _showStarType = showStarType;
        [self buildUI];
    }
    return self;
}

- (void)refrushStarViewEnabled:(BOOL)interactionEnabled
{
    self.userInteractionEnabled = interactionEnabled;
}


#pragma mark - Private Methods

- (void)buildUI
{
    NSString *foregroundImageName;
    NSString *backgroundImageName;
    if (_showStarType == SHOW_STAR) {
        foregroundImageName = FOREGROUND_STAR_IMAGE_NAME;
        backgroundImageName = BACKGROUND_STAR_IMAGE_NAME;
    }
    else{
        foregroundImageName = FOREGROUND_DIAMONDS_IMAGE_NAME;
        backgroundImageName = BACKGROUND_DIAMONDS_IMAGE_NAME;
    }
    self.foregroundStarView = [self createStarViewWithImage:foregroundImageName];
    self.backgroundStarView = [self createStarViewWithImage:backgroundImageName];
    self.foregroundStarView.frame = CGRectMake(0, 0, 0, self.bounds.size.height);
    
    [self addSubview:self.backgroundStarView];
    [self addSubview:self.foregroundStarView];
    
    //单击手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTapRateView:)];
    tapGesture.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tapGesture];
    
    
}

- (void)userTapRateView:(UITapGestureRecognizer *)gesture
{
    CGPoint tapPoint = [gesture locationInView:self];
    
    CGFloat offset = tapPoint.x;
    NSLog(@"offset = %f",offset);
    
    CGFloat realStarScore = offset / (self.bounds.size.width / self.numberOfStars);
    NSLog(@"realStarScore = %f",offset);
    
    CGFloat starScore = self.allowIncompleteStar ? realStarScore : ceilf(realStarScore);
    NSLog(@"starScore = %f",starScore);
    
    self.scorePercent = starScore / self.numberOfStars;
    NSLog(@"scorePercent = %f",self.scorePercent);
}

- (UIView *)createStarViewWithImage:(NSString *)imageName
{
    UIView *view = [[UIView alloc] initWithFrame:self.bounds];
    view.clipsToBounds = YES;
    view.backgroundColor = [UIColor clearColor];
    for (NSInteger i = 0; i < self.numberOfStars; i ++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.frame = CGRectMake(i * self.bounds.size.width / (self.numberOfStars), 5, self.bounds.size.width / self.numberOfStars, self.bounds.size.height-10);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:imageView];
    }
    return view;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    __weak FCStarView *weakSelf = self;
    CGFloat animationTimeInterval = self.hasAnimation ? ANIMATION_TIME_INTERVAL : 0;
    [UIView animateWithDuration:animationTimeInterval animations:^{
        weakSelf.foregroundStarView.frame = CGRectMake(0, 0, weakSelf.bounds.size.width * weakSelf.scorePercent, weakSelf.bounds.size.height);
    }];
}

#pragma mark - Get and Set Methods

- (void)setScorePercent:(CGFloat)scroePercent
{
    if (scorePercent == scroePercent)
    {
        return;
    }
    if (scroePercent < 0)
    {
        scorePercent = 0;
    } else if (scroePercent > 1)
    {
        scorePercent = 1;
    } else
    {
        scorePercent = scroePercent;
    }
    
    if ([self.delegate respondsToSelector:@selector(starRateView:scroePercentDidChange:)])
    {
        [self.delegate starRateView:self scroePercentDidChange:scroePercent];
    }
    
    self.currentValue = scorePercent * self.maxValue;
    
    [self setNeedsLayout];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesBegan");
    UITouch *beganTouch = [touches anyObject];
    CGPoint tapPoint = [beganTouch locationInView:self];
    
    CGFloat offset = tapPoint.x;
    NSLog(@"offset = %f",offset);
    
    CGFloat realStarScore = offset / (self.bounds.size.width / self.numberOfStars);
    NSLog(@"realStarScore = %f",realStarScore);
    
    CGFloat starScore = self.allowIncompleteStar ? realStarScore : ceilf(realStarScore);
    NSLog(@"starScore = %f",starScore);
    
    CGFloat formatScore = (float)(((int)(realStarScore/_accuracy)) * _accuracy) + _accuracy;
    NSLog(@"formatScore = %f",formatScore);
    
    CGFloat percentage = formatScore / self.numberOfStars;
    NSLog(@"scorePercent = %f",percentage);
    
    self.scorePercent = percentage;
    self.currentValue = self.scorePercent * self.maxValue;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesMoved");
    
    UITouch *beganTouch = [touches anyObject];
    
    CGPoint tapPoint = [beganTouch locationInView:self];
    
    CGFloat offset = tapPoint.x;
    //FDLogDebug(@"offset = %f",offset);
    
    CGFloat realStarScore = offset / (self.bounds.size.width / self.numberOfStars);
    //FDLogDebug(@"realStarScore = %f",realStarScore);
    
    //    CGFloat starScore = self.allowIncompleteStar ? realStarScore : ceilf(realStarScore);
    //FDLogDebug(@"starScore = %f",starScore);
    
    self.scorePercent = realStarScore / self.numberOfStars;
    self.currentValue = self.scorePercent * self.maxValue;
    //FDLogDebug(@"scorePercent = %f",self.scorePercent);
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesEnded");
    
    UITouch *beganTouch = [touches anyObject];
    CGPoint tapPoint = [beganTouch locationInView:self];
    
    CGFloat offset = tapPoint.x;
    NSLog(@"offset = %f",offset);
    
    CGFloat realStarScore = offset / (self.bounds.size.width / self.numberOfStars);
    NSLog(@"realStarScore = %f",realStarScore);
    
    CGFloat starScore = self.allowIncompleteStar ? realStarScore : ceilf(realStarScore);
    NSLog(@"starScore = %f",starScore);
    
    CGFloat formatScore = (float)(((int)(realStarScore/_accuracy)) * _accuracy) + _accuracy;
    NSLog(@"formatScore = %f",formatScore);
    
    CGFloat percentage = formatScore / self.numberOfStars;
    NSLog(@"scorePercent = %f",percentage);
    
    self.scorePercent = percentage;
    self.currentValue = self.scorePercent * self.maxValue;
    
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesCancelled");
    
    UITouch *beganTouch = [touches anyObject];
    CGPoint tapPoint = [beganTouch locationInView:self];
    
    CGFloat offset = tapPoint.x;
    NSLog(@"offset = %f",offset);
    
    CGFloat realStarScore = offset / (self.bounds.size.width / self.numberOfStars);
    NSLog(@"realStarScore = %f",realStarScore);
    
    CGFloat starScore = self.allowIncompleteStar ? realStarScore : ceilf(realStarScore);
    NSLog(@"starScore = %f",starScore);
    
    CGFloat formatScore = (float)(((int)(realStarScore/_accuracy)) * _accuracy) + _accuracy;
    NSLog(@"formatScore = %f",formatScore);
    
    CGFloat percentage = formatScore / self.numberOfStars;
    NSLog(@"scorePercent = %f",percentage);
    
    self.scorePercent = percentage;
    self.currentValue = self.scorePercent * self.maxValue;
}

@end

