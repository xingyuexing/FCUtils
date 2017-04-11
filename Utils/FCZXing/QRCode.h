//
//  QRCode.h
//  FCUtils
//
//  Created by 宋明月 on 2017/4/10.
//  Copyright © 2017年 宋明月. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QRCode : NSObject

+ (QRCode *)sharedInstance;

// 生成条形码图片
- (UIImage *)getBarCodeImageByCode:(NSString *)code width:(CGFloat)width height:(CGFloat)height;

// 生成二维码码图片
- (UIImage *)getQRCodeImageByCode:(NSString *)code width:(CGFloat)width height:(CGFloat)height;


@end
