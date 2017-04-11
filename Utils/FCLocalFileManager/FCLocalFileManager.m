//
//  FCLocalFileManager.m
//  FCUtils
//
//  Created by 宋明月 on 2017/4/10.
//  Copyright © 2017年 宋明月. All rights reserved.
//


#import "FCLocalFileManager.h"

@implementation FCLocalFileManager

#pragma mark - 图片存储
//创建文件夹
+ (void)createFolder
{
    //创建文件夹类
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    //获取沙盒（沙箱）根目录
    NSString *homePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    //创建自己的文件夹
    NSString *createOrangePath = [NSString stringWithFormat:@"%@/%@", homePath,FILENAME];
    
    // 判断文件夹是否存在，如果不存在，则创建
    if (![fileManager fileExistsAtPath:createOrangePath]) {
        //创建文件夹
        [fileManager createDirectoryAtPath:createOrangePath withIntermediateDirectories:YES attributes:nil error:nil];
    } else {
        NSLog(@"文件夹存在，不进行创建");
    }
}

/**缓存到指定的文件夹当中（imgName图片名字）*/
+ (BOOL)downloadFolderWithImgName:(NSString *)imgName imageData:(NSData *)imageData
{
    //获取沙盒（沙箱）根目录
    NSString *homePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    //获取自己的文件夹
    NSString *orangePath = [NSString stringWithFormat:@"%@/%@",homePath,FILENAME];
    NSString *orangeImgPath = [orangePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",imgName,nil]];
    NSLog(@"文件夹位置：%@",orangePath);
    return [imageData writeToFile: orangeImgPath atomically:YES];
}

/**删除沙箱中的缓存图片（会删除该文件）*/
+ (void)delelateFolder
{
    //获取系统全局（并发队列）
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void){
        //获取沙盒（沙箱）根目录
        NSString *homePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        //获取自己的文件夹
        NSString *orangePath = [NSString stringWithFormat:@"%@/%@",homePath,FILENAME];
        NSFileManager* fileManager = [NSFileManager defaultManager];
        if ([fileManager removeItemAtPath:orangePath error:NULL]) {
            [FCLocalFileManager createFolder];
        }
    });
}

/**统计文件夹大小*/
+ (CGFloat)fileSize
{
    NSFileManager* manager = [NSFileManager defaultManager];
    //获取沙盒（沙箱）根目录
    NSString *homePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    //获取自己的文件夹
    NSString *createOrangePath = [NSString stringWithFormat:@"%@/%@", homePath,FILENAME];
    //判断该文件夹是否存在
    if ([manager fileExistsAtPath:createOrangePath]){
        //获取改文件夹的大小
        float folderSize = [[manager attributesOfItemAtPath:createOrangePath error:nil] fileSize];
        return folderSize/10;
    }else
        return 0;
}

/**读取沙箱中的图片*/
+ (UIImage *)readFromDataBoxWithPhotoName:(NSString *)photoName
{
    NSString *fullPath = [[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:FILENAME] stringByAppendingPathComponent:photoName];
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
    return savedImage;
}

#pragma mark - 语音存储
/** 创建音频文件夹 */
+ (void)creatVoiceFolder
{
    //创建文件夹类
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    //获取沙盒（沙箱）根目录
    NSString *homePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    //创建自己的文件夹
    NSString *createOrangePath = [NSString stringWithFormat:@"%@/%@", homePath,FILEVOICENAME];
    
    // 判断文件夹是否存在，如果不存在，则创建
    if (![fileManager fileExistsAtPath:createOrangePath]) {
        //创建文件夹
        [fileManager createDirectoryAtPath:createOrangePath withIntermediateDirectories:YES attributes:nil error:nil];
    } else {
        NSLog(@"音频文件夹存在，不进行创建");
    }
}

/** 生成音频路径 */
+ (NSString *)creatVoicePathWithName:(NSString *)name andType:(NSString *)type
{
    NSString *pathUrl;
    //获取沙盒（沙箱）根目录
    NSString *homePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    //创建自己的文件夹
    NSString *createOrangePath = [NSString stringWithFormat:@"%@/%@", homePath,FILEVOICENAME];
    pathUrl = [NSString stringWithFormat:@"%@/%@.%@",createOrangePath,name,type];
    return pathUrl;
}

/**缓存到指定的文件夹当中（voice名字）*/
+ (BOOL)downloadFolderWithVoiceName:(NSString *)voiceName VoiceData:(NSData *)voiceData
{
    //获取沙盒（沙箱）根目录
    NSString *homePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    //获取自己的文件夹
    NSString *orangePath = [NSString stringWithFormat:@"%@/%@",homePath,FILEVOICENAME];
    NSString *orangeImgPath = [orangePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",voiceName,nil]];
    NSLog(@"音频文件夹位置：%@",orangePath);
    return [voiceData writeToFile: orangeImgPath atomically:YES];
}

/** 判断文件是否存在 */
+ (BOOL)isFileExist:(NSString *)fileUrl
{
    BOOL isExist;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    isExist = [fileManager fileExistsAtPath:fileUrl];
    return isExist;
}

/** 移除指定路径文件 */
+ (BOOL)deleteVoiceFileWithFileUrl:(NSString *)fileUrl
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if ([fileManager removeItemAtPath:fileUrl error:NULL]) {
        NSLog(@"移除：%@",fileUrl);
        return YES;
    }
    return NO;
}


@end

