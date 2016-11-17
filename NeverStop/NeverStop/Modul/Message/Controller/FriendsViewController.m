//
//  FriendsViewController.m
//  NeverStop
//
//  Created by DYQ on 16/11/9.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "FriendsViewController.h"
#import "MessageTableViewCell.h"
#import "ChatViewController.h"

@interface FriendsViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) UITableView *friendsTableView;
@property (nonatomic, strong) NSArray *userlist;

@end

@implementation FriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];
    
//    [self createFriendsTableView];
    
    
    EMError *error = nil;
    self.userlist = [[EMClient sharedClient].contactManager getContactsFromServerWithError:&error];
    if (!error) {
        [self createFriendsTableView];
    } else {
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"出错啦!" message:nil preferredStyle:UIAlertControllerStyleAlert];
        //创建一个确定按钮
        UIAlertAction *actionCancle=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        //将确定按钮添加进弹框控制器
        [alert addAction:actionCancle];
        //显示弹框控制器
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)createFriendsTableView {
    self.friendsTableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    _friendsTableView.delegate = self;
    _friendsTableView.dataSource = self;
    _friendsTableView.rowHeight = 70;
    [self.view addSubview:_friendsTableView];
}
// 删除好友
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除好友" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您确定要删除该好友吗" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            NSString *userName = _userlist[indexPath.row];
            // 删除好友
            EMError *error = [[EMClient sharedClient].contactManager deleteContact:userName];
            if (!error) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"删除成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    
                    [(NSMutableArray *)_userlist removeObjectAtIndex:indexPath.row];
                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                }];
                [alert addAction:okAction];
                [self presentViewController:alert animated:YES completion:nil];
            } else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"删除失败" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *getAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDestructive handler:nil];
                [alert addAction:getAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
                [_friendsTableView reloadData];
        }];
        [alert addAction:sure];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }];
    return @[deleteAction];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _userlist.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (nil == cell) {
        cell = [[MessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    cell.userName = _userlist[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *userName = _userlist[indexPath.row];

    ChatViewController *chatVC = [[ChatViewController alloc] initWithConversationChatter:userName conversationType:EMConversationTypeChat];
    [self.navigationController pushViewController:chatVC animated:YES];
    
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
