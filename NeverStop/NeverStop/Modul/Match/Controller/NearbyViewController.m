//
//  NearbyViewController.m
//  NeverStop
//
//  Created by dllo on 16/10/25.
//  Copyright © 2016年 JDT. All rights reserved.
//

<<<<<<< HEAD:NeverStop/NeverStop/Modul/Motion/Start/ExerciseViewController.m
#import "ExerciseViewController.h"
#import "ExerciseDataView.h"
#import "GlideView.h"
#import "CustomAnimateTransitionPush.h"
#import "MapViewController.h"
#import "CustomAnimateTransitionPop.h"

@interface ExerciseViewController ()
<
UINavigationControllerDelegate
>
@property (nonatomic, retain) UIButton *pauseButton;
@property (nonatomic, retain) UIView *countDownView;
@property (nonatomic, retain) UILabel *countDownLabel;
@property (nonatomic, retain) UIView *dataModulesView;
@property (nonatomic, retain) ExerciseDataView *homeDataView;
@property (nonatomic, retain) ExerciseDataView *leftDataView;
@property (nonatomic, retain) ExerciseDataView *rightDataView;
@property (nonatomic, retain) UIButton *lockButton;
@property (nonatomic, retain) UIView *lockView;
@property (nonatomic, retain) GlideView *glideView;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint glideCenter;
@property (nonatomic, assign) CGFloat dy;
@property (nonatomic, assign) BOOL isOffMark;
@property (nonatomic, retain) UIButton *mapButton;
@end

@implementation ExerciseViewController
- (void)dealloc {
    self.navigationController.delegate = nil;
}
- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.delegate = self;
}
=======
#import "NearbyViewController.h"

@interface NearbyViewController ()

@end

@implementation NearbyViewController
>>>>>>> 8365c7a728c184ba6ca5741dcfda43e76df300ef:NeverStop/NeverStop/Modul/Match/Controller/NearbyViewController.m

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
<<<<<<< HEAD:NeverStop/NeverStop/Modul/Motion/Start/ExerciseViewController.m
#pragma mark - 结束按钮
    self.view.backgroundColor = [UIColor cyanColor];
    self.endButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _endButton.frame = CGRectMake(SCREEN_WIDTH / 2 - 40, SCREEN_HEIGHT - 240, 80, 80);
    UIImage *endImage = [UIImage imageNamed:@"2"];
    [_endButton setBackgroundImage:endImage forState:UIControlStateNormal];
    _endButton.backgroundColor = [UIColor redColor];
    _endButton.layer.cornerRadius = 40;
    _endButton.clipsToBounds = YES;
    [self.view addSubview:_endButton];
    __weak typeof(self) weakSelf = self;
    [_endButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
        
    }];
#pragma mark - 开始暂停按钮
    self.pauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _pauseButton.frame = CGRectMake(SCREEN_WIDTH / 2 - 40, SCREEN_HEIGHT - 240, 80, 80);
    UIImage *pauseImage = [UIImage imageNamed:@"2"];
    [_pauseButton setBackgroundImage:pauseImage forState:UIControlStateNormal];
    
    _pauseButton.backgroundColor = [UIColor greenColor];
    _pauseButton.layer.cornerRadius = 40;
    _pauseButton.clipsToBounds = YES;
    
    [self.view addSubview:_pauseButton];
    
    [_pauseButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [UIView animateWithDuration:0.5 animations:^{
            if (!_pauseButton.selected) {
                _pauseButton.centerX = SCREEN_WIDTH / 2 - 70;
                _endButton.centerX = SCREEN_WIDTH / 2 + 70;
                _pauseButton.selected = !_pauseButton.selected;
                [_pauseButton setBackgroundImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
            } else {
                _pauseButton.centerX = SCREEN_WIDTH / 2;
                _endButton.centerX = SCREEN_WIDTH / 2;
                _pauseButton.selected = !_pauseButton.selected;
                [_pauseButton setBackgroundImage:[UIImage imageNamed:@"2"] forState:UIControlStateNormal];
                
            }
        }];
        
        
    }];
#pragma mark - 地图按钮
    self.mapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_mapButton setBackgroundImage:[UIImage imageNamed:@"map1"] forState:UIControlStateNormal];
    _mapButton.frame = CGRectMake(SCREEN_WIDTH - 50, 32, 30, 30);
    [_mapButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        MapViewController *mapVC = [[MapViewController alloc] init];
        [self.navigationController pushViewController:mapVC animated:YES];
        
    }];
    [self.view addSubview:_mapButton];
    [self createExerciseDataModules];
    [self createLockButton];
    [self createCountDownView];

}
#pragma mark - 创建倒计时视图
- (void)createCountDownView {
    self.countDownView = [[UIView alloc] initWithFrame:self.view.bounds];
    _countDownView.backgroundColor = [UIColor colorWithRed:37/255.f green:54/255.f blue:74/255.f alpha:1.0];
    [self.view addSubview:_countDownView];
    self.countDownLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 100, SCREEN_HEIGHT / 2 - 200, 200, 200)];
    _countDownLabel.backgroundColor = [UIColor clearColor];
    _countDownLabel.layer.cornerRadius = _countDownLabel.width / 2;
    _countDownLabel.clipsToBounds = YES;
    _countDownLabel.textAlignment = NSTextAlignmentCenter;
    _countDownLabel.textColor = [UIColor whiteColor];
    _countDownLabel.font = [UIFont boldSystemFontOfSize:150];
    [_countDownView addSubview:_countDownLabel];
    [self startTime];
    
}
#pragma mark - 运动数据模块
- (void)createExerciseDataModules {
    self.dataModulesView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT / 5, SCREEN_WIDTH, 210)];
//    _dataModulesView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_dataModulesView];
    
    self.homeDataView = [[ExerciseDataView alloc] initWithFrame:CGRectMake(0, 0, self.dataModulesView.width, 130)];
    _homeDataView.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    _homeDataView.titleLabel.text = @"时长";
    _homeDataView.dataLabel.font = [UIFont systemFontOfSize:80];
    _homeDataView.dataLabel.text = @"01:22:17";
//    _homeDataView.backgroundColor = [UIColor greenColor];
    [self.dataModulesView addSubview:_homeDataView];
    
    
    self.leftDataView = [[ExerciseDataView alloc] initWithFrame:CGRectMake(0, _dataModulesView.height - 60, SCREEN_WIDTH / 2, 60)];
    _leftDataView.titleLabel.font = kFONT_SIZE_18_BOLD;
    _leftDataView.titleLabel.text = @"时长";
    _leftDataView.dataLabel.font = kFONT_SIZE_24_BOLD;
    _leftDataView.dataLabel.text = @"01:22:17";
    [self.dataModulesView addSubview:_leftDataView];
    
    
    self.rightDataView = [[ExerciseDataView alloc] initWithFrame:CGRectMake(_dataModulesView.width / 2, _dataModulesView.height - 60, _dataModulesView.width / 2, _leftDataView.height)];
    _rightDataView.titleLabel.font = kFONT_SIZE_18_BOLD;
    _rightDataView.titleLabel.text = @"时长";
    _rightDataView.dataLabel.font = kFONT_SIZE_24_BOLD;
    _rightDataView.dataLabel.text = @"01:22:17";
    [self.dataModulesView addSubview:_rightDataView];
   
    
}
#pragma mark - 创建锁屏
- (void)createLockButton {
    self.lockButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _lockButton.frame = CGRectMake(SCREEN_WIDTH / 2 - 16, SCREEN_HEIGHT - 44, 32, 32);
    [_lockButton setBackgroundImage:[UIImage imageNamed:@"unlock"] forState:UIControlStateNormal];
    __weak typeof(self) weakSelf = self;

    [_lockButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [weakSelf createLockView];
        [weakSelf.view bringSubviewToFront:_lockButton];
        [weakSelf.view bringSubviewToFront:_dataModulesView];
    }];
    [self.view addSubview:_lockButton];
}
- (void)createLockView {
    self.glideView = [[GlideView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 40, SCREEN_HEIGHT - 200, 80, 100)];
    self.glideCenter = CGPointMake(_glideView.centerX, _glideView.centerY);

    UIBlurEffect * blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView * effe = [[UIVisualEffectView alloc]initWithEffect:blur];
    effe.frame = self.view.bounds;
    // 把要添加的视图加到毛玻璃上
    [self.view sendSubviewToBack:effe];
    [self.view addSubview:effe];
    [UIView animateWithDuration:0.7 animations:^{
        [_lockButton setBackgroundImage:[UIImage imageNamed:@"lock"] forState:UIControlStateNormal];
        _lockButton.userInteractionEnabled = NO;
        _dataModulesView.userInteractionEnabled = NO;
        _lockButton.center = CGPointMake(_lockButton.centerX, _glideView.y - 20);
    } completion:^(BOOL finished) {
        
        [effe sendSubviewToBack:_glideView];
        [effe addSubview:_glideView];
        
    }];

}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //保存触摸起始点位置
    CGPoint point = [[touches anyObject] locationInView:self.view];
    self.startPoint = point;
    [self.view bringSubviewToFront:_lockView];
    _isOffMark = NO;
    //该view置于最前
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
  
    //计算位移 = 当前位置 - 起始位置
    CGPoint point = [[touches anyObject] locationInView:self.view];
    
    self.dy = point.y - self.startPoint.y;
    //计算移动后的view中心点
    CGPoint newcenter = CGPointMake(self.glideCenter.x, _glideCenter.y + _dy);
    
    
    
//    float halfx = CGRectGetMidX(_glideView.bounds);
//    //x坐标左边界
//    newcenter.x = MAX(halfx, newcenter.x);
//    //x坐标右边界
//    newcenter.x = MIN(_glideView.superview.bounds.size.width - halfx, newcenter.x);
//
//    float halfy = CGRectGetMidY(_glideView.bounds);
//    newcenter.y = MAX(halfy, newcenter.y);
//    newcenter.y = MIN(_glideView.superview.bounds.size.height - halfy, newcenter.y);

    if (_isOffMark == NO) {
        
        _glideView.center = newcenter;
        if (_dy < -30) {
            [UIView animateWithDuration:0.5 animations:^{
                _glideView.center = self.glideCenter;
                _isOffMark = YES;
            }];
        }
    }
    
    //移动view
    
//    NSLog(@"%f", _dy);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {


    
     if (self.dy > 80) {
        [UIView animateWithDuration:0.5 animations:^{
            _glideView.center = CGPointMake(_glideCenter.x, SCREEN_HEIGHT + _glideView.height);
            _lockButton.center = CGPointMake(_lockButton.centerX, SCREEN_HEIGHT - 44 + 16);
            _lockButton.userInteractionEnabled = YES;
            _dataModulesView.userInteractionEnabled = YES;
        } completion:^(BOOL finished) {
            [_lockButton setBackgroundImage:[UIImage imageNamed:@"unlock"] forState:UIControlStateNormal];
            
            [_glideView.superview removeFromSuperview];
            
        }];
     } else {
         [UIView animateWithDuration:0.5 animations:^{
             _glideView.center = _glideCenter;
         }];
     }
}
#pragma mark - 倒计时
- (void)startTime {
    __block int timeout = 3; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.countDownView removeFromSuperview];
                
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                _countDownLabel.text = strTime;
                
                [UIView animateWithDuration:0.5 animations:^{
//                    _countDownLabel.font = [UIFont boldSystemFontOfSize:180];
                    _countDownLabel.backgroundColor = [UIColor colorWithRed:0.9919 green:0.9832 blue:1.0 alpha:0.02];

                    _countDownLabel.transform = CGAffineTransformMakeScale(1.35, 1.35);
                    _countDownLabel.textColor = [UIColor whiteColor];


                } completion:^(BOOL finished) {
                    _countDownLabel.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.0];
                    [UIView animateWithDuration:0.5 animations:^{
                        _countDownLabel.transform = CGAffineTransformMakeScale(1.0, 1.0);
//                        _countDownLabel.font = [UIFont boldSystemFontOfSize:150];
                        _countDownLabel.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.1];

                    }];
                    
                }];
//                [UIView beginAnimations:nil context:nil];
//                [UIView setAnimationDuration:1];
//                [UIView commitAnimations];
             
            });
            timeout--;
        }
        
    });
    dispatch_resume(_timer);
    
=======
    self.view.backgroundColor = [UIColor orangeColor];
>>>>>>> 8365c7a728c184ba6ca5741dcfda43e76df300ef:NeverStop/NeverStop/Modul/Match/Controller/NearbyViewController.m
}
//用来自定义转场动画
-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    
    if(operation==UINavigationControllerOperationPush)
    {
        CustomAnimateTransitionPush *animateTransitionPush=[CustomAnimateTransitionPush new];
        animateTransitionPush.contentMode = JiangContentModeToMap;
        animateTransitionPush.button = self.mapButton;
        return animateTransitionPush;
    }
    else
    {
//        CustomAnimateTransitionPop *pingInvert = [CustomAnimateTransitionPop new];
//        pingInvert.contentMode = JiangContentModeBackToStart;
//        pingInvert.button = self.endButton;
//        return pingInvert;
        return nil;
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
