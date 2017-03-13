//
//  NSNumber+Extend.h
//  BaseProject
//
//  Created by Eiwodetianna on 15/8/5.
//  Copyright (c) 2015年 Eiwodetianna. All rights reserved.
//

#import <Foundation/Foundation.h>

#undef	__DOUBLE
#define	__DOUBLE( __x )			[NSNumber numberWithDouble:(double)__x]


@interface NSNumber (Extend)

- (double)safeDouble;
- (BOOL)numberIsFloat;
- (BOOL)numberIsInt;

@end
