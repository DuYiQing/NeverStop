//
//  OthersViewController.m
//  NeverStop
//
//  Created by DYQ on 16/11/1.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "OthersViewController.h"
#import "TargetViewController.h"
#import "AboutViewController.h"

@interface OthersViewController ()
<
UITableViewDataSource,
UITableViewDelegate
>
@property (nonatomic, strong) UITableView *othersTableView;

@end

@implementation OthersViewController

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createOthersTableView];
    
}

- (void)createOthersTableView {
    self.othersTableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    _othersTableView.delegate = self;
    _othersTableView.dataSource = self;
    [self.view addSubview:_othersTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"手机计步";
            break;
        case 1:
            cell.textLabel.text = @"清除缓存";
            break;
        case 2:
            cell.textLabel.text = @"关于NeverStop";
            break;
        default:
            break;
    }
    return cell;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:{
            TargetViewController *targetVC = [[TargetViewController alloc] init];
            [self.navigationController pushViewController:targetVC animated:YES];
        }
            break;
        case 1:{
            NSLog(@"清除缓存");
        }
            break;
        case 2:{
            AboutViewController *aboutVC = [[AboutViewController alloc] init];
            [self.navigationController pushViewController:aboutVC animated:YES];
        }
            break;
            
        default:
            break;
    }
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
