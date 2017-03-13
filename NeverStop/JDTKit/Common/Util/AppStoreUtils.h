//
//  AppStoreUtils.h
//  LazyLoadingTest1
//
//  Created by Eiwodetianna on 15/1/15.
//  Copyright (c) 2015年 Eiwodetianna. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppStoreUtils : NSObject

/**
 *  跳转到App Store评分或者升级
 */
+ (void)gotoAppStore;

/*
 *  当前程序的版本号
 */
@property (nonatomic,copy,readonly) NSString *version;


@end

