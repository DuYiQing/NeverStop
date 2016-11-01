//
//  GroupViewController.m
//  NeverStop
//
//  Created by dllo on 16/10/31.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "GroupViewController.h"

@interface GroupViewController ()

@end

@implementation GroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200);
    imageView.backgroundColor = [UIColor redColor];
    [self.view addSubview:imageView];
    
    
    UIImageView *userImageView = [[UIImageView alloc] init];
    userImageView.frame = CGRectMake(30, 150, 100, 100);
    userImageView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:userImageView];
    
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(30, 270, 300,40);
    titleLabel.backgroundColor = [UIColor brownColor];
    titleLabel.text = @"121";
    titleLabel.textColor = [UIColor orangeColor];
    [self.view addSubview:titleLabel];
    
    
    UILabel *userContLabel = [[UILabel alloc] init];
    userContLabel.frame = CGRectMake(40, 310, 40, 20);
    userContLabel.backgroundColor = [UIColor blueColor];
    userContLabel.text = @"aaa";
    userContLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:userContLabel];
    
    UILabel *addressLabel = [[UILabel alloc] init];
    addressLabel.frame = CGRectMake(90, 310, 40, 20);
    addressLabel.backgroundColor = [UIColor blueColor];
    addressLabel.text = @"aasd";
    addressLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:addressLabel];

    
    UIButton *goButton = [[UIButton alloc] init];
    goButton.frame = CGRectMake(SCREEN_WIDTH - 100, 240, 100, 40);
    goButton.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:goButton];
    
    
    
    UIButton *gogoButton = [[UIButton alloc] init];
    gogoButton.frame = CGRectMake(50, SCREEN_HEIGHT - 100, SCREEN_WIDTH - 100, 40);
    gogoButton.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:gogoButton];
    
    
    
    
    
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
