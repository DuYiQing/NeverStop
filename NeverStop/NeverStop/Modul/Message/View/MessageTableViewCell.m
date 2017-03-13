//
//  MessageTableViewCell.m
//  NeverStop
//
//  Created by DYQ on 16/11/8.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "MessageTableViewCell.h"
#import "RequestModel.h"
#import "ConversationModel.h"

@interface MessageTableViewCell ()

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UILabel *timeLabel;

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
        
        self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.x, _nameLabel.y + _nameLabel.height, SCREEN_WIDTH - 150, 30)];
        _messageLabel.textColor = [UIColor grayColor];
        _messageLabel.font = kFONT_SIZE_15;
        [self.contentView addSubview:_messageLabel];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 20, 90, 30)];
        _timeLabel.textColor = [UIColor lightGrayColor];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.font = kFONT_SIZE_12;
        [self.contentView addSubview:_timeLabel];
        
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

- (void)setConversationModel:(ConversationModel *)conversationModel {
    if (_conversationModel != conversationModel) {
        _conversationModel = conversationModel;
        _headImageView.image = [UIImage imageNamed:@"conversation"];
        _nameLabel.text = conversationModel.userName;
        _messageLabel.text = conversationModel.text;
        _timeLabel.text = conversationModel.time;
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
