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
@property (nonatomic, retain) NSMutableArray *allLocationArray;

@end
