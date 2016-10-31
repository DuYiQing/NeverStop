//
//  MapDataManager.h
//  NeverStop
//
//  Created by Jiang on 16/10/27.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MapDataManager : NSObject
+ (instancetype)defaultManager;
@property (nonatomic, strong) NSMutableArray *allLocationArray;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) CGFloat distance;
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, assign) CGFloat speedPerHour;
@property (nonatomic, assign) CGFloat averageSpeed;
@property (nonatomic, assign) CGFloat maxSpeed;
@property (nonatomic, assign) CGFloat calorie;
@end
