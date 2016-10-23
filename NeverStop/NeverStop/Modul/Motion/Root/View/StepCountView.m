//
//  StepCountView.m
//  NeverStop
//
//  Created by DYQ on 16/10/21.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "StepCountView.h"

@interface StepCountView ()

@property (nonatomic, retain) UIView *roundView;
@property (nonatomic, retain) UILabel *todyLabel;
@property (nonatomic, retain) UILabel *stepCountLabel;
@property (nonatomic, retain) UILabel *targetLabel;

@end


@implementation StepCountView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.roundView = [[UIView alloc]initWithFrame:CGRectMake(70, 10, SCREEN_WIDTH - 140, SCREEN_WIDTH - 140)];
        _roundView.layer.cornerRadius = (SCREEN_WIDTH - 140) / 2;
        _roundView.layer.borderColor = [UIColor colorWithWhite:0.7 alpha:0.4].CGColor;
        _roundView.layer.borderWidth = 1.0f;
        [self addSubview:_roundView];
        
        self.todyLabel = [[UILabel alloc] initWithFrame:CGRectMake((_roundView.width - 80) / 2, 30, 80, 30)];
        _todyLabel.text = @"今日步数";
        _todyLabel.textAlignment = NSTextAlignmentCenter;
        _todyLabel.font = kFONT_SIZE_18;
        _todyLabel.textColor = [UIColor whiteColor];
        [_roundView addSubview:_todyLabel];
        
        self.stepCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (_roundView.height - 80) / 2, _roundView.width, 80)];
        _stepCountLabel.text = @"5555";
        _stepCountLabel.textColor = [UIColor whiteColor];
        _stepCountLabel.textAlignment = NSTextAlignmentCenter;
        _stepCountLabel.font = [UIFont fontWithName:@"GeezaPro-Bold" size:60];
        [_roundView addSubview:_stepCountLabel];
        
        self.targetLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _stepCountLabel.y + _stepCountLabel.height + 5, _roundView.width, 35)];
        _targetLabel.text = @"目标10000";
        _targetLabel.textAlignment = NSTextAlignmentCenter;
        _targetLabel.textColor = [UIColor whiteColor];
        _targetLabel.font = kFONT_SIZE_18;
        [_roundView addSubview:_targetLabel];
    }
    return self;
}


@end
