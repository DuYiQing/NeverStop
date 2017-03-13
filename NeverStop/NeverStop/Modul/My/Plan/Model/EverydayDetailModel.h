//
//  EverydayDetailModel.h
//  NeverStop
//
//  Created by DYQ on 16/11/14.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "DYQBaseModel.h"

@interface EverydayDetailModel : DYQBaseModel

@property (nonatomic, strong) NSString *plandetailId;
@property (nonatomic, strong) NSString *detailName;
@property (nonatomic, strong) NSString *detailDesc;
@property (nonatomic, strong) NSNumber *meter;

@end
