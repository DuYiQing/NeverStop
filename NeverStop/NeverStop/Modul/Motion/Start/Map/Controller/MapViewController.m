//
//  MapViewController.m
//  NeverStop
//
//  Created by Jiang on 16/10/26.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "MapViewController.h"
#import "CustomAnimateTransitionPop.h"
#import "MapDataManager.h"
#import "Location.h"
#import "ExerciseDataView.h"
#import "VerticalButton.h"
@interface MapViewController ()
<
UINavigationControllerDelegate,
MAMapViewDelegate
>
@property (nonatomic, retain) UIButton *backButton;
@property (nonatomic, retain) MAMapView *mapView;
@property (nonatomic, retain) MapDataManager *mapManager;
@property (nonatomic, retain) Location *location;
@property (nonatomic, retain) Location *userLocation;
@property (nonatomic, retain) MAPolyline *commonPolyline;
@property (nonatomic, retain) ExerciseDataView *leftDataView;
@property (nonatomic, retain) ExerciseDataView *rightDataView;
@property (nonatomic, retain) UIButton *menuButton;
@end

@implementation MapViewController
- (void)dealloc {
    self.navigationController.delegate = nil;
    [_mapManager removeObserver:self forKeyPath:@"count" context:nil];
}
- (void)viewWillAppear:(BOOL)animated {
       self.navigationController.delegate = self;
}
- (void)loadView {
    [super loadView];
    self.mapManager = [MapDataManager defaultManager];
   

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.location = [[Location alloc] init];
    [self creatMapView];
    
   [_mapManager addObserver:self forKeyPath:@"count" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backButton.frame =  CGRectMake(SCREEN_WIDTH - 50, 32, 30, 30);
    _backButton.layer.cornerRadius = 15;
    _backButton.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
    [_backButton setBackgroundImage:[UIImage imageNamed:@"map_btn_close"] forState:UIControlStateNormal];
    __weak typeof(self) weakSelf = self;
    [_backButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
        
    }];
    [self.view addSubview:_backButton];
    
   
    
    
    
    UIBlurEffect * blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView * effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
    effectView.frame = CGRectMake(0, SCREEN_HEIGHT - 100, SCREEN_WIDTH, 100);
    // 把要添加的视图加到毛玻璃上
    [self.view addSubview:effectView];
    self.leftDataView = [[ExerciseDataView alloc] initWithFrame:CGRectMake(0, effectView.height - 80, effectView.width / 2, 60)];
    _leftDataView.titleLabel.font = kFONT_SIZE_18_BOLD;
    _leftDataView.titleLabel.text = @"距离 (公里)";
    _leftDataView.dataLabel.textColor = [UIColor blackColor];
    _leftDataView.dataLabel.font = kFONT_SIZE_24_BOLD;
    _leftDataView.dataLabel.text = @"01:22:17";
    [effectView addSubview:_leftDataView];
    
    
    self.rightDataView = [[ExerciseDataView alloc] initWithFrame:CGRectMake(_leftDataView.x + _leftDataView.width, effectView.height - 80, effectView.width / 2, _leftDataView.height)];
    _rightDataView.titleLabel.font = kFONT_SIZE_18_BOLD;
    _rightDataView.titleLabel.text = @"时速 (公里时)";
    _rightDataView.dataLabel.textColor = [UIColor blackColor];
    _rightDataView.dataLabel.font = kFONT_SIZE_24_BOLD;
    _rightDataView.dataLabel.text = @"01:22:17";
    [effectView addSubview:_rightDataView];

    
    self.menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _menuButton.frame = CGRectMake(20, effectView.y - 50, 30, 30);
    _menuButton.layer.cornerRadius = 15;
    [_menuButton setBackgroundImage:[UIImage imageNamed:@"map_btn_menu_normal"] forState:UIControlStateNormal];
    _menuButton.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
    [_menuButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [_menuButton setBackgroundImage:[UIImage imageNamed:@"map_btn_menu_select"] forState:UIControlStateNormal];
        [weakSelf mapType];
    }];
    [self.view addSubview:_menuButton];

    
    
    

    
}
- (void)mapType {
    
    UIBlurEffect * blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView * effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
    effectView.frame = CGRectMake(_menuButton.x, _menuButton.y - 160, 250, 140);
    [self.view addSubview:effectView];
    
    VerticalButton *planeButton = [VerticalButton buttonWithType:UIButtonTypeCustom];
    
    [planeButton setImage:[UIImage imageNamed:@"18r.jpg"] forState:UIControlStateNormal];
//
    [planeButton setImage:[UIImage imageNamed:@"18r.jpg"] forState:UIControlStateSelected];
    [planeButton setTitle:@"平面地图" forState:UIControlStateNormal];
    [planeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [planeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    planeButton.titleLabel.font = [UIFont systemFontOfSize:20];
    
    planeButton.backgroundColor = [UIColor whiteColor];
    planeButton.layer.borderWidth = 0.5;
    planeButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [planeButton setTitle:@"平面地图" forState:UIControlStateSelected];
    if (self.mapView.mapType == MAMapTypeStandard) {
        planeButton.selected = YES;
        planeButton.backgroundColor = [UIColor colorWithRed:37/255.f green:54/255.f blue:74/255.f alpha:1.0];
        planeButton.layer.borderColor = [UIColor colorWithRed:37/255.f green:54/255.f blue:74/255.f alpha:1.0].CGColor;
    }
    planeButton.layer.cornerRadius = 4;
    planeButton.clipsToBounds = YES;
    planeButton.frame = CGRectMake(20, 20, 90, 90);
    [effectView addSubview:planeButton];
  
    
    
    
    
//    self.femaleButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    UIImage *femaleImage = [UIImage imageNamed:@"me_sex_nv"];
//    _femaleButton.tintColor = [UIColor colorWithRed:1.0 green:0.4353 blue:0.8118 alpha:1.0];
//    femaleImage = [femaleImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//    [_femaleButton setImage:femaleImage forState:UIControlStateNormal];
//    
//    UIImage *femaleSelectImage = [UIImage imageNamed:@"me_sex_nv"];
//    [_femaleButton setImage:femaleSelectImage forState:UIControlStateSelected];
//    
//    [_femaleButton setTitle:@"女" forState:UIControlStateNormal];
//    [_femaleButton setTitleColor:[UIColor colorWithRed:1.0 green:0.4353 blue:0.8118 alpha:1.0] forState:UIControlStateNormal];
//    [_femaleButton setTitle:@"女" forState:UIControlStateSelected];
//    [_femaleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
//    
//    
//    _femaleButton.titleLabel.font = [UIFont systemFontOfSize:20];
//    _femaleButton.backgroundColor = [UIColor clearColor];
//    _femaleButton.layer.borderWidth = 1;
//    _femaleButton.layer.borderColor = [UIColor colorWithRed:1.0 green:0.4353 blue:0.8118 alpha:1.0].CGColor;
//    _femaleButton.layer.cornerRadius = 10;

    
    
    VerticalButton *satelliteButton = [VerticalButton buttonWithType:UIButtonTypeCustom];
}
- (void)creatMapView {
    

    self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.userLocation = [self.mapManager.allLocationArray lastObject];
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
    [_mapView setZoomLevel:16.5 animated:NO];
    
    // 楼块
//    _mapView.showsBuildings = NO;
    
    //    _mapView.logoCenter = CGPointMake(SCREEN_WIDTH - 55, 450);
    // 交互
//    _mapView.userInteractionEnabled = NO;
    // 允许自定义精度圈
    _mapView.customizeUserLocationAccuracyCircleRepresentation = YES;
    // 中心位置
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(_userLocation.latitude, _userLocation.longitude);
    [_mapView setCenterCoordinate:centerCoordinate animated:NO];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
     if ([keyPath isEqualToString:@"count"] && object == _mapManager) {
         CLLocationCoordinate2D commonPolylineCoords[_mapManager.allLocationArray.count];
         
         
         for (int i = 0; i < _mapManager.allLocationArray.count; i++) {
             self.location  = _mapManager.allLocationArray[i];
             commonPolylineCoords[i].latitude = self.location.latitude;
             commonPolylineCoords[i].longitude = self.location.longitude;
         }
         
         //构造折线对象
         if (_mapView.overlays) {
             
             [_mapView removeOverlay:_commonPolyline];
         }
         self.commonPolyline = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:_mapManager.allLocationArray.count];
         
         //在地图上添加折线对象
         [_mapView addOverlay: _commonPolyline];

     }
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay {
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:(MAPolyline *)overlay];
        
        polylineRenderer.lineWidth = 10.f;
        polylineRenderer.strokeColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:1.0];
        // 连接类型
        polylineRenderer.lineJoinType = kMALineJoinRound;
        // 端点类型
        polylineRenderer.lineCapType = kMALineCapRound;
        
        return polylineRenderer;
    }
    return nil;
}


//用来自定义转场动画
-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    
    if(operation == UINavigationControllerOperationPop)
    {
        CustomAnimateTransitionPop *pingInvert = [CustomAnimateTransitionPop new];
        pingInvert.contentMode = JiangContentModeBackToExercise;
        pingInvert.button = self.backButton;
        return pingInvert;
    } else {
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
