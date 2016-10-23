//
//  MatchViewController.m
//  Never Stop
//
//  Created by dllo on 16/10/20.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "MatchViewController.h"
#import "RecommendTableViewCell.h"
#import "Recommend.h"
#import "RouteViewController.h"

@interface MatchViewController ()

<
UIScrollViewDelegate,
UITableViewDelegate,
UITableViewDataSource
>
// 主页面
@property (nonatomic, strong) UIScrollView *scrollView;
// 推荐的页面
@property (nonatomic, strong) UIScrollView *RSV;
@property (nonatomic, strong) UISegmentedControl *segment;
// 推荐按钮的判断
@property (nonatomic, assign) BOOL REB;
@property (nonatomic, strong) UIButton *recommendButton;
// 附近按钮的判断
@property (nonatomic, assign) BOOL NEB;
@property (nonatomic, strong) UIButton *nearbyButton;
// 推荐的cell数量的数组
@property (nonatomic, strong) NSMutableArray *reArray;
// 推荐的tableView
@property (nonatomic, strong) UITableView *reTV;
@end

@implementation MatchViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self createScrollView];
    [self recommendScrollView];
    [self button];
    self.REB = YES;
    self.NEB = NO;
    [self recommendTableView];
    [self recommendJX];
    self.reArray = [NSMutableArray array];
    
    NSArray *array = [NSArray arrayWithObjects:@"骑行",@"跑步", nil];
    
    self.segment = [[UISegmentedControl alloc]initWithItems:array];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.titleView = _segment;//设置navigation上的titleview
    
    _segment.frame = CGRectMake(0, 0, 160, 35);

    // 设置默认和颜色
    _segment.selectedSegmentIndex = 0;
    _segment.tintColor = [UIColor colorWithRed:37/255.f green:54/255.f blue:74/255.f alpha:1.0];
    
    [_segment addTarget:self action:@selector(segmentedAction:)forControlEvents:UIControlEventValueChanged];
   
}

- (void)createScrollView {
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _scrollView.scrollsToTop = NO;
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 2, SCREEN_HEIGHT - 106);
    _scrollView.directionalLockEnabled = YES;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.backgroundColor = [UIColor grayColor];
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];

}
// 互动关联
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_scrollView.contentOffset.x == SCREEN_WIDTH) {
        _segment.selectedSegmentIndex = 1;
    
    } else _segment.selectedSegmentIndex = 0;
    
    if (_RSV.contentOffset.x == SCREEN_WIDTH) {
        _REB = YES;
        [_nearbyButton setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
        _nearbyButton.backgroundColor = [UIColor colorWithRed:37/255.f green:54/255.f blue:74/255.f alpha:1.0];
        
        _recommendButton.backgroundColor = [UIColor whiteColor];
        [_recommendButton setTitleColor:[UIColor colorWithRed:37/255.f green:54/255.f blue:74/255.f alpha:1.0]forState:UIControlStateNormal];
    } else {
    
        _REB = NO;
        [_recommendButton setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
        _recommendButton.backgroundColor = [UIColor colorWithRed:37/255.f green:54/255.f blue:74/255.f alpha:1.0];
        
        _nearbyButton.backgroundColor = [UIColor whiteColor];
        [_nearbyButton setTitleColor:[UIColor colorWithRed:37/255.f green:54/255.f blue:74/255.f alpha:1.0]forState:UIControlStateNormal];
        
    }
    
    
}

- (void)segmentedAction:(NSInteger)index {
    if (_segment.selectedSegmentIndex == 0) {
        _scrollView.contentOffset = CGPointMake(0, 0);
    } else  if (_segment.selectedSegmentIndex == 1){
        _scrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
    }
}

// 推荐
- (void)recommendScrollView {

    self.RSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 128 - 44)];
    _RSV.scrollsToTop = NO;
    _RSV.contentSize = CGSizeMake(SCREEN_WIDTH * 2, 0);
//    _RSV.directionalLockEnabled = YES;
    _RSV.pagingEnabled = YES;
//    _RSV.bounces = NO;
    _RSV.backgroundColor = [UIColor yellowColor];
    _RSV.delegate = self;
    [_scrollView addSubview:_RSV];
    _RSV.showsHorizontalScrollIndicator = YES;

    UIImageView *i2 = [[UIImageView alloc] init];
    i2.image = [UIImage imageNamed:@"7.jpg"];
    i2.frame = CGRectMake(SCREEN_WIDTH, 0, _RSV.bounds.size.width, _RSV.bounds.size.height);
    [_RSV addSubview:i2];

}
// 推荐,附近button
- (void)button {
    self.recommendButton = [[UIButton alloc] init];
    _recommendButton.frame = CGRectMake(0, 0, self.view.frame.size.width / 2, 64);
    [_recommendButton setTitle:@"推荐" forState:UIControlStateNormal];
    _recommendButton.backgroundColor = [UIColor colorWithRed:37/255.f green:54/255.f blue:74/255.f alpha:1.0];
    [_recommendButton setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [_recommendButton addTarget:self action:@selector(recommendButtonAction)
          forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_recommendButton];
    
    self.nearbyButton = [[UIButton alloc] init];
    _nearbyButton.frame = CGRectMake(self.view.frame.size.width / 2, 0, self.view.frame.size.width / 2, 64);
    [_nearbyButton setTitle:@"附近" forState:UIControlStateNormal];
    _nearbyButton.backgroundColor = [UIColor whiteColor];
    [_nearbyButton setTitleColor:[UIColor colorWithRed:37/255.f green:54/255.f blue:74/255.f alpha:1.0]forState:UIControlStateNormal];

    [_nearbyButton addTarget:self action:@selector(nearbyButtonAction)
              forControlEvents:UIControlEventTouchUpInside];

    [_scrollView addSubview:_nearbyButton];

}

// 推荐button的点击方法
- (void)recommendButtonAction {
    
    if (_REB == YES) {
     _REB = NO;
        [_recommendButton setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
        _recommendButton.backgroundColor = [UIColor colorWithRed:37/255.f green:54/255.f blue:74/255.f alpha:1.0];
        
        _nearbyButton.backgroundColor = [UIColor whiteColor];
        [_nearbyButton setTitleColor:[UIColor colorWithRed:37/255.f green:54/255.f blue:74/255.f alpha:1.0]forState:UIControlStateNormal];
       
    } else {
         _REB = YES;
        _recommendButton.backgroundColor = [UIColor whiteColor];
        [_recommendButton setTitleColor:[UIColor colorWithRed:37/255.f green:54/255.f blue:74/255.f alpha:1.0]forState:UIControlStateNormal];

    }

        _RSV.contentOffset = CGPointMake(0, 0);

}
// 附近button的点击方法
- (void)nearbyButtonAction {
    _REB = NO;
    if (_REB == NO) {
        
        _REB = YES;
        [_nearbyButton setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
        _nearbyButton.backgroundColor = [UIColor colorWithRed:37/255.f green:54/255.f blue:74/255.f alpha:1.0];
        
        _recommendButton.backgroundColor = [UIColor whiteColor];
        [_recommendButton setTitleColor:[UIColor colorWithRed:37/255.f green:54/255.f blue:74/255.f alpha:1.0]forState:UIControlStateNormal];
        
    } else {
        _REB = NO;
        _nearbyButton.backgroundColor = [UIColor whiteColor];
        [_nearbyButton setTitleColor:[UIColor colorWithRed:37/255.f green:54/255.f blue:74/255.f alpha:1.0]forState:UIControlStateNormal];
        
    }

    _RSV.contentOffset = CGPointMake(SCREEN_WIDTH, 0);

}



 //推荐的tableView
- (void)recommendTableView {
    self.reTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _RSV.height) style:UITableViewStylePlain];
    _reTV.backgroundColor = [UIColor whiteColor];
    _reTV.rowHeight = 155.f;
    _reTV.delegate = self;
    _reTV.dataSource = self;
    [_RSV addSubview:_reTV];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _reArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    RecommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[RecommendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.backgroundColor = [UIColor lightGrayColor];
    Recommend *recommendModel = _reArray[indexPath.row];
    cell.recommend = recommendModel;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    RouteViewController *RVC = [[RouteViewController alloc] init];
    [self.navigationController pushViewController:RVC animated:YES];
}


- (void) recommendJX {
    
    NSString *recommendJx = @"http://www.imxingzhe.com/api/v4/collection_list/?lat=38.88268844181218&limit=20&lng=121.5394275381143&page=0&province_id=0&type=0&xingzhe_timestamp=1476843880.032672";
    
[HttpClient GET:recommendJx body:nil headerFile:nil response:JYX_JSON success:^(id result) {
    
    NSDictionary *Dic = result;
    NSArray *reArray = [Dic objectForKey:@"lushu_collection"];
    for (NSDictionary *reDic in reArray) {
        Recommend *reModel = [Recommend modelWithDic:reDic];
        [_reArray addObject : reModel];
    }
    [_reTV reloadData];
    
} failure:^(NSError *error) {
    NSLog(@"error");
}];


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
