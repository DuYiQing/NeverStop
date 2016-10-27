//
//  MotionViewController.m
//  Never Stop
//
//  Created by dllo on 16/10/20.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "MotionViewController.h"
#import "SportView.h"
#import "StepCountView.h"
#import "StartViewController.h"
#import "WeekRecordView.h"

@interface MotionViewController ()
<
UIScrollViewDelegate
>
@property (nonatomic, strong) UIBlurEffect *blur;
@property (nonatomic, strong) UIVisualEffectView *blurEffectView;
@property (nonatomic, strong) UIButton *modeButton;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *runButton;
@property (nonatomic, strong) UIButton *walkButton;
@property (nonatomic, strong) UIButton *rideButton;
@property (nonatomic, strong) SportView *sportView;
@property (nonatomic, strong) StepCountView *stepCountView;
@property (nonatomic, assign) CGFloat contentOffsetX;
@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, strong) UIButton *stepCountButton;
@property (nonatomic, strong) UIButton *sportButton;
@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) WeekRecordView *weekRecordView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) SQLiteDatabaseManager *SQLManager;


@end

@implementation MotionViewController

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = NO;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:37/255.f green:54/255.f blue:74/255.f alpha:1.0];
    // 定义毛玻璃效果
    self.blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.blurEffectView = [[UIVisualEffectView alloc] initWithEffect:_blur];
    _blurEffectView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    [self showRootView];
    
    self.SQLManager = [SQLiteDatabaseManager shareManager];
    [_SQLManager openSQLite];
    [_SQLManager createTable];
    
    FTPopOverMenuConfiguration *configuration = [FTPopOverMenuConfiguration defaultConfiguration];
//    configuration.menuRowHeight = 80;
    configuration.menuWidth = 270;
    configuration.textColor = [UIColor colorWithRed:37/255.f green:54/255.f blue:74/255.f alpha:1.0];
    configuration.textFont = [UIFont boldSystemFontOfSize:14];
    configuration.tintColor = [UIColor colorWithWhite:1.0 alpha:0.7];
//    configuration.borderColor = [UIColor blackColor];
//    configuration.borderWidth = 0.5;

    
}

// 里程.步数页面
- (void)showRootView {
    // 切换步行,跑步,骑行模式的button
    self.modeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _modeButton.frame = CGRectMake(20, 35, 25, 25);
    [_modeButton setImage:[UIImage imageNamed:@"run.png"] forState:UIControlStateNormal];
    [self.view addSubview:_modeButton];
    [_modeButton addTarget:self action:@selector(modeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    // 白色View
    self.whiteView = [[UIView alloc] initWithFrame:CGRectMake(-(SCREEN_HEIGHT - SCREEN_WIDTH) / 2, 420, SCREEN_HEIGHT, (SCREEN_HEIGHT - 450) * 2)];
    _whiteView.layer.cornerRadius = SCREEN_HEIGHT / 2;
    _whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_whiteView];
    
    // 开始按钮
    self.startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _startButton.frame = CGRectMake((_whiteView.width - 100) / 2, 60, 100, 100);
    _startButton.layer.cornerRadius = 50;
    [_startButton setTitle:@"开始" forState:UIControlStateNormal];
    [_startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _startButton.backgroundColor = [UIColor colorWithRed:37/255.f green:54/255.f blue:74/255.f alpha:1.0];
    [_whiteView addSubview:_startButton];
    [_startButton addTarget:self action:@selector(startButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    // 一周步行记录表
    self.weekRecordView = [[WeekRecordView alloc] initWithFrame:CGRectMake((_whiteView.width - SCREEN_WIDTH) / 2, 0, SCREEN_WIDTH, _whiteView.height)];
    _weekRecordView.hidden = YES;
    _weekRecordView.count = 30;
    _weekRecordView.backgroundColor = [UIColor clearColor];
    [_whiteView addSubview:_weekRecordView];
    
    
    
    self.sportButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sportButton.frame = CGRectMake(100, 30, 80, 40);
    [_sportButton setTitle:@"运动" forState:UIControlStateNormal];
    [_sportButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:_sportButton];
    [_sportButton addTarget:self action:@selector(sportButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.stepCountButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _stepCountButton.frame = CGRectMake(SCREEN_WIDTH - 100 - 80, 30, 80, 40);
    [_stepCountButton setTitle:@"计步" forState:UIControlStateNormal];
    [_stepCountButton setTitleColor:[UIColor colorWithWhite:0.7 alpha:0.4] forState:UIControlStateNormal];
    [self.view addSubview:_stepCountButton];
    [_stepCountButton addTarget:self action:@selector(stepButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *weatherImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60, 40, 20, 20)];
    weatherImageView.image = [UIImage imageNamed:@"leave.png"];
    [self.view addSubview:weatherImageView];
    
    // 天气
    UIButton *weatherButton = [UIButton buttonWithType:UIButtonTypeCustom];
    weatherButton.frame = CGRectMake(weatherImageView.frame.origin.x + weatherImageView.bounds.size.width - 5, _stepCountButton.frame.origin.y, 40, 40);
    [weatherButton setTitle:@"优" forState:UIControlStateNormal];
    [weatherButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:weatherButton];
    [weatherButton addTarget:self action:@selector(weatherButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 90, SCREEN_WIDTH, SCREEN_HEIGHT / 2)];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = YES;
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 2, _scrollView.height);
    [self.view addSubview:_scrollView];
    
    self.sportView = [[SportView alloc]initWithFrame:CGRectMake(0, 55, SCREEN_WIDTH, _scrollView.height / 3 * 2)];
    [_scrollView addSubview:_sportView];
    
    self.stepCountView = [[StepCountView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 25, SCREEN_WIDTH, _scrollView.height / 3 * 2)];
    [_scrollView addSubview:_stepCountView];
    
}
#pragma mark - 切换步行,跑步,骑行模式
- (void)modeButtonAction {
    [self.view addSubview:_blurEffectView];
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backButton.frame = CGRectMake(20, 35, 20, 20);
    _backButton.tag = 1111;
    [_backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [_blurEffectView addSubview:_backButton];
    [_backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.runButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _runButton.frame = CGRectMake(_backButton.x, _backButton.y + _backButton.height + 20, 30, 30);
    _runButton.tag = 1112;
    [_runButton setImage:[UIImage imageNamed:@"run.png"] forState:UIControlStateNormal];
    [_blurEffectView addSubview:_runButton];
    [_runButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.walkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _walkButton.frame = CGRectMake(_runButton.x, _runButton.y + _runButton.height + 20, _runButton.width, _runButton.height);
    _walkButton.tag = 1113;
    [_walkButton setImage:[UIImage imageNamed:@"walk.png"] forState:UIControlStateNormal];
    [_blurEffectView addSubview:_walkButton];
    [_walkButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.rideButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rideButton.frame = CGRectMake(_walkButton.x, _walkButton.y + _walkButton.height + 20, _walkButton.width, _walkButton.height);
    _rideButton.tag = 1114;
    [_rideButton setImage:[UIImage imageNamed:@"ride.png"] forState:UIControlStateNormal];
    [_blurEffectView addSubview:_rideButton];
    [_rideButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)backButtonAction:(UIButton *)button {
    if (button.tag == 1114) {
        [_modeButton setImage:[UIImage imageNamed:@"ride.png"] forState:UIControlStateNormal];
        _sportView.titleText = @"骑行";
    } else if (button.tag == 1113) {
        [_modeButton setImage:[UIImage imageNamed:@"walk.png"] forState:UIControlStateNormal];
        _sportView.titleText = @"走路";
    } else if (button.tag == 1112) {
        [_modeButton setImage:[UIImage imageNamed:@"run.png"] forState:UIControlStateNormal];
        _sportView.titleText = @"跑步";
    }
    [UIView animateWithDuration:0.2 animations:^{
        _runButton.frame = _backButton.frame;
        _walkButton.frame = _backButton.frame;
        _rideButton.frame = _backButton.frame;
        
    } completion:^(BOOL finished) {
        [_blurEffectView removeFromSuperview];
        [_backButton removeFromSuperview];
        [_walkButton removeFromSuperview];
        [_runButton removeFromSuperview];
        [_rideButton removeFromSuperview];
    }];
}


#pragma mark - 切换运动和计步

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    CGFloat lenth = scrollView.contentOffset.x / 180;
    CGAffineTransform trans = CGAffineTransformRotate(_startButton.transform, -lenth * 35/ 180.0 * M_PI);
    _sportView.transform = CGAffineTransformIdentity;
    _sportView.transform = trans;
    
    
    CGFloat lenth2 = (scrollView.contentOffset.x - SCREEN_WIDTH) / 180;
    CGAffineTransform trans2 = CGAffineTransformRotate(_startButton.transform, -lenth2 * 35/ 180.0 * M_PI);
    _stepCountView.transform = CGAffineTransformIdentity;
    _stepCountView.transform = trans2;

    
    CGFloat scale = SCREEN_WIDTH / _startButton.width;
    if (scrollView.contentOffset.x >= 0 && scrollView.contentOffset.x <= SCREEN_WIDTH) {
        _startButton.width = 100 - scrollView.contentOffset.x / scale;
        _startButton.height = _startButton.width;
        _startButton.x = (_whiteView.width - _startButton.width) / 2;
        _startButton.layer.cornerRadius = _startButton.width / 2;
    }
    if (scrollView.contentOffset.x > SCREEN_WIDTH / 2) {
        [_stepCountButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sportButton setTitleColor:[UIColor colorWithWhite:0.7 alpha:0.4] forState:UIControlStateNormal];
        _modeButton.hidden = YES;
        [UIView animateWithDuration:0.2f animations:^{
            _startButton.backgroundColor = [UIColor whiteColor];
        }];
        if (scrollView.contentOffset.x == SCREEN_WIDTH) {
            _startButton.hidden = YES;
            _weekRecordView.hidden = NO;
        }
    } else if (scrollView.contentOffset.x < SCREEN_WIDTH / 2) {
        [_sportButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_stepCountButton setTitleColor:[UIColor colorWithWhite:0.7 alpha:0.4] forState:UIControlStateNormal];
        _modeButton.hidden = NO;
        [UIView animateWithDuration:0.5f animations:^{
            _startButton.backgroundColor = [UIColor colorWithRed:37/255.f green:54/255.f blue:74/255.f alpha:1.0];
        } completion:^(BOOL finished) {
            _startButton.hidden = NO;
            _weekRecordView.hidden = YES;
        }];

    }
}
- (void)sportButtonAction {
    [UIView animateWithDuration:0.5f animations:^{
        [_sportButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_stepCountButton setTitleColor:[UIColor colorWithWhite:0.7 alpha:0.4] forState:UIControlStateNormal];
        _scrollView.contentOffset = CGPointMake(0, 0);
    }];

}
- (void)stepButtonAction {
    [UIView animateWithDuration:0.5f animations:^{
        [_stepCountButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sportButton setTitleColor:[UIColor colorWithWhite:0.7 alpha:0.4] forState:UIControlStateNormal];
        _scrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
        
    }];
    
    
}
#pragma mark - 开始按钮点击事件
- (void)startButtonAction {
    StartViewController *startVC = [[StartViewController alloc] init];
    [self setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:startVC animated:YES];
}
#pragma mark - 点击天气按钮显示
- (void)weatherButtonAction:(UIButton *)button {
    [FTPopOverMenu showForSender:button withMenu:@[@"aaaaaa"] doneBlock:^(NSInteger selectedIndex) {
        NSLog(@"done");
    } dismissBlock:^{
        NSLog(@"dismiss");
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
