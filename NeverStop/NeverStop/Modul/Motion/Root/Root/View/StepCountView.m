//
//  StepCountView.m
//  NeverStop
//
//  Created by DYQ on 16/10/21.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "StepCountView.h"
#import "StepManager.h"
#import "StepCountModel.h"
#import "TargetViewController.h"

@interface StepCountView () {
    NSTimer *timer;
}


@property (nonatomic, strong) UIView *roundView;
@property (nonatomic, strong) UILabel *todyLabel;
@property (nonatomic, strong) UILabel *stepCountLabel;
@property (nonatomic, strong) UILabel *targetLabel;
@property (nonatomic, assign) long systemStep;
@property (nonatomic, strong) SQLiteDatabaseManager *sqlManager;
@property (nonatomic, strong) NSString *dateString;

@end


@implementation StepCountView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.sqlManager = [SQLiteDatabaseManager shareManager];
        self.dateString = [NSDate getSystemTimeStringWithFormat:@"yyyy-MM-dd"];
        
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
        _stepCountLabel.textColor = [UIColor whiteColor];
        _stepCountLabel.textAlignment = NSTextAlignmentCenter;
        _stepCountLabel.font = [UIFont fontWithName:@"GeezaPro-Bold" size:60];
        [_roundView addSubview:_stepCountLabel];
        
        self.targetLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _stepCountLabel.y + _stepCountLabel.height + 5, _roundView.width, 35)];
        _targetLabel.textAlignment = NSTextAlignmentCenter;
        _targetLabel.textColor = [UIColor whiteColor];
        _targetLabel.font = kFONT_SIZE_18;
        [_roundView addSubview:_targetLabel];

        
        [[HealthManager shareInstance] getStepCount:[HealthManager predicateForSamplesToday] completionHandler:^(double value, NSError *error) {
            if (error) {
                NSLog(@"error");
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_sqlManager openSQLite];
                    NSString *stepCountFromSQL = [_sqlManager selectStepCountWithDate:_dateString].stepCount;
                    [_sqlManager closeSQLite];
                    if (value > [stepCountFromSQL integerValue]) {
                        self.systemStep = value;
                    } else {
                        self.systemStep = [stepCountFromSQL integerValue];
                    }
                });
            }
        }];
        [[StepManager shareManager] startWithStep];
        timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(getStepNumber) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        
        
    }
    return self;
}


- (void)getStepNumber{
    long step = [StepManager shareManager].step;
    _stepCountLabel.text = [NSString stringWithFormat:@"%ld",step + _systemStep];
    [_sqlManager openSQLite];
    [_sqlManager updateStepCount:_stepCountLabel.text date:_dateString];
    [_sqlManager closeSQLite];
}

- (void)setTarget:(NSString *)target {
    if (_target != target) {
        _target = target;
        _targetLabel.text = target;
    }
}

@end
