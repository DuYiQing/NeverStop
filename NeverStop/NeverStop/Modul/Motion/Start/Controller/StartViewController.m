//
//  StartViewController.m
//  NeverStop
//
//  Created by Jiang on 16/10/21.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "StartViewController.h"
#import "JiangPickerView.h"
#import "AimSettingPickerView.h"

@interface StartViewController ()
<
MAMapViewDelegate,
AMapSearchDelegate,
AimSettingPickerViewDelegate
>
@property (nonatomic, retain) MAMapView *mapView;
@property (nonatomic, retain) UIButton *startButton;
@property (nonatomic, retain) UIButton *settingButton;
@property (nonatomic, retain) AMapSearchAPI *mapSearchAPI;
@property (nonatomic, retain) JiangPickerView *aimPickerView;


@end

@implementation StartViewController
- (void)viewWillAppear:(BOOL)animated {
    [self.mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
    self.navigationController.navigationBarHidden = NO;
  
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //自定义一个NaVigationBar
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //消除阴影
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [self creatMapView];
    
    // 设定目标按钮
    self.settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_settingButton setTitle:@"设定单次目标" forState:UIControlStateNormal];
    [_settingButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _settingButton.backgroundColor = [UIColor clearColor];
    CGFloat width = [_settingButton.titleLabel.text widthWithFont:_settingButton.titleLabel.font constrainedToHeight:50];
    _settingButton.frame = CGRectMake(SCREEN_WIDTH / 2 - width / 2, _mapView.y + _mapView.height, width, 50);
    [_settingButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        AimSettingPickerView *aimSettingPicker = [[AimSettingPickerView alloc]init];
        [aimSettingPicker setDelegate:self];
        [aimSettingPicker setContentMode:STPickerContentModeBottom];
        [aimSettingPicker show];
        
    }];
    [self.view addSubview:_settingButton];
    
    
    
    // 缩放 开始按钮
    
    self.startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _startButton.frame = CGRectMake(SCREEN_WIDTH / 2 - 40, SCREEN_HEIGHT - 240, 80, 80);
    UIImage *startImage = [UIImage imageNamed:@"1"];
    startImage = [startImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [_startButton setBackgroundImage:startImage forState:UIControlStateNormal];
//    [_startButton setBackgroundImage:startImage forState:UIControlStateHighlighted];
  [_startButton setBackgroundImage:startImage forState:UIControlStateHighlighted];
    _startButton.backgroundColor = [UIColor greenColor];
    
    
 
    
    [_startButton addTarget:self action:@selector(pressedEvent:) forControlEvents:UIControlEventTouchDown];
    [_startButton addTarget:self action:@selector(cancelEvent:) forControlEvents:UIControlEventTouchDragOutside];
    [_startButton addTarget:self action:@selector(unpressedEvent:) forControlEvents:UIControlEventTouchUpInside];
    _startButton.layer.cornerRadius = 40;
    _startButton.clipsToBounds = YES;
    [self.view addSubview:_startButton];

    
    
    
    
    
}

- (void)aimSettingPicker:(AimSettingPickerView *)aimSettingPicker setting:(NSString *)setting viewForRow:(NSInteger)row forComponent:(NSInteger)component {
    [_settingButton setTitle:setting forState:UIControlStateNormal];
    CGFloat width = [_settingButton.titleLabel.text widthWithFont:_settingButton.titleLabel.font constrainedToHeight:50];
    _settingButton.frame = CGRectMake(SCREEN_WIDTH / 2 - width / 2, _mapView.y + _mapView.height + 100, width, 50);
}







//按钮的压下事件 按钮缩小
- (void)pressedEvent:(UIButton *)btn
{
    //缩放比例必须大于0，且小于等于1
    
    [UIView animateWithDuration:0.25 animations:^{
        btn.transform = CGAffineTransformMakeScale(0.75, 0.75);
    }];
    
    
}
//点击手势拖出按钮frame区域松开，响应取消
- (void)cancelEvent:(UIButton *)btn
{
    [UIView animateWithDuration:0.25 animations:^{
        btn.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        
    }];
}
//按钮的松开事件 按钮复原 执行响应
- (void)unpressedEvent:(UIButton *)btn
{
    [UIView animateWithDuration:0.25 animations:^{
        btn.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        //执行动作响应
       
    }];
}


- (void)creatMapView {
    self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300)];
    [self.view addSubview:_mapView];
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
    // 关闭自动暂停
    _mapView.pausesLocationUpdatesAutomatically = NO;
    // 允许后台定位 iOS9以上系统必须配置
    _mapView.allowsBackgroundLocationUpdates = YES;
    // Do any additional setup after loading the view.
    // 默认模式
    
    [_mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES];
    // 比例尺
    _mapView.showsScale = NO;
    // 罗盘
    _mapView.showsCompass = NO;
    // 缩放级别
    [_mapView setZoomLevel:16.5 animated:YES];
    
    // 楼块
    _mapView.showsBuildings = NO;
    
    //    _mapView.logoCenter = CGPointMake(SCREEN_WIDTH - 55, 450);
    // 交互
    _mapView.userInteractionEnabled = NO;
    // 允许自定义精度圈
    _mapView.customizeUserLocationAccuracyCircleRepresentation = YES;
    // 中心位置
    [_mapView setCenterCoordinate:_mapView.userLocation.coordinate animated:YES];
}
//- (MAAnnotationView*)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation;
//{
//    if ([annotation isKindOfClass:[MAPointAnnotation class]])
//    {
//        MAPinAnnotationView *annotationView = nil;
//        if (annotationView == nil)
//        {
//            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
//        }
//        annotationView.pinColor = MAPinAnnotationColorGreen;
//        
//        //annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
//        annotationView.animatesDrop = NO;        //设置标注动画显示，默认为NO
//        annotationView.draggable = NO;        //设置标注可以拖动，默认为NO
//        return annotationView;
//    }
//    return nil;
//}
// 自定义精度圈样式
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay {
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:(MAPolyline *)overlay];
        polylineRenderer.lineWidth = 10.f;
        polylineRenderer.strokeColor = [UIColor colorWithRed:0.1786 green:0.9982 blue:0.8065 alpha:1.0];
        // 连接类型
        polylineRenderer.lineJoinType = kMALineJoinRound;
        // 端点类型
        polylineRenderer.lineCapType = kMALineCapRound;
    
        return polylineRenderer;
    }
    return nil;
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
