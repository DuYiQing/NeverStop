//
//  ViewController.m
//  NeverStop
//
//  Created by Jiang on 16/10/20.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "ViewController.h"
#import "UserManager.h"

@interface ViewController () {
    BOOL flag;
}

@property (nonatomic, strong) UserManager *userManager;
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *ageTextField;
@property (nonatomic, strong) UITextField *tallTextField;
@property (nonatomic, strong) UITextField *weightTextField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.userManager = [UserManager shareUserManager];
    [_userManager openSQLite];
    [_userManager createTable];
    
    
    [self createInfoView];
    
}

- (void)createInfoView {
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 80, 30)];
    nameLabel.text = @"昵称";
    nameLabel.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:nameLabel];
    
    self.nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(nameLabel.x + nameLabel.width, nameLabel.y, 200, 30)];
    _nameTextField.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_nameTextField];
    
    UILabel *ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.x, nameLabel.y + nameLabel.height + 5, nameLabel.width, nameLabel.height)];
    ageLabel.text = @"年龄";
    ageLabel.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:ageLabel];
    
    self.ageTextField = [[UITextField alloc] initWithFrame:CGRectMake(ageLabel.x + ageLabel.width, ageLabel.y, _nameTextField.width, _nameTextField.height)];
    _ageTextField.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_ageTextField];
    
    UILabel *tallLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 200, 80, 30)];
    tallLabel.text = @"身高";
    tallLabel.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:tallLabel];
    
    self.tallTextField = [[UITextField alloc] initWithFrame:CGRectMake(tallLabel.x + tallLabel.width, tallLabel.y, 200, tallLabel.height)];
    _tallTextField.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_tallTextField];
    
    UILabel *weightLabel = [[UILabel alloc] initWithFrame:CGRectMake(tallLabel.x, tallLabel.y + tallLabel.height + 5, tallLabel.width, tallLabel.height)];
    weightLabel.text = @"体重";
    weightLabel.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:weightLabel];
    
    self.weightTextField = [[UITextField alloc] initWithFrame:CGRectMake(weightLabel.x + weightLabel.width, weightLabel.y, 200, weightLabel.height)];
    _weightTextField.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_weightTextField];
    
    UIButton *enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    enterButton.frame = CGRectMake((SCREEN_WIDTH - 80) / 2, SCREEN_HEIGHT - 100, 80, 40);
    enterButton.backgroundColor = [UIColor redColor];
    [enterButton setTitle:@"enter" forState:UIControlStateNormal];
    [self.view addSubview:enterButton];
    [enterButton addTarget:self action:@selector(enterButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)enterButtonAction {
    flag = YES;
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [userDef setBool:flag forKey:@"notFirst"];
    [userDef synchronize];
    
    [_userManager insertIntoWithUserName:_nameTextField.text age:_ageTextField.text tall:_tallTextField.text weight:_weightTextField.text];
    
    
    
    
    
    
    self.view.window.rootViewController = _rootTabBarController;
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
