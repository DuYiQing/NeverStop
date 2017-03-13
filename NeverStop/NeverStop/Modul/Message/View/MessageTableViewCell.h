//
//  MessageTableViewCell.h
//  NeverStop
//
//  Created by DYQ on 16/11/8.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RequestModel;
@class ConversationModel;

@interface MessageTableViewCell : UITableViewCell

@property (nonatomic, strong) RequestModel *requestModel;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) ConversationModel *conversationModel;


@end
