//
//  FriendsViewController.m
//  NeverStop
//
//  Created by DYQ on 16/11/9.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "FriendsViewController.h"
#import "MessageTableViewCell.h"

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
    }
    cell.userName = _userlist[indexPath.row];
    return cell;
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
