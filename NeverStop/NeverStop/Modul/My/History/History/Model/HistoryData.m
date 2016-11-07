//
//  HistoryData.m
//  NeverStop
//
//  Created by Jiang on 16/11/5.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "HistoryData.h"

@implementation HistoryData
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.array = [NSMutableArray array];
    }
    return self;
}
@end
