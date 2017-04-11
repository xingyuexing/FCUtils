//
//  FCProgressViewController.m
//  FCUtils
//
//  Created by 宋明月 on 2017/4/10.
//  Copyright © 2017年 宋明月. All rights reserved.
//

//
//  FCProgressViewController.m
//  progressView
//
//  Created by sunyw on 4/1/15.
//  Copyright (c) 2015 sunyw. All rights reserved.
//

#import "FCProgressViewController.h"
#import "FCProgressCircleView.h"
#import "FCUtils.h"

static NSMutableArray *retainQueue;
static NSMutableArray *displayQueue;
static NSMutableArray *dismissQueue;

static FCProgressViewController *currentFCPViewController;

@interface FCProgressViewController ()

@property (nonatomic,strong) FCProgressCircleView * FCProgressCircleView;
@property (nonatomic,strong) UIWindow *FCProgressWindow;

@end

@implementation FCProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

+(FCProgressViewController*)progressViewWithBody:(NSString*)bodyText type:(FCProgressViewType)progressType hidesAfter:(float)delay show:(BOOL)show {
    
    FCProgressViewController *FCPViewController = [[FCProgressViewController alloc] init];
    FCPViewController.bodyText          = bodyText;
    FCPViewController.progressType      = progressType;
    FCPViewController.viewHideDelay     = delay;
    FCPViewController.backgroundColor   = [UIColor colorWithWhite:0.9 alpha:0.8];
    [FCPViewController initView];
    
    if(show) {
        [FCPViewController addToDisplayQueue];
    }
    if(delay > 0) {
        FCPViewController.hideTimer = [NSTimer scheduledTimerWithTimeInterval:delay target:FCPViewController selector:@selector(dismissController) userInfo:nil repeats:NO];
    }
    else {
        FCPViewController.hideTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:FCPViewController selector:@selector(dismissController) userInfo:nil repeats:NO];
    }
    
    
    return FCPViewController;
}

+(FCProgressViewController*)progressViewWithBody:(NSString*)bodyText type:(FCProgressViewType)progressType show:(BOOL)show {
    
    FCProgressViewController *FCPViewController = [[FCProgressViewController alloc] init];
    FCPViewController.bodyText          = bodyText;
    FCPViewController.progressType      = progressType;
    FCPViewController.backgroundColor   = [UIColor colorWithWhite:0.9 alpha:0.8];
    [FCPViewController initView];
    
    if(show) {
        [FCPViewController addToDisplayQueue];
    }
    
    return FCPViewController;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(continueAnimating) name: APPDELEGATE_FCPViewDidAppearNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (_FCProgressWindow) {
        _FCProgressWindow.hidden = YES;
        [_FCProgressWindow resignKeyWindow];
    }
    
}

- (void) continueAnimating {
    
    if (currentFCPViewController && currentFCPViewController.isAnimating) {
        [currentFCPViewController.FCProgressCircleView setIsAnimating:YES];
    }
    
}

- (void) initView {
    
    CGFloat backViewWidth = self.view.frame.size.width/3.0;
    if (backViewWidth<120.0) {
        backViewWidth = 120.0;
    }
    self.view.backgroundColor = [UIColor clearColor];
    self.backProgressView = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-backViewWidth)/2.0, (self.view.frame.size.height-backViewWidth)/2.0, backViewWidth, backViewWidth)];
    self.backProgressView.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8] ;
    self.backProgressView.layer.masksToBounds = YES;
    self.backProgressView.layer.cornerRadius = 10.0;
    [self.view addSubview:self.backProgressView];
    
    self.FCProgressCircleView = [FCProgressCircleView circleWithColor:[UIColor colorWithRed:50.0/255.0 green:155.0/255.0 blue:255.0/255.0 alpha:0.8] width:backViewWidth/2.0];
    CGRect circleRect = CGRectMake((self.backProgressView.frame.size.width-backViewWidth/2.0)/2.0, (self.backProgressView.frame.size.height-backViewWidth/2.0)/2.0, backViewWidth/2.0, backViewWidth/2.0);
    circleRect.origin = CGPointMake(self.backProgressView.bounds.size.width/2.0 - circleRect.size.width/2.0, 10);
    self.FCProgressCircleView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.FCProgressCircleView.frame = circleRect;
    self.FCProgressCircleView.hasGlow = YES;
    self.FCProgressCircleView.isAnimating = YES;
    self.FCProgressCircleView.speed = 0.55;
    [self.backProgressView addSubview:self.FCProgressCircleView];
    
    self.bodyLabel = [[UILabel alloc] init];
    if (backViewWidth == 120.0) {
        self.bodyLabel.font = [UIFont systemFontOfSize:12.0];
    } else {
        self.bodyLabel.font = [UIFont systemFontOfSize:14.0];
    }
    
    self.bodyLabel.textColor = [UIColor whiteColor];
    self.bodyLabel.textAlignment = NSTextAlignmentCenter;
    self.bodyLabel.frame = CGRectMake(0, backViewWidth/2.0, backViewWidth, backViewWidth/2.0);
    if (self.bodyText.length >0) {
        self.bodyLabel.text = self.bodyText;
    } else {
        self.bodyLabel.text = NSLocalizedString(@"LoadingPleaseWait", @"");
        
    }
    [self.backProgressView addSubview:self.bodyLabel];
    
    
    
}

- (UIWindow*)FCProgressWindow {
    
    if (_FCProgressWindow == nil) {
        _FCProgressWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _FCProgressWindow.windowLevel = UIWindowLevelStatusBar+1;
        _FCProgressWindow.hidden = NO;
        _FCProgressWindow.alpha = 1.0;
        _FCProgressWindow.userInteractionEnabled = YES;
        [_FCProgressWindow makeKeyAndVisible];
    }
    return _FCProgressWindow;
}

- (void)addToDisplayQueue
{
    if(!displayQueue)
        displayQueue = [NSMutableArray arrayWithCapacity:2];
    if(!dismissQueue)
        dismissQueue = [NSMutableArray arrayWithCapacity:2];
    
    [displayQueue addObject:self];
    [dismissQueue addObject:self];
    
    if(retainQueue.count == 0)
    {
        currentFCPViewController = self;
        currentFCPViewController.isAnimating = YES;
        [self addToWindow];
    }
    
}

- (void)addToWindow {
    
    if (self.FCProgressWindow) {
        
        [self.FCProgressWindow addSubview:self.view];
        [self.FCProgressWindow makeKeyAndVisible];
    }
    
    [self resignFirstRespondersForSubviews:_FCProgressWindow];
    
}

- (void)dismissController
{
    if(dismissQueue.count > 0)
    {
        FCProgressViewController *lastViewController = [dismissQueue lastObject];
        [displayQueue removeObject:lastViewController];
        [dismissQueue removeObject:lastViewController];
        [lastViewController dismiss];
        
    }
}

+ (void)dismissCurrentViewController
{
    if(dismissQueue.count > 0)
    {
        FCProgressViewController *lastViewController = [dismissQueue lastObject];
        [displayQueue removeObject:lastViewController];
        [dismissQueue removeObject:lastViewController];
        [lastViewController dismiss];
        
    }
}

+ (void)dismissCurrentAfterDelay:(float)delay
{
    [[FCProgressViewController class] performSelector:@selector(dismissCurrentViewController) withObject:nil afterDelay:delay];
}

-(void)dismiss
{
    if(!retainQueue)
        retainQueue = [[NSMutableArray alloc] init];
    
    [self.hideTimer invalidate];
    [retainQueue addObject:self];
    
    [self addDismissAnimation];
    
}

//把编辑窗口都关掉
-(void)resignFirstRespondersForSubviews:(UIView *)view
{
    [self resignFirstRespondersForView:view];
}


-(void)resignFirstRespondersForView:(UIView*)view
{
    for (UIView *subview in [view subviews])
    {
        if ([subview isKindOfClass:[UITextField class]] || [subview isKindOfClass:[UITextView class]]) {
            [(id)subview resignFirstResponder];
        }
        [self resignFirstRespondersForView:subview];
    }
}


#define kDismissDuration 0.1

-(void)addDismissAnimation
{
    NSArray *frameTimes = @[@(0.15), @(0.05)];
    CAKeyframeAnimation *animation = [self animationWithValues:nil times:frameTimes duration:kDismissDuration];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    [self.view.layer addAnimation:animation forKey:@"popup"];
    
    [self performSelector:@selector(removeFromView) withObject:nil afterDelay:0.1];
}

-(CAKeyframeAnimation*)animationWithValues:(NSArray*)values times:(NSArray*)times duration:(CGFloat)duration
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.removedOnCompletion = NO;
    animation.duration = duration;
    return animation;
}

-(void)removeFromView
{
    if (retainQueue.count >0) {
        [retainQueue removeObject:self];
    }
    
    currentFCPViewController.isAnimating = YES;
    [currentFCPViewController.view removeFromSuperview];
    currentFCPViewController = nil;
    
    if(displayQueue.count > 0)
    {
        FCProgressViewController *viewController = [displayQueue objectAtIndex:0];
        currentFCPViewController = viewController;
        [viewController addToWindow];
    }
}

@end

