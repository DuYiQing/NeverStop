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
    UIImageView *background = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    background.image = [UIImage imageNamed:@"guide"];
    [self.view addSubview:background];
    
    UIView *blackView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    blackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [background addSubview:blackView];
    
    self.userManager = [UserManager shareUserManager];
    [_userManager openSQLite];
    [_userManager createTable];
    
    
    [self createInfoView];

    [_userManager closeSQLite];
}

- (void)createInfoView {
    
    UIView *nameBackView = [[UIView alloc] initWithFrame:CGRectMake(80, 100, SCREEN_WIDTH - 160, 30)];
    nameBackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    nameBackView.layer.cornerRadius = 5.f;
    [self.view addSubview:nameBackView];
    
    UIImageView *nameImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 0, 40, 30)];
    nameImageView.image = [UIImage imageNamed:@"guide_name"];
    [nameBackView addSubview:nameImageView];
    
    self.nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(nameImageView.x + nameImageView.width, nameImageView.y, 174, 30)];
    _nameTextField.placeholder = @"请输入昵称";
    _nameTextField.textColor = [UIColor whiteColor];
    _nameTextField.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [nameBackView addSubview:_nameTextField];
    
    UIView *birthBackView = [[UIView alloc] initWithFrame:CGRectMake(nameBackView.x, nameBackView.y + nameBackView.height + 5, nameBackView.width, nameBackView.height)];
    birthBackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    birthBackView.layer.cornerRadius = 5.f;
    [self.view addSubview:birthBackView];

    
    UIImageView *birthImageView = [[UIImageView alloc] initWithFrame:CGRectMake(nameImageView.x, nameImageView.y, nameImageView.width, nameImageView.height)];
    birthImageView.image = [UIImage imageNamed:@"guide_age"];
    [birthBackView addSubview:birthImageView];
    
    self.ageTextField = [[UITextField alloc] initWithFrame:CGRectMake(birthImageView.x + birthImageView.width, birthImageView.y, _nameTextField.width, _nameTextField.height)];
    _ageTextField.placeholder = @"请输入生日(例:1990.01.01)";
    _ageTextField.textColor = [UIColor whiteColor];
    [birthBackView addSubview:_ageTextField];
    
    UIView *tallBackView = [[UIView alloc] initWithFrame:CGRectMake(birthBackView.x, birthBackView.y + birthBackView.height + 5, birthBackView.width, birthBackView.height)];
    tallBackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    tallBackView.layer.cornerRadius = 5.f;
    [self.view addSubview:tallBackView];

    UIImageView *tallImageView = [[UIImageView alloc] initWithFrame:CGRectMake(nameImageView.x, nameImageView.y, nameImageView.width, nameImageView.height)];
    tallImageView.image = [UIImage imageNamed:@"guide_tall"];
    [tallBackView addSubview:tallImageView];
    
    self.tallTextField = [[UITextField alloc] initWithFrame:CGRectMake(tallImageView.x + tallImageView.width, tallImageView.y, _nameTextField.width, _nameTextField.height)];
    _tallTextField.textColor = [UIColor whiteColor];
    [tallBackView addSubview:_tallTextField];
    
    
    UIView *weightBackView = [[UIView alloc] initWithFrame:CGRectMake(tallBackView.x, tallBackView.y + tallBackView.height + 5, tallBackView.width, tallBackView.height)];
    weightBackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    weightBackView.layer.cornerRadius = 5.f;
    [self.view addSubview:weightBackView];
    
    UIImageView *weightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(tallImageView.x, tallImageView.y, tallImageView.width, tallImageView.height)];
    weightImageView.image = [UIImage imageNamed:@"guide_weight"];
    [self.view addSubview:weightImageView];
    
    self.weightTextField = [[UITextField alloc] initWithFrame:CGRectMake(weightImageView.x + weightImageView.width, weightImageView.y, _nameTextField.width, _nameTextField.height)];
    _weightTextField.placeholder = @"请输入您的体重(单位:千克)";
    _weightTextField.textColor = [UIColor whiteColor];
    [weightBackView addSubview:_weightTextField];
    
    UIButton *enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    enterButton.frame = CGRectMake((SCREEN_WIDTH - 80) / 2, SCREEN_HEIGHT - 100, 80, 40);
    enterButton.backgroundColor = [UIColor redColor];
    enterButton.layer.cornerRadius = 5.f;
    [enterButton setTitle:@"enter" forState:UIControlStateNormal];
    [enterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_weightTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
