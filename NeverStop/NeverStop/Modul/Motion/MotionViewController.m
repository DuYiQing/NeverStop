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

@interface MotionViewController ()
<
UIScrollViewDelegate
>
@property (nonatomic, retain) UIBlurEffect *blur;
@property (nonatomic, retain) UIVisualEffectView *blurEffectView;
@property (nonatomic, retain) UIButton *modeButton;
@property (nonatomic, retain) UIButton *backButton;
@property (nonatomic, retain) UIButton *runButton;
@property (nonatomic, retain) UIButton *walkButton;
@property (nonatomic, retain) UIButton *rideButton;
@property (nonatomic, retain) SportView *sportView;
@property (nonatomic, retain) StepCountView *stepCountView;
@property (nonatomic, assign) CGFloat contentOffsetX;
@property (nonatomic, retain) UIView *whiteView;

@end

@implementation MotionViewController

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
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
    
}

// 里程.步数页面
- (void)showRootView {
    // 切换步行,跑步,骑行模式的button
    self.modeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _modeButton.frame = CGRectMake(20, 35, 25, 25);
    [_modeButton setImage:[UIImage imageNamed:@"run.png"] forState:UIControlStateNormal];
    [self.view addSubview:_modeButton];
    [_modeButton addTarget:self action:@selector(modeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.whiteView = [[UIView alloc] initWithFrame:CGRectMake(-(SCREEN_HEIGHT - SCREEN_WIDTH) / 2, 420, SCREEN_HEIGHT, (SCREEN_HEIGHT - 450) * 2)];
    _whiteView.layer.cornerRadius = SCREEN_HEIGHT / 2;
    _whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_whiteView];
    
    UIButton *startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    startButton.frame = CGRectMake(150, 60, 50, 50);
    startButton.backgroundColor = [UIColor greenColor];
    [_whiteView addSubview:startButton];
    [startButton addTarget:self action:@selector(startButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *sportButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sportButton.frame = CGRectMake(100, 30, 80, 40);
    [sportButton setTitle:@"运动" forState:UIControlStateNormal];
    [sportButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:sportButton];
    
    UIButton *stepCountButton = [UIButton buttonWithType:UIButtonTypeCustom];
    stepCountButton.frame = CGRectMake(SCREEN_WIDTH - 100 - 80, 30, 80, 40);
    [stepCountButton setTitle:@"计步" forState:UIControlStateNormal];
    [stepCountButton setTitleColor:[UIColor colorWithWhite:0.7 alpha:0.4] forState:UIControlStateNormal];
    [self.view addSubview:stepCountButton];
    
    UIImageView *weatherImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60, 40, 20, 20)];
    weatherImageView.image = [UIImage imageNamed:@"leave.png"];
    [self.view addSubview:weatherImageView];
    
    UILabel *weatherLabel = [[UILabel alloc] initWithFrame:CGRectMake(weatherImageView.frame.origin.x + weatherImageView.bounds.size.width + 5, stepCountButton.frame.origin.y, 20, 40)];
    weatherLabel.text = @"优";
    weatherLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:weatherLabel];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 90, SCREEN_WIDTH, SCREEN_HEIGHT / 3 * 2)];
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = YES;
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 2, scrollView.height);
    [self.view addSubview:scrollView];
    
    self.sportView = [[SportView alloc]initWithFrame:CGRectMake(0, 55, SCREEN_WIDTH, scrollView.height / 3 * 2)];
    [scrollView addSubview:_sportView];
    
    self.stepCountView = [[StepCountView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 25, SCREEN_WIDTH, scrollView.height / 3 * 2)];
    [scrollView addSubview:_stepCountView];
    
}

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

//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    self.contentOffsetX = scrollView.contentOffset.x;
//    
//}

//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
//    if (scrollView.contentOffset.x > _contentOffsetX) {
//        [UIView animateWithDuration:1.5f delay:1.f usingSpringWithDamping:0.3 initialSpringVelocity:10.f options:UIViewAnimationOptionCurveEaseIn animations:^{
//            _sportView.center = CGPointMake(_whiteView.center.x + cosf(), <#CGFloat y#>)
//            
//        } completion:nil];
//    }
//}

- (void)backButtonAction:(UIButton *)button {
    if (button.tag == 1114) {
        [_modeButton setImage:[UIImage imageNamed:@"ride.png"] forState:UIControlStateNormal];
    } else if (button.tag == 1113) {
        [_modeButton setImage:[UIImage imageNamed:@"walk.png"] forState:UIControlStateNormal];
    } else if (button.tag == 1112) {
        [_modeButton setImage:[UIImage imageNamed:@"run.png"] forState:UIControlStateNormal];
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

- (void)startButtonAction {
    StartViewController *startVC = [[StartViewController alloc] init];
    [self.navigationController pushViewController:startVC animated:YES];
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
