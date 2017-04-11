//
//  FCProgressViewController.h
//  FCUtils
//
//  Created by 宋明月 on 2017/4/10.
//  Copyright © 2017年 宋明月. All rights reserved.
//

//
//  FCProgressViewController.h
//  progressView
//
//  Created by sunyw on 4/1/15.
//  Copyright (c) 2015 sunyw. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef enum {
    FCProgressViewTypeDefault,
    
} FCProgressViewType;


@interface FCProgressViewController : UIViewController {
    BOOL isPendingDismissal;
    
}
@property (nonatomic, copy) id dismissalBlock;

@property (nonatomic,copy) NSString *bodyText;
@property (nonatomic, assign) FCProgressViewType progressType;
@property (nonatomic, assign) float viewHideDelay;
@property (nonatomic, assign) BOOL addsToWindow;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIView *backProgressView;
@property (nonatomic, strong) UILabel *bodyLabel;

@property (nonatomic, strong) NSTimer *hideTimer;
@property (nonatomic, assign) BOOL isAnimating;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) BOOL hasGlow;
@property (nonatomic, assign) float speed;

//默认30秒，等待状态自动消失
+(FCProgressViewController*)progressViewWithBody:(NSString*)bodyText type:(FCProgressViewType)progressType hidesAfter:(float)delay show:(BOOL)show;

//等待状态不会自动消失
+(FCProgressViewController*)progressViewWithBody:(NSString*)bodyText type:(FCProgressViewType)progressType show:(BOOL)show;

+(void)dismissCurrentAfterDelay:(float)delay;
+(void)dismissCurrentViewController;

-(void)dismiss;

@end



