//
//  FCSearchBar.m
//  FCUtils
//
//  Created by 宋明月 on 2017/4/10.
//  Copyright © 2017年 宋明月. All rights reserved.
//

#import "FCSearchBar.h"

@implementation FCSearchBar

- (void)awakeFromNib {
    [super awakeFromNib];
    UIColor *color = [UIColor colorWithRed:0xf2/255.0 green:0xf2/255.0  blue:0xf2/255.0  alpha:1.0];
    self.barTintColor = color;
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = 0.5;
    
    [self setImage:[UIImage imageNamed:@"searchMagnifier"]
  forSearchBarIcon:UISearchBarIconSearch
             state:UIControlStateNormal];
}

@end
