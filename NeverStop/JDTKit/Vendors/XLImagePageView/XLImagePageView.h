//
//  XLImagePageView.h
//  XLImagePageDemo
//
//  Created by Eiwodetianna on 9/8/15.
//  Copyright © 2015 jinxinliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XLImagePageView;

@protocol XLImagePageViewDelegate <NSObject>

@optional

- (void)XLImagePageView:(XLImagePageView *)imagePageView didSelectPageAtIndex:(NSInteger)pageIndex;

@end

@interface XLImagePageView : UIView

@property (nonatomic, weak) id<XLImagePageViewDelegate>delegate;
@property (nonatomic, strong) NSArray *imageArray;

@end
