//
//  RouteTableViewCell.m
//  NeverStop
//
//  Created by dllo on 16/10/21.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "RouteTableViewCell.h"

@implementation RouteTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_titleLabel];
        self.commentLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_commentLabel];
    }
    return self;
}



- (void)setRoute:(Route *)route {
    if (_route != route) {
        _route = route;
    }
    self.titleLabel.text = route.title;
    self.commentLabel.text = [NSString stringWithFormat:@"%@",route.comment_num];

}


- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(0, 0, 100, 20);
    self.commentLabel.frame = CGRectMake(0, 25, 100, 20);

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
