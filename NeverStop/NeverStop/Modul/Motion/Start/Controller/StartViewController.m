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
#import "CaloriePickerView.h"
#import "CustomPickerView.h"
#import "ExerciseViewController.h"
#import "CustomAnimateTransitionPush.h"

@interface StartViewController ()
<
MAMapViewDelegate,
AMapSearchDelegate,
AimSettingPickerViewDelegate,
CaloriePickerViewDelegate,
CustomPickerViewDelegate,
UINavigationControllerDelegate
>
@property (nonatomic, retain) MAMapView *mapView;
@property (nonatomic, retain) UIButton *settingButton;
@property (nonatomic, retain) AMapSearchAPI *mapSearchAPI;
@property (nonatomic, retain) JiangPickerView *aimPickerView;

@property (nonatomic, retain) NSString *setting;
@property (nonatomic, assign) NSInteger row;


@end

@implementation StartViewController
- (void)dealloc {
    
    self.navigationController.delegate = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.delegate = self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //自定义一个NaVigationBar
    self.row = 0;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //消除阴影
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatMapView];
    
    // 设定目标按钮
    self.settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_settingButton setTitle:@"设定单次目标" forState:UIControlStateNormal];
    [_settingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _settingButton.titleLabel.font = kFONT_SIZE_18_BOLD;
    _settingButton.backgroundColor = [UIColor clearColor];
    CGFloat width = [_settingButton.titleLabel.text widthWithFont:_settingButton.titleLabel.font constrainedToHeight:50];
    _settingButton.frame = CGRectMake(SCREEN_WIDTH / 2 - width / 2, _mapView.y + _mapView.height, width, 50);
    
    __weak typeof(self) weakSelf = self;
    [_settingButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        AimSettingPickerView *aimSettingPicker = [[AimSettingPickerView alloc]init];
        aimSettingPicker.delegate = weakSelf;
        aimSettingPicker.contentMode = JiangPickerContentModeBottom;
        [aimSettingPicker show];
        
    }];
    [self.view addSubview:_settingButton];
    
    
    
    //     缩放 开始按钮
    
    self.startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _startButton.frame = CGRectMake(SCREEN_WIDTH / 2 - 40, SCREEN_HEIGHT - 240, 80, 80);
    UIImage *startImage = [UIImage imageNamed:@"1"];
    startImage = [startImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [_startButton setBackgroundImage:startImage forState:UIControlStateNormal];
    [_startButton setBackgroundImage:startImage forState:UIControlStateHighlighted];
    [_startButton setBackgroundImage:startImage forState:UIControlStateHighlighted];
    _startButton.backgroundColor = [UIColor greenColor];
    
    
    
    
    [_startButton addTarget:self action:@selector(pressedEvent:) forControlEvents:UIControlEventTouchDown];
    [_startButton addTarget:self action:@selector(cancelEvent:) forControlEvents:UIControlEventTouchDragOutside];
    [_startButton addTarget:self action:@selector(unpressedEvent:) forControlEvents:UIControlEventTouchUpInside];
    _startButton.layer.cornerRadius = 40;
    _startButton.clipsToBounds = YES;
    [self.view addSubview:_startButton];
    
    
    
    
    
    
}

- (void)aimSettingPicker:(AimSettingPickerView *)aimSettingPicker setting:(NSString *)setting viewForRow:(NSInteger)row forChildRow:(NSInteger)childRow {
    
    NSLog(@"%ld %ld", (long)childRow, (long)row);
    self.row = row;
    CustomPickerView *customPicker = [[CustomPickerView alloc] init];
    customPicker.delegate = self;
    customPicker.contentMode = JiangPickerContentModeBottom;
    CaloriePickerView *caloriePicker = [[CaloriePickerView alloc] init];
    caloriePicker.delegate = self;
    caloriePicker.contentMode = JiangPickerContentModeBottom;
    
    switch (row) {
            
        case 0:
            [_settingButton setTitle:@"设定单次目标" forState:UIControlStateNormal];
            CGFloat width0 = [_settingButton.titleLabel.text widthWithFont:_settingButton.titleLabel.font constrainedToHeight:50];
            _settingButton.frame = CGRectMake(SCREEN_WIDTH / 2 - width0 / 2, _mapView.y + _mapView.height + 100, width0, 50);
            break;
        case 1:
            [_settingButton setTitle:setting forState:UIControlStateNormal];
            CGFloat width1 = [_settingButton.titleLabel.text widthWithFont:_settingButton.titleLabel.font constrainedToHeight:50];
            _settingButton.frame = CGRectMake(SCREEN_WIDTH / 2 - width1 / 2, _mapView.y + _mapView.height + 100, width1, 50);
            break;
        case 2:
            if (childRow != 0) {
                NSString *distanceStr = [NSString stringWithFormat:@"距离目标: %@", setting];
                [_settingButton setTitle:distanceStr forState:UIControlStateNormal];
                CGFloat width2 = [_settingButton.titleLabel.text widthWithFont:_settingButton.titleLabel.font constrainedToHeight:50];
                _settingButton.frame = CGRectMake(SCREEN_WIDTH / 2 - width2 / 2, _mapView.y + _mapView.height + 100, width2, 50);
                
            } else {
                customPicker.cus_ContentMode = CustomPickerContentModeDistance;
                [customPicker show];
            }
            break;
        case 3:
            if (childRow != 0) {
                NSString *timeStr = [NSString stringWithFormat:@"时间目标: %@", setting];
                [_settingButton setTitle:timeStr forState:UIControlStateNormal];
                CGFloat width3 = [_settingButton.titleLabel.text widthWithFont:_settingButton.titleLabel.font constrainedToHeight:50];
                _settingButton.frame = CGRectMake(SCREEN_WIDTH / 2 - width3 / 2, _mapView.y + _mapView.height + 100, width3, 50);
            } else {
                customPicker.cus_ContentMode = CustomPickerContentModeTime;
                [customPicker show];
            }
            break;
        case 4:
            if (childRow != 0) {
                NSString *calorieStr = [NSString stringWithFormat:@"卡路里目标: %@", setting];
                [_settingButton setTitle:calorieStr forState:UIControlStateNormal];
                CGFloat width4 = [_settingButton.titleLabel.text widthWithFont:_settingButton.titleLabel.font constrainedToHeight:50];
                _settingButton.frame = CGRectMake(SCREEN_WIDTH / 2 - width4 / 2, _mapView.y + _mapView.height + 100, width4, 50);
            } else {
                [caloriePicker show];
            }
            break;
        default:
            break;
    }
    
    
    
    
}
- (void)caloriePicker:(CaloriePickerView *)caloriePicker selected:(NSString *)selected {
    NSString *string = [NSString stringWithFormat:@"卡路里目标: %@大卡", selected];
    [_settingButton setTitle:string forState:UIControlStateNormal];
    CGFloat width = [_settingButton.titleLabel.text widthWithFont:_settingButton.titleLabel.font constrainedToHeight:50];
    _settingButton.frame = CGRectMake(SCREEN_WIDTH / 2 - width / 2, _mapView.y + _mapView.height + 100, width, 50);
    
}
- (void)customPicker:(CustomPickerView *)customPicker selected:(NSString *)selected childSelected:(NSString *)childSelected viewForRow:(NSInteger)row forChildRow:(NSInteger)childRow {
    if (customPicker.cus_ContentMode == CustomPickerContentModeDistance) {
        [_settingButton setTitle:[NSString stringWithFormat:@"距离目标: %@.%@公里", selected, childSelected] forState:UIControlStateNormal];
        CGFloat width = [_settingButton.titleLabel.text widthWithFont:_settingButton.titleLabel.font constrainedToHeight:50];
        _settingButton.frame = CGRectMake(SCREEN_WIDTH / 2 - width / 2, _mapView.y + _mapView.height + 100, width, 50);
    } else {
        NSInteger time = [selected intValue] * 60 + [childSelected intValue];
        [_settingButton setTitle:[NSString stringWithFormat:@"时间目标: %ld分钟", time] forState:UIControlStateNormal];
        CGFloat width = [_settingButton.titleLabel.text widthWithFont:_settingButton.titleLabel.font constrainedToHeight:50];
        _settingButton.frame = CGRectMake(SCREEN_WIDTH / 2 - width / 2, _mapView.y + _mapView.height + 100, width, 50);
    }
    
}




//用来自定义转场动画
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    
    if(operation == UINavigationControllerOperationPush)
    {
        CustomAnimateTransitionPush *animateTransitionPush=[CustomAnimateTransitionPush new];
        animateTransitionPush.contentMode = JiangContentModeToExercise;
        animateTransitionPush.button = self.startButton;
        return animateTransitionPush;
    }
    else
    {
        return nil;
    }
    
}


@end
