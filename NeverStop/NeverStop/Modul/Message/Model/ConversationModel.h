//
//  ConversationModel.h
//  NeverStop
//
//  Created by DYQ on 16/11/10.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "DYQBaseModel.h"

@interface ConversationModel : DYQBaseModel

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *unreadNum;

@end
