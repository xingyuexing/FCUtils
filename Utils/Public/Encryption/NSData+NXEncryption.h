//
//  NSData+NXEncryption.h
//  FCUtils
//
//  Created by 宋明月 on 2017/4/10.
//  Copyright © 2017年 宋明月. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (NXEncryption)

- (NSData *)AES256EncryptWithKey:(NSString *)key;

- (NSData *)AES256DecryptWithKey:(NSString *)key;

- (NSString *)newStringInBase64FromData;

+ (NSString*)base64encode:(NSString*)str;



@end
