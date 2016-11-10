//
//  MessageTableViewCell.m
//  NeverStop
//
//  Created by DYQ on 16/11/8.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "MessageTableViewCell.h"
#import "RequestModel.h"

@interface MessageTableViewCell ()

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *messageLabel;


@end

@implementation MessageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 50, 50)];
        _headImageView.image = [UIImage imageNamed:@"userHeader"];
        [self.contentView addSubview:_headImageView];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_headImageView.x + _headImageView.width + 20, _headImageView.y , 350, 25)];
        _nameLabel.font = kFONT_SIZE_18;
        [self.contentView addSubview:_nameLabel];
        
        self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.x, _nameLabel.y + _nameLabel.height, SCREEN_WIDTH - 100, 30)];
        _messageLabel.textColor = [UIColor grayColor];
        _messageLabel.font = kFONT_SIZE_15;
        [self.contentView addSubview:_messageLabel];
        
        
    }
    return self;
}

- (void)setRequestModel:(RequestModel *)requestModel {
    if (_requestModel != requestModel) {
        _requestModel = requestModel;
        _nameLabel.text = requestModel.aUsername;
        _messageLabel.text = requestModel.aMessage;
    }
}

- (void)setUserName:(NSString *)userName {
    if (_userName != userName) {
        _userName = userName;
        _nameLabel.text = userName;
    }
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
