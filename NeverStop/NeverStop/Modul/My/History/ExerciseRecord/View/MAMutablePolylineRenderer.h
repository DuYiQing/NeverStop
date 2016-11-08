//
//  MAMutablePolylineRenderer.h
//  NeverStop
//
//  Created by Jiang on 16/11/8.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import <MAMapKit/MAOverlayPathRenderer.h>
#import "MAMutablePolyline.h"

@interface MAMutablePolylineRenderer : MAOverlayPathRenderer

@property (nonatomic, readonly) MAMutablePolyline *mutablePolyline;

- (instancetype)initWithMutablePolyline:(MAMutablePolyline *)polyline;

@end
