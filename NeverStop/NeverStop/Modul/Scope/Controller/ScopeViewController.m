//
//  ScopeViewController.m
//  Never Stop
//
//  Created by dllo on 16/10/20.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "ScopeViewController.h"
#import "Scope.h"
#import "ScopeTableViewCell.h"
#import "GroupViewController.h"
@interface ScopeViewController ()
<
UITableViewDataSource,
UITableViewDelegate
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *scopeArray;
@end

@implementation ScopeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self ScopeTableView];
    self.scopeArray = [NSMutableArray array];
    [self ScopeJX];
//    self.view.backgroundColor = [UIColor whiteColor];
//     self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:37/255.f green:54/255.f blue:74/255.f alpha:1.0];
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    
}

- (void)ScopeTableView {
    self.tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.rowHeight = 100.f;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ScopeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[ScopeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    //cell.backgroundColor = [UIColor colorWithRed:37/255.f green:54/255.f blue:74/255.f alpha:1.0];
    cell.backgroundColor = [UIColor blackColor];
    Scope *scopeModel = _scopeArray[indexPath.row];
    cell.scopeModel = scopeModel;
    return cell;
}





- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _scopeArray.count;
}




- (void)ScopeJX {
NSString *string = @"http://api.dongdong17.com/dongdong/ios/api/v8/group_list?account_id=63375925";
    [HttpClient GET:string body:nil headerFile:@{@"Authorization" : @"Pacer kLNGVWvEuOwlHtC%2FYUh7c8PoeWA%3D"} response:JYX_JSON success:^(id result) {
        NSArray *array = [result objectForKey:@"recommends"];
        
        for (NSDictionary *dic in array) {
            Scope *scopeModel = [Scope mj_objectWithKeyValues:dic];
            [_scopeArray addObject:scopeModel];
        }
        [_tableView reloadData];
    } failure:^(NSError *error) {
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GroupViewController *GVC = [[GroupViewController alloc] init];
    [self.navigationController pushViewController:GVC animated:YES];
    
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
