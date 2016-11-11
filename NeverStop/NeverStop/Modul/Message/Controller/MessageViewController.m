//
//  MessageViewController.m
//  Never Stop
//
//  Created by dllo on 16/10/20.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "MessageViewController.h"
#import "RequestModel.h"
#import "MessageTableViewCell.h"
#import "FriendsViewController.h"
#import "ConversationModel.h"
#import "HeaderView.h"
#import "ChatViewController.h"

@interface MessageViewController ()

<
UISearchBarDelegate,
UISearchControllerDelegate,
UITableViewDelegate,
UITableViewDataSource,
EMContactManagerDelegate,
EMChatManagerDelegate
>
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *searchTabelView;
@property (nonatomic, strong) NSMutableArray *requestArray;
@property (nonatomic, strong) NSMutableArray *messageArray;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) NSArray *userlist;



@end

@implementation MessageViewController

- (void)dealloc {
    // 移除好友回调
    [[EMClient sharedClient].contactManager removeDelegate:self];
    
    // 移除消息回调
    [[EMClient sharedClient].chatManager removeDelegate:self];

}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
    [_searchTabelView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.requestArray = [NSMutableArray array];
    self.messageArray = [NSMutableArray array];
    

    [self createTableView];
    
    
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    [self.view addSubview:searchView];
    
    // 搜索框
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    _searchBar.barTintColor = [UIColor whiteColor];
    _searchBar.showsCancelButton = YES;
    _searchBar.delegate = self;
    
    [[[_searchBar.subviews objectAtIndex:0].subviews objectAtIndex:1] setBackgroundColor:[UIColor colorWithRed:0.8619 green:0.8619 blue:0.8619 alpha:1.0]];
    _searchBar.placeholder = @"搜索用户";
    [searchView addSubview:_searchBar];
    
    
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"好友列表" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemAction:)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    
    [self createTipLabel];
    
    [self getAllConversation];
    
    //注册好友回调
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
    
    // 注册消息回调
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    
}

// 获取消息列表
- (void)getAllConversation {
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    for (EMConversation *conversation in conversations) {
        
        ConversationModel *conversationModel = [[ConversationModel alloc] init];
        conversationModel.userName = conversation.conversationId;
        EMTextMessageBody *body = (EMTextMessageBody *)conversation.latestMessage.body;
        if (body.type == EMMessageBodyTypeText) {
            conversationModel.text = body.text;
        }
        NSString *dateString = [NSDate intervalSinceNow:conversation.latestMessage.localTime];
        conversationModel.time = dateString;
        conversationModel.unreadNum = [NSString stringWithFormat:@"%d", conversation.unreadMessagesCount];
        if (![dateString isEqualToString:@""]) {
            [_messageArray addObject:conversationModel];
        }
        [_searchTabelView reloadData];
    }
}

/*!
 @method
 @brief 接收到一条及以上非cmd消息
 */
- (void)didReceiveMessages:(NSArray *)aMessages {
    [_messageArray removeAllObjects];
    [self getAllConversation];
}



/*!
 *  用户A发送加用户B为好友的申请，用户B会收到这个回调
 *
 *  @param aUsername   用户名
 *  @param aMessage    附属信息
 */
- (void)didReceiveFriendInvitationFromUsername:(NSString *)aUsername message:(NSString *)aMessage {
    
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
    if (_requestArray.count > 0) {
        for (NSString *string in _requestArray) {
            if ([string isEqualToString:aUsername]) {
                return;
            }
        }
    }
    
    NSDictionary *dic = @{@"aUsername" : [NSString stringWithFormat:@"%@", aUsername], @"aMessage" : [NSString stringWithFormat:@"%@", aMessage]};
    RequestModel *requestModel = [RequestModel modelWithDic:dic];
    [_requestArray insertObject:requestModel atIndex:0];
    [_searchTabelView insertRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationRight];
    [_searchTabelView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    
    
}

/*!
 @method
 @brief 用户A发送加用户B为好友的申请，用户B同意后，用户A会收到这个回调
 */
- (void)didReceiveAgreedFromUsername:(NSString *)aUsername {
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@已同意你的请求", aUsername] message:nil preferredStyle:UIAlertControllerStyleAlert];
    //创建一个确定按钮
    UIAlertAction *actionCancle=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    //将确定按钮添加进弹框控制器
    [alert addAction:actionCancle];
    //显示弹框控制器
    [self presentViewController:alert animated:YES completion:nil];
    [_searchTabelView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}


/**
 用户A发送加用户B为好友的申请，用户B拒绝后，用户A会收到这个回调

 @param aUsername 用户B
 */
- (void)didReceiveDeclinedFromUsername:(NSString *)aUsername {
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@拒绝了您的好友请求", aUsername] message:nil preferredStyle:UIAlertControllerStyleAlert];
    //创建一个确定按钮
    UIAlertAction *actionCancle=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    //将确定按钮添加进弹框控制器
    [alert addAction:actionCancle];
    //显示弹框控制器
    [self presentViewController:alert animated:YES completion:nil];
    [_searchTabelView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];

}

- (void)createTipLabel {
    self.tipLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 200) / 2, SCREEN_HEIGHT / 2, 200, 45)];
    _tipLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    _tipLabel.font = kFONT_SIZE_15;
    _tipLabel.textColor = [UIColor whiteColor];
    _tipLabel.textAlignment = NSTextAlignmentCenter;
    _tipLabel.layer.cornerRadius = 5.f;
    _tipLabel.clipsToBounds = YES;
    _tipLabel.hidden = YES;
    [self.view addSubview:_tipLabel];
}

// 好友列表
- (void)rightBarButtonItemAction:(UIBarButtonItem *)rightBarButtonItem {
    
    FriendsViewController *friendsVC = [[FriendsViewController alloc] init];
    friendsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:friendsVC animated:YES];
    
    
}

// 创建tableView
- (void)createTableView {
    
    self.searchTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    _searchTabelView.delegate = self;
    _searchTabelView.dataSource = self;
    _searchTabelView.rowHeight = 70.f;
    _searchTabelView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
    [self.view addSubview:_searchTabelView];
    
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (nil == cell) {
        cell = [[MessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if (0 == indexPath.section) {
        RequestModel *requestModel = _requestArray[indexPath.row];
        cell.requestModel = requestModel;
    }
    if (1 == indexPath.section) {
        ConversationModel *conversationModel = _messageArray[indexPath.row];
        cell.conversationModel = conversationModel;
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (0 == section) {
        return _requestArray.count;
    }
    return _messageArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 24.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HeaderView *headerView = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 24)];
    if (0 == section) {
        headerView.title = @"好友请求";
    } else {
        headerView.title = @"聊天列表";
    }
    return headerView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        RequestModel *requestModel = _requestArray[indexPath.row];
        
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@请求加您为好友", requestModel.aUsername] message:nil preferredStyle:UIAlertControllerStyleAlert];
        // 创建一个同意和一个拒绝按钮
        UIAlertAction *agreeAction=[UIAlertAction actionWithTitle:@"同意" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            EMError *error = [[EMClient sharedClient].contactManager acceptInvitationForUsername:requestModel.aUsername];
            if (!error) {
                DDLogInfo(@"发送同意成功");
                [_requestArray removeObjectAtIndex:indexPath.row];
                [_searchTabelView reloadData];
            }
        }];
        UIAlertAction *disagreeAction=[UIAlertAction actionWithTitle:@"拒绝" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            EMError *error = [[EMClient sharedClient].contactManager declineInvitationForUsername:requestModel.aUsername];
            if (!error) {
                DDLogInfo(@"发送拒绝成功");
                [_requestArray removeObjectAtIndex:indexPath.row];
                [_searchTabelView reloadData];
                
            }
        }];
        //将同意和拒绝按钮添加进弹框控制器
        [alert addAction:agreeAction];
        [alert addAction:disagreeAction];
        //显示弹框控制器
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    if (1 == indexPath.section) {
        
        ConversationModel *conversationModel = _messageArray[indexPath.row];
        
        ChatViewController *chatVC = [[ChatViewController alloc] initWithConversationChatter:conversationModel.userName conversationType:EMConversationTypeChat];
        [self.navigationController pushViewController:chatVC animated:YES];
        
        
    }

}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    EMError *error = nil;
    self.userlist = [[EMClient sharedClient].contactManager getContactsFromServerWithError:&error];
    if (!error) {
        for (NSString *userName in _userlist) {
            if ([[searchBar.text lowercaseString] isEqualToString:userName]) {
                UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"该用户已是您的好友!" message:nil preferredStyle:UIAlertControllerStyleAlert];
                //创建一个确定按钮
                UIAlertAction *actionCancle=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                //将确定按钮添加进弹框控制器
                [alert addAction:actionCancle];
                //显示弹框控制器
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
        if ([searchBar.text lowercaseString] == [[EMClient sharedClient] currentUsername]) {
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"不能添加自己为好友!" message:nil preferredStyle:UIAlertControllerStyleAlert];
            //创建一个确定按钮
            UIAlertAction *actionCancle=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            //将确定按钮添加进弹框控制器
            [alert addAction:actionCancle];
            //显示弹框控制器
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"确定添加%@为好友?", [_searchBar.text lowercaseString]] message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alert addTextFieldWithConfigurationHandler:^(UITextField *textField){
                textField.placeholder = @"说点什么";
            }];
            //创建一个取消和一个确定按钮
            UIAlertAction *actionCancle=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            //因为需要点击确定按钮后改变文字的值，所以需要在确定按钮这个block里面进行相应的操作
            UIAlertAction *actionOk=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                
                [_searchBar resignFirstResponder];
                UITextField *textField = alert.textFields.firstObject;
                EMError *error = [[EMClient sharedClient].contactManager addContact:[_searchBar.text lowercaseString] message:[NSString stringWithFormat:@"%@", textField.text]];
                if (!error) {
                    _tipLabel.hidden = NO;
                    _tipLabel.alpha = 1;
                    _tipLabel.text = @"添加好友请求已发送";
                    [UIView animateWithDuration:1 delay:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        _tipLabel.alpha = 0;
                    } completion:^(BOOL finished) {
                        _tipLabel.hidden = YES;
                    }];
                } else {
                    DDLogError(@"%@", error);
                }
            }];
            //将取消和确定按钮添加进弹框控制器
            [alert addAction:actionCancle];
            [alert addAction:actionOk];
            //显示弹框控制器
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
