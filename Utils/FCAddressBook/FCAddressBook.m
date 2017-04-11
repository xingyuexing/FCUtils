//
//  FCAddressBook.m
//  FCUtils
//
//  Created by 宋明月 on 2017/4/10.
//  Copyright © 2017年 宋明月. All rights reserved.
//


#import "FCAddressBook.h"
#import <Foundation/Foundation.h>
#import "FCQueryAuthorizationStatus.h"
#import "FCUtils.h"

@interface FCAddressBook() {
    ABPeoplePickerNavigationController *peoplePicker;
}

@end

@implementation FCAddressBook

- (id)init {
    
    self = [super init];
    
    if (self) {
        
        peoplePicker = [[ABPeoplePickerNavigationController alloc] init];
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
            peoplePicker.predicateForSelectionOfPerson = [NSPredicate predicateWithValue:NO];
        }
        peoplePicker.peoplePickerDelegate = self;
    }
    
    return self;
}

-(void)showInController:(UIViewController *)controller completeBlock:(void (^)(NSString *, NSString *))block {
    [FCQueryAuthorizationStatus getAddressBook:^(BOOL isSucc) {
        if (isSucc) {
            self.controller = controller;
            self.completeBlock = block;
            
            [self.controller.navigationController presentViewController:peoplePicker animated:YES completion:^{}];
            
        } else {
            __block UIAlertView *alert = nil;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Prompt", @"") message:NSLocalizedString(@"AuthorizedToAccessAddressBook", @"") delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Okey", @""),nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [alert show];
                });
            });
        }
    }];
}

// iOS version >= 8.0
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker
                         didSelectPerson:(ABRecordRef)person {
    
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker
                         didSelectPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier {
    
    NSString *name = (__bridge NSString*)ABRecordCopyCompositeName(person);
    CFStringRef value = nil;
    ABMultiValueRef valuesRef = ABRecordCopyValue(person, kABPersonPhoneProperty);
    CFIndex index = ABMultiValueGetIndexForIdentifier(valuesRef,identifier);
    
    if (ABMultiValueGetCount(valuesRef) > 0) {
        if (index < 0) {
            index = 0;
        }
        value = ABMultiValueCopyValueAtIndex(valuesRef,index);
    }
    
    NSString *phoneNumber = [self checkPhoneNumber:(__bridge NSString *)(value)];
    self.completeBlock(name,phoneNumber);
}

// iOS version < 8.0
-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    return YES;
}
-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    
    NSString *name = (__bridge NSString*)ABRecordCopyCompositeName(person);
    CFStringRef value = nil;
    ABMultiValueRef valuesRef = ABRecordCopyValue(person, kABPersonPhoneProperty);
    CFIndex index = ABMultiValueGetIndexForIdentifier(valuesRef,identifier);
    
    if (ABMultiValueGetCount(valuesRef) > 0) {
        if (index < 0) {
            index = 0;
        }
        value = ABMultiValueCopyValueAtIndex(valuesRef,index);
    }
    
    NSString *phoneNumber = [self checkPhoneNumber:(__bridge NSString *)(value)];
    self.completeBlock(name,phoneNumber);
    
    [self.controller dismissViewControllerAnimated:YES completion:nil];
    
    return NO;
    
}

-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    self.completeBlock(@"",@"");
    [self.controller dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *)checkPhoneNumber:(NSString *)phoneNumber {
    
    if (phoneNumber == nil || [phoneNumber isEqualToString:@""]) {
        
        return phoneNumber;
    }
    
    NSMutableString *str1 = [NSMutableString stringWithString:phoneNumber];
    for (int i = 0; i < str1.length; i++) {
        unichar c = [str1 characterAtIndex:i];
        NSRange range = NSMakeRange(i, 1);
        if (c == '-') {
            [str1 deleteCharactersInRange:range];
            --i;
        }
    }
    NSString *newstr = [NSString stringWithString:str1];
    
    return newstr;
}

@end

