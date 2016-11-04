//
//  HistoryTableViewCell.m
//  NeverStop
//
//  Created by DYQ on 16/11/1.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "HistoryTableViewCell.h"

@interface HistoryTableViewCell ()

@property (nonatomic, strong) UIImageView *typeImageView;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *kmLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation HistoryTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.typeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 20, 50, 50)];
        _typeImageView.backgroundColor = [UIColor orangeColor];
        _typeImageView.layer.cornerRadius = _typeImageView.width / 2;
        [self.contentView addSubview:_typeImageView];
        
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _typeImageView.y + _typeImageView.height, 90, 30)];
        _dateLabel.text = @"30日晚上";
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        _dateLabel.font = kFONT_SIZE_15;
        _dateLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_dateLabel];
        
        self.kmLabel = [[UILabel alloc] initWithFrame:CGRectMake(_typeImageView.x + _typeImageView.width + 30, 25, 100, 50)];
        _kmLabel.text = @"29.25";
        _kmLabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:37];
        [_kmLabel sizeToFit];
        [self.contentView addSubview:_kmLabel];
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(_kmLabel.x + _kmLabel.width + 10, _kmLabel.y + _kmLabel.height - 30, 50, 30)];
        textLabel.text = @"公里";
        textLabel.font = kFONT_SIZE_18_BOLD;
        [self.contentView addSubview:textLabel];
        
        UIImageView *timeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 3 * 2 + 30, 35, 20, 20)];
        timeImageView.image = [UIImage imageNamed:@"time"];
        [self.contentView addSubview:timeImageView];
        
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(timeImageView.x + timeImageView.width + 5, timeImageView.y, 120, timeImageView.height)];
        _timeLabel.text = @"25:35:59";
        _timeLabel.textColor = [UIColor grayColor];
        _timeLabel.font = kFONT_SIZE_13;
        [self.contentView addSubview:_timeLabel];
        
    }
    return self;
}




- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
