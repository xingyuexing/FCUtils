//
//  FCLocalFileManager.h
//  FCUtils
//
//  Created by 宋明月 on 2017/4/10.
//  Copyright © 2017年 宋明月. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define FILENAME @"FCDocImageFile"
#define FILEVOICENAME @"FCDocVoiceFile"

@interface FCLocalFileManager : NSObject

#pragma mark - 图片文件管理
/**创建文件夹）*/
+ (void)createFolder;

/**缓存到指定的文件夹当中（imgName图片名字）*/
+ (BOOL)downloadFolderWithImgName:(NSString *)imgName imageData:(NSData *)imageData;

/**删除沙箱中的缓存图片（会删除该文件）*/
+ (void)delelateFolder;

/**统计文件夹大小*/
+ (CGFloat)fileSize;

/**读取沙箱中的图片*/
+ (UIImage *)readFromDataBoxWithPhotoName:(NSString *)photoName;

#pragma mark - 音频管理
/** 创建音频文件夹 */
+ (void)creatVoiceFolder;

/** 生成音频路径 */
+ (NSString *)creatVoicePathWithName:(NSString *)name andType:(NSString *)type;

/**缓存到指定的文件夹当中（voice名字）*/
+ (BOOL)downloadFolderWithVoiceName:(NSString *)voiceName VoiceData:(NSData *)voiceData;

/** 判断文件是否存在 */
+ (BOOL)isFileExist:(NSString *)fileUrl;

/** 移除指定路径文件 */
+ (BOOL)deleteVoiceFileWithFileUrl:(NSString *)fileUrl;

@end

