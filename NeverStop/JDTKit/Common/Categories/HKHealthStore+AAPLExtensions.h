//
//  HKHealthStore+AAPLExtensions.h
//  Never Stop
//
//  Created by DYQ on 16/10/19.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import <HealthKit/HealthKit.h>
@interface HKHealthStore (AAPLExtensions)

- (void)aapl_mostRecentQuantitySampleOfType:(HKQuantityType *)quantityType predicate:(NSPredicate *)predicate completion:(void (^)(NSArray *results, NSError *error))completion;
@end
