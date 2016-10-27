//
//  MapViewController.m
//  NeverStop
//
//  Created by Jiang on 16/10/26.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "MapViewController.h"
#import "CustomAnimateTransitionPop.h"

@interface MapViewController ()
<
UINavigationControllerDelegate
>
@property (nonatomic, retain) UIButton *backButton;
@end

@implementation MapViewController
- (void)dealloc {
//    self.navigationController.delegate = nil;
}
- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.delegate = self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backButton.frame =  CGRectMake(SCREEN_WIDTH - 50, 32, 30, 30);
    _backButton.layer.cornerRadius = 15;

    _backButton.backgroundColor = [UIColor redColor];
    __weak typeof(self) weakSelf = self;
    [_backButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
        
    }];
    [self.view addSubview:_backButton];
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
