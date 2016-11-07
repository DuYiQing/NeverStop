//
//  ExerciseRecordViewController.m
//  NeverStop
//
//  Created by Jiang on 16/11/5.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "ExerciseRecordViewController.h"
#import "JiangSegmentScrollView.h"
#import "Location.h"
#import "StatusArrayModel.h"
@interface ExerciseRecordViewController ()
<
MAMapViewDelegate
>
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) UIView *detailsRecordView;
@property (nonatomic, strong) Location *location;
@property (nonatomic, strong) Location *userLocation;
@property (nonatomic, strong) MAPolyline *commonPolyline;
@property (nonatomic, strong) Location *lastLocation;
@property (nonatomic, strong) NSMutableArray *statusArray;

@property (nonatomic, strong) NSMutableArray *overlayArray;
@end

@implementation ExerciseRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"运动记录";
    [self createMapView];
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < 2; i++) {
        if (i == 0) {
            [array addObject:_mapView];
        }if (i == 1) {
            UIView *view=[[UIView alloc] init];
            view.backgroundColor=[UIColor grayColor];
            [array addObject:view];
        }
    }
    JiangSegmentScrollView *scView=[[JiangSegmentScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.bounds.size.height-64) titleArray:@[@"轨迹", @"详情"] contentViewArray:array];
    [self.view addSubview:scView];

    // Do any additional setup after loading the view.
}
- (void)createMapView {
    self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _mapView.showsUserLocation = NO;
    _mapView.delegate = self;
    // 关闭自动暂停
    _mapView.pausesLocationUpdatesAutomatically = NO;
    // 允许后台定位 iOS9以上系统必须配置
    _mapView.allowsBackgroundLocationUpdates = YES;
    // Do any additional setup after loading the view.
    // 默认模式
    //    _mapView.showsLabels = NO;
    [_mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES];
    // 比例尺
    _mapView.showsScale = NO;
    // 罗盘
    _mapView.showsCompass = NO;
    // 缩放级别
    [_mapView setZoomLevel:18 animated:YES];
    // 天空模式
    _mapView.skyModelEnable = NO;
    // 相机旋转
    _mapView.rotateCameraEnabled = NO;
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
    [self drawlocus];
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    Location *location = [_exerciseData.allLocationArray firstObject];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(location.latitude, location.longitude);
    
    [_mapView addAnnotation:pointAnnotation];
}
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay {
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:(MAPolyline *)overlay];
        
        
        
        if ([overlay.title isEqualToString:@"1"]) {
            
            polylineRenderer.lineWidth = 7.5f;
            // 连接类型
            polylineRenderer.lineJoinType = kMALineJoinMiter;
            // 端点类型
            polylineRenderer.lineCapType = kMALineCapButt;
            polylineRenderer.strokeColor = [UIColor colorWithRed:0.185 green:1.0 blue:0.6866 alpha:1.0];
            polylineRenderer.lineDash = NO;
            
        } else if ([overlay.title isEqualToString:@"2"]) {
            
            polylineRenderer.lineWidth = 7.5f;
            // 连接类型
            polylineRenderer.lineJoinType = kMALineJoinMiter;
            // 端点类型
            polylineRenderer.lineCapType = kMALineCapButt;
            polylineRenderer.strokeColor  = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
            polylineRenderer.lineDash = YES;
        }
        
        return polylineRenderer;
    }
    return nil;
}
#pragma mark - 绘画运动轨迹
- (void)drawlocus {
    // 开始暂停状态及位置数组模型
    StatusArrayModel *statusArrayModel = [[StatusArrayModel alloc] init];
    // 记录上一次定位
    self.lastLocation = [[Location alloc] init];
    // 存 StatusArrayModel 开始暂停状态及位置数组模型
    self.statusArray = [NSMutableArray array];
    // 遍历
    for (Location *location in _exerciseData.allLocationArray) {
        // 两次定位的运动状态不同时执行条件语句
        if (location.isStart != _lastLocation.isStart) {
            // 拷贝内容
            StatusArrayModel *statusModelArr = [statusArrayModel copy];
            if (location.isStart) {
                statusArrayModel.isStart = YES;
            } else {
                statusArrayModel.isStart = NO;
            }
            // 当分段数组个数大于0的时候把最后一个元素替换为 深拷贝
            if (_statusArray.count > 0) {
                [_statusArray replaceObjectAtIndex:_statusArray.count - 1 withObject:statusModelArr];
            }
            
            [_statusArray addObject:statusArrayModel];
            // 移除本次状态所有位置信息
            [statusArrayModel.array removeAllObjects];
        }
        // 记录
        _lastLocation = location;
        // 状态模型数组添加本次位置
        [statusArrayModel.array addObject:location];
    }
    
    NSLog(@"%@", _statusArray);
    
    if (_mapView.overlays) {
        [_mapView removeOverlays:_overlayArray];
    }
    if (_overlayArray.count > 0) {
        [_overlayArray removeAllObjects];
    }
    for (StatusArrayModel *temp in _statusArray) {
        
        CLLocationCoordinate2D commonPolylineCoords[temp.array.count];
        
        for (int i = 0; i < temp.array.count; i++) {
            self.location  = temp.array[i];
            commonPolylineCoords[i].latitude = self.location.latitude;
            commonPolylineCoords[i].longitude = self.location.longitude;
        }
        //构造折线对象
        
        MAPolyline *commonPolyline = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:temp.array.count];
        if (temp.isStart == YES) {
            commonPolyline.title = @"1";
        } else {
            commonPolyline.title = @"2";
        }
        [_overlayArray addObject:commonPolyline];
        
        //在地图上添加折线对象
        [_mapView addOverlay: commonPolyline];
    }
    
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
         if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.annotation = annotation;
        annotationView.canShowCallout = NO;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = NO;        //设置标注动画显示，默认为NO
        annotationView.draggable = NO;        //设置标注可以拖动，默认为NO
        //        annotationView.pinColor = MAPinAnnotationColorPurple;
//        annotationView.image = [UIImage imageNamed:[NSString stringWithFormat:@"poi_marker_%ld.png",((MAPointAnnotation *)annotation).]];
        annotationView.image = [UIImage imageNamed:@"map_startPoint"];
        annotationView.centerOffset = CGPointMake(0, -16);
        
        return annotationView;
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
