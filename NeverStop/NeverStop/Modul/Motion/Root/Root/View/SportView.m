//
//  SportView.m
//  NeverStop
//
//  Created by DYQ on 16/10/21.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "SportView.h"

@interface SportView ()

@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) UILabel *numberLabel;

@end

@implementation SportView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, SCREEN_WIDTH - 200, 30)];
        _distanceLabel.text = @"跑步总里程(公里)";
        _distanceLabel.textColor = [UIColor whiteColor];
        _distanceLabel.font = kFONT_SIZE_18_BOLD;
        _distanceLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_distanceLabel];
        
        self.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _distanceLabel.y + _distanceLabel.height + 20, SCREEN_WIDTH, 120)];
        _numberLabel.text = @"0.00";
        _numberLabel.textColor = [UIColor whiteColor];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        _numberLabel.font = [UIFont fontWithName:@"GeezaPro-Bold" size:120];
        [self addSubview:_numberLabel];
    }
    return self;
}

- (void)setTitleText:(NSString *)titleText {
    if (_titleText != titleText) {
        _titleText = titleText;
        _distanceLabel.text = [NSString stringWithFormat:@"%@总里程(公里)", titleText];
    }
    
}
@end
