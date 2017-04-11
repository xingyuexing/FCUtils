//
//  QRCode.m
//  FCUtils
//
//  Created by 宋明月 on 2017/4/10.
//  Copyright © 2017年 宋明月. All rights reserved.
//

//
//  QRCode.m
//  Anymed
//
//  Created by zhuenkai on 15/5/21.
//  Copyright (c) 2015年 neusoft. All rights reserved.
//

#import "QRCode.h"
#import <ZXMultiFormatWriter.h>
#import <ZXBitMatrix.h>
#import <ZXImage.h>
#import <ZXBitMatrix.h>

static QRCode *sharedInstance = nil;
@implementation QRCode


+ (QRCode *)sharedInstance {
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[QRCode alloc] init];
        
    });
    
    return sharedInstance;
}

- (UIImage *)getBarCodeImageByCode:(NSString *)code width:(CGFloat)width height:(CGFloat)height {
    
    if (code.length == 0) {
        return nil;
    }
    
    ZXMultiFormatWriter *writer = [[ZXMultiFormatWriter alloc] init];
    ZXBitMatrix *result = [writer encode:code
                                  format:kBarcodeFormatCode128
                                   width:width
                                  height:height
                                   error:nil];
    
    UIImage *barCodeImage = nil;
    
    if (result) {
        ZXImage *image = [ZXImage imageWithMatrix:result];
        barCodeImage = [UIImage imageWithCGImage:image.cgimage];
    }
    
    return barCodeImage;
}

// 生成二维码码图片
- (UIImage *)getQRCodeImageByCode:(NSString *)code width:(CGFloat)width height:(CGFloat)height
{
    ZXMultiFormatWriter *writer = [[ZXMultiFormatWriter alloc] init];
    ZXBitMatrix *result = [writer encode:code
                                  format:kBarcodeFormatQRCode
                                   width:width
                                  height:height
                                   error:nil];
    
    UIImage *barCodeImage = nil;
    
    if (result) {
        ZXImage *image = [self imageWithMatrix:result];
        barCodeImage = [UIImage imageWithCGImage:image.cgimage];
    }
    
    return barCodeImage;
}

//改颜色
- (ZXImage *)imageWithMatrix:(ZXBitMatrix *)matrix {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    CGFloat blackComponents[] = {0.0f, 1.0f};
    CGColorRef black = CGColorCreate(colorSpace, blackComponents);
    CGColorRef white = [UIColor clearColor].CGColor;
    
    CFRelease(colorSpace);
    
    ZXImage *result = [self imageWithMatrix:matrix onColor:black ofZXolor:white];
    
    CGColorRelease(white);
    CGColorRelease(black);
    
    return result;
}

- (ZXImage *)imageWithMatrix:(ZXBitMatrix *)matrix onColor:(CGColorRef)onColor ofZXolor:(CGColorRef)ofZXolor {
    int8_t onIntensities[4], offIntensities[4];
    
    [self setColorIntensities:onIntensities color:onColor];
    [self setColorIntensities:offIntensities color:ofZXolor];
    
    int width = matrix.width;
    int height = matrix.height;
    int8_t *bytes = (int8_t *)malloc(width * height * 4);
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            BOOL bit = [matrix getX:x y:y];
            for (int i = 0; i < 4; i++) {
                int8_t intensity = bit ? onIntensities[i] : offIntensities[i];
                bytes[y * width * 4 + x * 4 + i] = intensity;
            }
        }
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef c = CGBitmapContextCreate(bytes, width, height, 8, 4 * width, colorSpace, kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedLast);
    CFRelease(colorSpace);
    CGImageRef image = CGBitmapContextCreateImage(c);
    CFRelease(c);
    free(bytes);
    
    ZXImage *zxImage = [[ZXImage alloc] initWithCGImageRef:image];
    
    CFRelease(image);
    return zxImage;
}

- (void)setColorIntensities:(int8_t *)intensities color:(CGColorRef)color {
    memset(intensities, 0, 4);
    
    size_t numberOfComponents = CGColorGetNumberOfComponents(color);
    const CGFloat *components = CGColorGetComponents(color);
    
    if (numberOfComponents == 4) {
        for (int i = 0; i < 4; i++) {
            intensities[i] = components[i] * 255;
        }
    } else if (numberOfComponents == 2) {
        for (int i = 0; i < 3; i++) {
            intensities[i] = components[0] * 255;
        }
        intensities[3] = components[1] * 255;
    }
}
@end
