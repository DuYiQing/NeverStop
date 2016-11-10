//
//  HeaderView.m
//  NeverStop
//
//  Created by DYQ on 16/11/10.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "HeaderView.h"

@interface HeaderView ()

@property (nonatomic, strong) UILabel *headerTitle;

@end

@implementation HeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.headerTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 24)];
        _headerTitle.textColor = [UIColor lightGrayColor];
        _headerTitle.font = kFONT_SIZE_13;
        _headerTitle.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_headerTitle];
        
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _headerTitle.y + _headerTitle.height, SCREEN_WIDTH, 1)];
        lineLabel.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:lineLabel];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    if (_title != title) {
        _title = title;
        _headerTitle.text = title;
    }
}

@end
