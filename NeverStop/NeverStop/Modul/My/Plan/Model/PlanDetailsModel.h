//
//  PlanDetailsModel.h
//  NeverStop
//
//  Created by DYQ on 16/11/12.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "DYQBaseModel.h"

@interface PlanDetailsModel : DYQBaseModel

@property (nonatomic, strong) NSString *planName;
@property (nonatomic, strong) NSString *planImg;
@property (nonatomic, strong) NSString *planBg;
@property (nonatomic, strong) NSNumber *timeSpan;
@property (nonatomic, strong) NSNumber *totalMileage;
@property (nonatomic, strong) NSArray *plandetails;



@end
