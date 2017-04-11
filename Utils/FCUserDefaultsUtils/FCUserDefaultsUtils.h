//
//  FCUserDefaultsUtils.h
//  FCUtils
//
//  Created by 宋明月 on 2017/4/10.
//  Copyright © 2017年 宋明月. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FCUserDefaultsUtils : NSObject

// 上次就诊的医院
+ (void)saveLastHospitalId:(NSString *)lastHospitalId;
+ (NSString *)getSavedLastHospitalId;

// 上次选择的名称城市
+ (void)saveLastCityName:(NSString *)lastCityName;
+ (NSString *)getSavedLastCityName;
// 上次选择城市Code
+ (void)saveLastCityCode:(NSString *)saveLastCityCode;
+ (NSString *)getSavedLastCityCode;

@end
