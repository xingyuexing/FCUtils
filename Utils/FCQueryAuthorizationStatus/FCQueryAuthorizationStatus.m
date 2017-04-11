//
//  FCQueryAuthorizationStatus.m
//  FCUtils
//
//  Created by 宋明月 on 2017/4/10.
//  Copyright © 2017年 宋明月. All rights reserved.
//


#import "FCQueryAuthorizationStatus.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AddressBookUI/AddressBookUI.h>
#import <ContactsUI/ContactsUI.h>

@implementation FCQueryAuthorizationStatus


// 获得访问用户相机授权状态
+ (BOOL)getPhotoAuthStatus {
    
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus ==AVAuthorizationStatusRestricted) {
        
    } else if(authStatus == AVAuthorizationStatusDenied) {
        return NO;
    } else if(authStatus == AVAuthorizationStatusAuthorized) {
        //允许访问
        return YES;
    } else if(authStatus == AVAuthorizationStatusNotDetermined) {
        return YES;
    } else {
        
    }
    return NO;
}

+ (void)getPhotoAuthStatus:(void (^)(BOOL))state isFirst:(void (^)(BOOL))isFirst {
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus ==AVAuthorizationStatusRestricted) {
        state(NO);
    } else if(authStatus == AVAuthorizationStatusDenied) {
        state(NO);
    } else if(authStatus == AVAuthorizationStatusAuthorized) {
        //允许访问
        state(YES);
    } else if(authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            state(granted);
        }];
        isFirst(YES);
    } else {
        state(NO);
    }
}

// 获得访问用户相册授权状态
+ (BOOL)getPhotoAlbumAuthStatus {
    ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
    if(authStatus ==AVAuthorizationStatusRestricted) {
        
    } else if(authStatus == AVAuthorizationStatusDenied) {
        return NO;
    } else if(authStatus == AVAuthorizationStatusAuthorized) {
        // 允许访问
        return YES;
    } else if(authStatus == AVAuthorizationStatusNotDetermined) {
        return YES;
    } else {
        
    }
    return NO;
}

#pragma mark - 通讯录权限

+ (void)getAddressBook:(void (^)(BOOL isSucc))state {
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {//授权状态，ios9以上版本
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        if (status == CNAuthorizationStatusAuthorized) {
            // 存在权限
            state(YES);
        } else if (status == CNAuthorizationStatusNotDetermined) {
            // 权限未知 首次访问
            CNContactStore *store = [[CNContactStore alloc] init];
            [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if (granted) {
                    // 存在权限
                    state(YES);
                } else {
                    state(NO);
                    __block UIAlertView *alert = nil;
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        alert = [self createAlertView];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [alert show];
                        });
                    });
                }
            }];
            
        } else {
            state(NO);
        }
    } else{
        ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
        if (status == kABAuthorizationStatusAuthorized) {
            // 存在权限
            state(YES);
        } else if (status == kABAuthorizationStatusNotDetermined) {
            // 权限未知 首次访问
            ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                if (granted) {
                    state(YES);
                    CFRelease(addressBook);
                } else {
                    state(NO);
                    __block UIAlertView *alert = nil;
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        alert = [self createAlertView];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [alert show];
                        });
                    });
                    CFRelease(addressBook);
                }
            });
        } else {
            state(NO);
        }
    }
}

+ (UIAlertView *)createAlertView {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Prompt", @"") message:NSLocalizedString(@"AuthorizedToAccessAddressBook", @"") delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Okey", @""),nil];
    return alert;
}

@end

