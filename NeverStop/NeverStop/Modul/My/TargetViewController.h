//
//  TargetViewController.h
//  NeverStop
//
//  Created by DYQ on 16/11/1.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TargetVCDelegate <NSObject>

- (void)targetChanged:(NSString *)target;

@end

@interface TargetViewController : UIViewController

@property (nonatomic, assign) id<TargetVCDelegate>delegate;

@end
