//
//  MapDataManager.m
//  NeverStop
//
//  Created by Jiang on 16/10/27.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "MapDataManager.h"

@implementation MapDataManager
+ (instancetype)defaultManager {
    static MapDataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MapDataManager alloc] init];
    });
    return manager;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

@end
