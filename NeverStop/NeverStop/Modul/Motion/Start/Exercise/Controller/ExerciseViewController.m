//
//  ExerciseViewController.m
//  NeverStop
//
//  Created by Jiang on 16/10/24.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "ExerciseViewController.h"
#import "ExerciseDataView.h"
#import "GlideView.h"
#import "CustomAnimateTransitionPush.h"
#import "MapViewController.h"
#import "CustomAnimateTransitionPop.h"
#import "Location.h"
#import "MapDataManager.h"
#import "ExerciseData.h"

@interface ExerciseViewController ()
<
UINavigationControllerDelegate,
MAMapViewDelegate
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
@property (nonatomic, assign) BOOL isLock;
@property (nonatomic, assign) BOOL isMoving;
@property (nonatomic, retain) UIButton *mapButton;
@property (nonatomic, retain) Location *location;


@property (nonatomic, retain) MAMapView *mapView;
@property (nonatomic, retain) Location *lastLocation;
@property (nonatomic, assign) double allDistance;
@property (nonatomic, retain) UILabel *distanceLabel;
@property (nonatomic, retain) NSString *allDistanceStr;
//@property (nonatomic, retain) MyKVO *myKVO;
@property (nonatomic, retain) MAPolyline *commonPolyline;

@property (nonatomic, retain) MapDataManager *mapManager;
@property (nonatomic, retain) ExerciseData *exerciseDataKVO;
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, assign) NSInteger a;
@property (nonatomic, retain) NSArray *keyPathArray;
@property (nonatomic, retain) NSMutableArray *locationArray;

@end

@implementation ExerciseViewController
- (void)dealloc {
    self.navigationController.delegate = nil;
//    [self.exerciseDataKVO removeObserver:self forKeyPath:@"distance" context:nil];
//    [self.exerciseDataKVO removeObserver:self forKeyPath:@"duration" context:nil];
//    [self.exerciseDataKVO removeObserver:self forKeyPath:@"speedPerHour" context:nil];
//    [self.exerciseDataKVO removeObserver:self forKeyPath:@"averageSpeed" context:nil];
    for (int i = 0; i < _keyPathArray.count; i++) {
        [self.exerciseDataKVO removeObserver:self forKeyPath:_keyPathArray[i] context:nil];
    }
    


}
- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.delegate = self;
    [_mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES];

}
- (void)initialValue {
    self.isMoving = YES;
    _a = 0;
    self.keyPathArray = @[@"distance", @"duration", @"speedPerHour", @"averageSpeed", @"maxSpeed", @"calorie"];
    self.lastLocation = [[Location alloc] init];
    self.locationArray = [NSMutableArray array];
    self.mapManager = [MapDataManager defaultManager];
    self.exerciseDataKVO = [[ExerciseData alloc] init];
    _exerciseDataKVO.distance = 0.00;
    _exerciseDataKVO.duration = 0;
    _exerciseDataKVO.speedPerHour = 0.00;
    _exerciseDataKVO.averageSpeed = 0.00;
    _exerciseDataKVO.maxSpeed = 0.00;
    _exerciseDataKVO.calorie = 0.0;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   //    [self.exerciseDataKVO addObserver:self forKeyPath:@"exerciseData" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld  context:nil];
//    [self.exerciseDataKVO addObserver:self forKeyPath:@"TIMETIME" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld  context:nil];
//    [self.exerciseDataKVO addObserver:self forKeyPath:@"TIMETIME" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld  context:nil];
//    [self.exerciseDataKVO addObserver:self forKeyPath:@"TIMETIME" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld  context:nil];
    for (int i = 0; i < _keyPathArray.count; i++) {
        [self.exerciseDataKVO addObserver:self forKeyPath:_keyPathArray[i] options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld  context:nil];
    }
    [self creatMapView];
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
        // 结束计时
        [self endTimer];
        [_mapManager.allLocationArray removeAllObjects];
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
                // 暂停计时
                [self pauseTimer];
                _pauseButton.centerX = SCREEN_WIDTH / 2 - 70;
                _endButton.centerX = SCREEN_WIDTH / 2 + 70;
                _pauseButton.selected = !_pauseButton.selected;
                [_pauseButton setBackgroundImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
                
                self.isMoving = NO;
            } else {
                // 开始计时
                [self createTimer];
                _pauseButton.centerX = SCREEN_WIDTH / 2;
                _endButton.centerX = SCREEN_WIDTH / 2;
                _pauseButton.selected = !_pauseButton.selected;
                [_pauseButton setBackgroundImage:[UIImage imageNamed:@"2"] forState:UIControlStateNormal];
                self.isMoving = YES;
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
    [self mapBtnAnimation];
    [self.view addSubview:_mapButton];
    [self createExerciseDataModules];
    [self createLockButton];
    [self createCountDownView];

}
#pragma mark - 创建计时器 开始计时
- (void)createTimer {
    if (_a == 0) {
        
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(timeFire) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    _a++;
}
#pragma mark - 暂停计时
- (void)pauseTimer {
        self.a = 0;
        [_timer setFireDate:[NSDate distantFuture]];
}

-(void)timeFire {
    _exerciseDataKVO.duration++;
}
#pragma mark - 结束计时
- (void)endTimer{
    _a = 0;
    [_timer setFireDate:[NSDate distantFuture]];
}



#pragma mark - 创建地图
- (void)creatMapView {
    self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(-1, -1, 1, 1)];
    [self.view addSubview:_mapView];
    // 开启定位
    _mapView.showsUserLocation = YES;
    
    _mapView.delegate = self;
    
    _mapView.pausesLocationUpdatesAutomatically = NO;
    
    _mapView.allowsBackgroundLocationUpdates = YES;//iOS9以上系统必须配置
    
    // 设置默认模式
    [_mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES];
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    if (updatingLocation) {
        //        NSLog(@"lat: %f, long: %f", userLocation.coordinate.latitude, userLocation.coordinate.longitude);
        // 取出当前位置的坐标
        
        Location *location = [[Location alloc] init];
        location.latitude = userLocation.coordinate.latitude;
        location.longitude = userLocation.coordinate.longitude;
        if (self.isMoving == YES) {
            location.isStart = YES;
        } else {
            location.isStart = NO;
        }
        // 添加到坐标数组中
        [_locationArray addObject:location];
//        [_locationArray addObject:location];
        if (self.isMoving == YES) {
            
            if (_locationArray.count > 1) {
                //1.将两个经纬度点转成投影点
                MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(_lastLocation.latitude,_lastLocation.longitude));
                MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(location.latitude,location.longitude));
                //2.计算距离
                NSLog(@"last : %f, %f", _lastLocation.latitude, _lastLocation.longitude);
                NSLog(@"now : %f, %f", location.latitude, location.longitude);
                CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
                NSLog(@"distance : %f", distance);
                _exerciseDataKVO.speedPerHour = distance / 1000 / ((8 / 60 ) / 60);
                
//                _exerciseDataKVO.distance += distance / 1000;
                _exerciseDataKVO.distance += round(distance / 1000 * 100) / 100;
                _exerciseDataKVO.maxSpeed = _exerciseDataKVO.maxSpeed > _exerciseDataKVO.speedPerHour ? _exerciseDataKVO.maxSpeed : _exerciseDataKVO.speedPerHour;
                _exerciseDataKVO.averageSpeed = _exerciseDataKVO.distance / _exerciseDataKVO.duration;
            }
         
            _lastLocation.latitude = location.latitude;
            _lastLocation.longitude = location.longitude;
        }

      
        
    }
    
    
    
    
    
}
#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"duration"] && object == self.exerciseDataKVO) {
        
        NSString *time = [change valueForKey:@"new"];
        
        NSInteger sec;
        NSInteger minu;
        NSInteger hour;
        sec = [time integerValue] % 60;
        minu = ([time integerValue] / 60)% 60;
        hour = [time integerValue] / 3600;
        
        self.homeDataView.dataLabel.text = [NSString stringWithFormat:@"%.2ld:%.2ld:%.2ld", hour, minu, sec];
        
    } else if ([keyPath isEqualToString:@"distance"] && object == self.exerciseDataKVO) {
         self.leftDataView.dataLabel.text = [NSString stringWithFormat:@"%@", [change valueForKey:@"new"]];
    } else if ([keyPath isEqualToString:@"speedPerHour"] && object == self.exerciseDataKVO) {
        self.leftDataView.dataLabel.text = [NSString stringWithFormat:@"%@", [change valueForKey:@"new"]];
    } else if ([keyPath isEqualToString:@"averageSpeed"] && object == self.exerciseDataKVO) {
       
    } else if ([keyPath isEqualToString:@"maxSpeed"] && object == self.exerciseDataKVO) {
       
    } else if ([keyPath isEqualToString:@"calorie"] && object == self.exerciseDataKVO) {
       
    }




   
}







#pragma mark - 右上地图button旋转动画
- (void)mapBtnAnimation{
    CABasicAnimation *rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    rotationAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    rotationAnimation.toValue = [ NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI, 0.0, 0.0, 1.0) ];
    rotationAnimation.duration = 1.0;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = MAXFLOAT;
    [self.mapButton.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
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
    _leftDataView.titleLabel.text = @"距离 (公里)";
    _leftDataView.dataLabel.font = kFONT_SIZE_24_BOLD;
    _leftDataView.dataLabel.text = @"01:22:17";
    [self.dataModulesView addSubview:_leftDataView];
    
    
    self.rightDataView = [[ExerciseDataView alloc] initWithFrame:CGRectMake(_dataModulesView.width / 2, _dataModulesView.height - 60, _dataModulesView.width / 2, _leftDataView.height)];
    _rightDataView.titleLabel.font = kFONT_SIZE_18_BOLD;
    _rightDataView.titleLabel.text = @"时速 (公里时)";
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
        self.isLock = YES;
        [weakSelf.view bringSubviewToFront:_lockButton];
        [weakSelf.view bringSubviewToFront:_dataModulesView];
    }];
    [self.view addSubview:_lockButton];
}
#pragma mark - 创建锁屏视图
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
        _glideView.userInteractionEnabled = NO;

    }];

}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
     if (self.isLock == YES) {
    //保存触摸起始点位置
    CGPoint point = [[touches anyObject] locationInView:self.view];
    self.startPoint = point;
    [self.view bringSubviewToFront:_lockView];
    _isOffMark = NO;
     }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
     if (self.isLock == YES) {
  
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
        _lockButton.center = CGPointMake(_glideView.center.x, _glideView.center.y - 70);

        if (_dy < -30) {
            [UIView animateWithDuration:0.5 animations:^{
                _glideView.center = self.glideCenter;
                _lockButton.center = CGPointMake(_lockButton.centerX, _glideView.y - 20);
                _isOffMark = YES;
            }];
        }
    }
     }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    if (self.isLock == YES) {

    
     if (self.dy > 80) {
        [UIView animateWithDuration:0.5 animations:^{
            _glideView.center = CGPointMake(_glideCenter.x, SCREEN_HEIGHT + _glideView.height);
            _lockButton.center = CGPointMake(_lockButton.centerX, SCREEN_HEIGHT - 44 + 16);
            _lockButton.userInteractionEnabled = YES;
            _dataModulesView.userInteractionEnabled = YES;
        } completion:^(BOOL finished) {
            [_lockButton setBackgroundImage:[UIImage imageNamed:@"unlock"] forState:UIControlStateNormal];
            self.isLock = NO;
            [_glideView.superview removeFromSuperview];
            
        }];
     } else {
         [UIView animateWithDuration:0.5 animations:^{
             _glideView.center = _glideCenter;
             _lockButton.center = CGPointMake(_lockButton.centerX, _glideView.y - 20);
     
         }];
     }

    }
}
#pragma mark - 倒计时
- (void)startTime {
    __block int timeout = 3; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer1 = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer1,dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer1, ^{
        if(timeout <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer1);
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
                        [self createTimer];

                    }];
                    
                }];
//                [UIView beginAnimations:nil context:nil];
//                [UIView setAnimationDuration:1];
//                [UIView commitAnimations];
             
            });
            timeout--;
        }
        
    });
    dispatch_resume(_timer1);
    
}
#pragma mark - 用来自定义转场动画
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
