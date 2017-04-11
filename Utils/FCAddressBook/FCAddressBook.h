//
//  FCAddressBook.h
//  FCUtils
//
//  Created by 宋明月 on 2017/4/10.
//  Copyright © 2017年 宋明月. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBookUI/AddressBookUI.h>

@interface FCAddressBook : NSObject <ABPeoplePickerNavigationControllerDelegate>

@property(nonatomic,strong) UIViewController *controller;

@property(nonatomic,copy)void(^completeBlock)(NSString *name,NSString *tel);

-(void)showInController:(UIViewController *)controller completeBlock:(void (^)(NSString *, NSString *))block;

@end
