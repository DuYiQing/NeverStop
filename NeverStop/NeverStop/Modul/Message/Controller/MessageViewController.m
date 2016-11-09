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

@interface MessageViewController ()

<
UISearchBarDelegate,
UISearchControllerDelegate,
UITableViewDelegate,
UITableViewDataSource,
EMContactManagerDelegate
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
    //移除好友回调
    [[EMClient sharedClient].contactManager removeDelegate:self];

}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
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
    
    
    //注册好友回调
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
    
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

- (void)createTableView {
    
    self.searchTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    _searchTabelView.delegate = self;
    _searchTabelView.dataSource = self;
    _searchTabelView.rowHeight = 70.f;
    [self.view addSubview:_searchTabelView];
    
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (nil == cell) {
        cell = [[MessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    RequestModel *requestModel = _requestArray[indexPath.row];
    cell.requestModel = requestModel;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _requestArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    EMError *error = nil;
    self.userlist = [[EMClient sharedClient].contactManager getContactsFromServerWithError:&error];
    if (!error) {
        for (NSString *userName in _userlist) {
            if ([searchBar.text lowercaseString] == userName) {
                UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"该用户已是您的好友!" message:nil preferredStyle:UIAlertControllerStyleAlert];
                //创建一个确定按钮
                UIAlertAction *actionCancle=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                //将确定按钮添加进弹框控制器
                [alert addAction:actionCancle];
                //显示弹框控制器
                [self presentViewController:alert animated:YES completion:nil];
                [_searchTabelView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];

            } else if ([searchBar.text lowercaseString] == [[EMClient sharedClient] currentUsername]) {
                UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"不能添加自己为好友!" message:nil preferredStyle:UIAlertControllerStyleAlert];
                //创建一个确定按钮
                UIAlertAction *actionCancle=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                //将确定按钮添加进弹框控制器
                [alert addAction:actionCancle];
                //显示弹框控制器
                [self presentViewController:alert animated:YES completion:nil];
                [_searchTabelView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];

            } else {
                UIAlertController *alert=[UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"确定添加%@为好友?", [_searchBar.text lowercaseString]] message:nil preferredStyle:UIAlertControllerStyleAlert];
                [alert addTextFieldWithConfigurationHandler:^(UITextField *textField){
                    textField.placeholder = @"说点什么";
                }];
                //创建一个取消和一个确定按钮
                UIAlertAction *actionCancle=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                //因为需要点击确定按钮后改变文字的值，所以需要在确定按钮这个block里面进行相应的操作
                UIAlertAction *actionOk=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    
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
