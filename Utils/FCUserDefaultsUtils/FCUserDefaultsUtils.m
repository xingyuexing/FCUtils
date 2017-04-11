//
//  FCUserDefaultsUtils.m
//  FCUtils
//
//  Created by 宋明月 on 2017/4/10.
//  Copyright © 2017年 宋明月. All rights reserved.
//


#import "FCUserDefaultsUtils.h"

#define LAST_HOSPITAL_ID       @"last_hospitalId"
#define LAST_CITY_NAME         @"last_cityName"
#define LAST_CITY_Code         @"last_cityCode"

@implementation FCUserDefaultsUtils

+ (void)saveUserDefaultValue:(NSString *)value key:(NSString *)key {
    
    NSUserDefaults *userDefaulet = [NSUserDefaults standardUserDefaults];
    [userDefaulet setObject:value forKey:key];
}

+ (NSString *)getSavedValueByKey:(NSString *)key {
    
    NSUserDefaults *userDefaulet = [NSUserDefaults standardUserDefaults];
    return [userDefaulet objectForKey:key];
}

+ (void)saveLastHospitalId:(NSString *)lastHospitalId {
    [self saveUserDefaultValue:lastHospitalId key:LAST_HOSPITAL_ID];
}

+ (NSString *)getSavedLastHospitalId {
    return [self getSavedValueByKey:LAST_HOSPITAL_ID];
}

+ (void)saveLastCityName:(NSString *)lastCityName {
    [self saveUserDefaultValue:lastCityName key:LAST_CITY_NAME];
}

+ (NSString *)getSavedLastCityName {
    
    return [self getSavedValueByKey:LAST_CITY_NAME];
}

// 上次选择城市Code
+ (void)saveLastCityCode:(NSString *)saveLastCityCode {
    [self saveUserDefaultValue:saveLastCityCode key:LAST_CITY_Code];
}
+ (NSString *)getSavedLastCityCode {
    return [self getSavedValueByKey:LAST_CITY_Code];
}

@end
