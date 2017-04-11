//
//  UnderLineTextField.m
//  FCUtils
//
//  Created by 宋明月 on 2017/4/10.
//  Copyright © 2017年 宋明月. All rights reserved.
//

#import "UnderLineTextField.h"

@implementation UnderLineTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)setColor:(UIColor *)color{
    self.lineColor = color;
    [self setNeedsDisplay];
}


- (void) drawRect:(CGRect)rect {

    if ([self.lineColor isKindOfClass:[UIColor class]]) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, self.lineColor.CGColor);
        CGContextFillRect(context, CGRectMake(0,
                                              CGRectGetHeight(self.frame) - 0.5,
                                              CGRectGetWidth(self.frame),
                                              0.5));
    }
}


@end
