//
//  Scope.h
//  NeverStop
//
//  Created by dllo on 16/10/29.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "DYQBaseModel.h"
@class Info;
@class Location;
@interface Scope : DYQBaseModel
@property (nonatomic, strong) Info *info;
@property (nonatomic, strong) Location *location;
@end
