//
//  AimModel.m
//  NeverStop
//
//  Created by Jiang on 16/10/21.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "AimModel.h"

@implementation AimModel
+ (NSArray *) creatAimData {
   
    NSMutableArray *defaultSettingArray = [NSMutableArray arrayWithObjects:@"普通运动", nil];
    NSMutableDictionary *defaultAimDic = [NSMutableDictionary dictionary];
    [defaultAimDic setValue:@"不设目标" forKey:@"aimName"];
    [defaultAimDic setValue:defaultSettingArray forKey:@"aimSetting"];
    
    
    NSMutableArray *lastSettingArray = [NSMutableArray arrayWithObjects:@"无", nil];
    NSMutableDictionary *lastAimDic = [NSMutableDictionary dictionary];
    [lastAimDic setValue:@"上次选择" forKey:@"aimName"];
    [lastAimDic setValue:lastSettingArray forKey:@"aimSetting"];

    
    
    NSMutableArray *distanceSettingArray = [NSMutableArray arrayWithObjects:@"自定义", @"5公里", @"10公里", @"15公里", @"20公里", @"25公里", @"30公里", @"50公里", nil];
  
    NSMutableDictionary *distanceAimDic = [NSMutableDictionary dictionary];
    [distanceAimDic setValue:@"距离目标" forKey:@"aimName"];
    [distanceAimDic setValue:distanceSettingArray forKey:@"aimSetting"];
  
    
    
    NSMutableArray *timeSettingArray = [NSMutableArray arrayWithObjects:@"自定义", @"30分钟", @"60分钟", @"90分钟", @"120分钟", @"150分钟", @"180分钟", nil];
    NSMutableDictionary *timeAimDic = [NSMutableDictionary dictionary];
    [timeAimDic setValue:@"时间目标" forKey:@"aimName"];
    [timeAimDic setValue:timeSettingArray forKey:@"aimSetting"];

    
     NSMutableArray *calorieSettingArray = [NSMutableArray arrayWithObjects:@"自定义", @"200大卡", @"300大卡", @"500大卡", @"600大卡", @"800大卡", @"1000大卡", @"1200大卡", @"1500大卡",nil];
    NSMutableDictionary *calorieAimDic = [NSMutableDictionary dictionary];
    [calorieAimDic setValue:@"卡路里目标" forKey:@"aimName"];
    [calorieAimDic setValue:calorieSettingArray forKey:@"aimSetting"];
    
    
    NSMutableArray *array = [NSMutableArray arrayWithObjects:defaultAimDic, lastAimDic, distanceAimDic, timeAimDic, calorieAimDic, nil];
    return array;
}
@end
