//
//  ViewController.m
//  NeverStop
//
//  Created by Jiang on 16/10/20.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "ViewController.h"
#import "UserManager.h"


@interface ViewController ()
<
UITextFieldDelegate
>
{
    BOOL flag;
}
@property (nonatomic, strong) UserManager *userManager;
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *ageTextField;
@property (nonatomic, strong) UITextField *tallTextField;
@property (nonatomic, strong) UITextField *weightTextField;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIButton *enterButton;

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
    
    
    
    [self createInfoView];

    
    self.tipLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 200) / 2, SCREEN_HEIGHT / 2, 200, 45)];
    _tipLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    _tipLabel.font = kFONT_SIZE_15;
    _tipLabel.textColor = [UIColor whiteColor];
    _tipLabel.textAlignment = NSTextAlignmentCenter;
    _tipLabel.layer.cornerRadius = 5.f;
    _tipLabel.clipsToBounds = YES;
    _tipLabel.hidden = YES;
    [self.view addSubview:_tipLabel];
    
}

- (void)createInfoView {
    
    UIView *nameBackView = [[UIView alloc] initWithFrame:CGRectMake(60, 100, SCREEN_WIDTH - 120, 50)];
    nameBackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    nameBackView.layer.cornerRadius = 5.f;
    [self.view addSubview:nameBackView];
    
    UIImageView *nameImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 7.5, 35, 35)];
    nameImageView.image = [UIImage imageNamed:@"guide_name"];
    [nameBackView addSubview:nameImageView];
    
    self.nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(nameImageView.x + nameImageView.width + 5, nameImageView.y, 190, 40)];
    NSString *nameHolderText = @"请输入昵称";
    NSMutableAttributedString *namePlaceholder = [[NSMutableAttributedString alloc] initWithString:nameHolderText];
    [namePlaceholder addAttribute:NSForegroundColorAttributeName
                        value:[UIColor colorWithWhite:1 alpha:0.5]
                        range:NSMakeRange(0, nameHolderText.length)];
    [namePlaceholder addAttribute:NSFontAttributeName
                        value:[UIFont boldSystemFontOfSize:14]
                        range:NSMakeRange(0, nameHolderText.length)];
    _nameTextField.attributedPlaceholder = namePlaceholder;
    _nameTextField.textColor = [UIColor whiteColor];
    _nameTextField.delegate = self;
    _nameTextField.tag = 1499;
    [nameBackView addSubview:_nameTextField];
    
    
    
    UIView *birthBackView = [[UIView alloc] initWithFrame:CGRectMake(nameBackView.x, nameBackView.y + nameBackView.height + 5, nameBackView.width, nameBackView.height)];
    birthBackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    birthBackView.layer.cornerRadius = 5.f;
    [self.view addSubview:birthBackView];

    
    UIImageView *birthImageView = [[UIImageView alloc] initWithFrame:CGRectMake(nameImageView.x, nameImageView.y, nameImageView.width, nameImageView.height)];
    birthImageView.image = [UIImage imageNamed:@"guide_age"];
    [birthBackView addSubview:birthImageView];
    
    self.ageTextField = [[UITextField alloc] initWithFrame:CGRectMake(birthImageView.x + birthImageView.width + 5, birthImageView.y, _nameTextField.width, _nameTextField.height)];
    NSString *ageHolderText = @"请输入年龄";
    NSMutableAttributedString *agePlaceholder = [[NSMutableAttributedString alloc] initWithString:ageHolderText];
    [agePlaceholder addAttribute:NSForegroundColorAttributeName
                        value:[UIColor colorWithWhite:1 alpha:0.5]
                        range:NSMakeRange(0, ageHolderText.length)];
    [agePlaceholder addAttribute:NSFontAttributeName
                        value:[UIFont boldSystemFontOfSize:14]
                        range:NSMakeRange(0, ageHolderText.length)];
    _ageTextField.attributedPlaceholder = agePlaceholder;
    _ageTextField.textColor = [UIColor whiteColor];
    _ageTextField.delegate = self;
    _ageTextField.tag = 1500;
    [birthBackView addSubview:_ageTextField];
    
    UIView *tallBackView = [[UIView alloc] initWithFrame:CGRectMake(birthBackView.x, birthBackView.y + birthBackView.height + 5, birthBackView.width, birthBackView.height)];
    tallBackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    tallBackView.layer.cornerRadius = 5.f;
    [self.view addSubview:tallBackView];

    UIImageView *tallImageView = [[UIImageView alloc] initWithFrame:CGRectMake(nameImageView.x, nameImageView.y, nameImageView.width, nameImageView.height)];
    tallImageView.image = [UIImage imageNamed:@"guide_tall"];
    [tallBackView addSubview:tallImageView];
    
    self.tallTextField = [[UITextField alloc] initWithFrame:CGRectMake(tallImageView.x + tallImageView.width + 5, tallImageView.y, _nameTextField.width, _nameTextField.height)];
    NSString *tallHolderText = @"请输入身高(cm)";
    NSMutableAttributedString *tallPlaceholder = [[NSMutableAttributedString alloc] initWithString:tallHolderText];
    [tallPlaceholder addAttribute:NSForegroundColorAttributeName
                           value:[UIColor colorWithWhite:1 alpha:0.5]
                           range:NSMakeRange(0, tallHolderText.length)];
    [tallPlaceholder addAttribute:NSFontAttributeName
                           value:[UIFont boldSystemFontOfSize:14]
                           range:NSMakeRange(0, tallHolderText.length)];
    _tallTextField.attributedPlaceholder = tallPlaceholder;
    _tallTextField.textColor = [UIColor whiteColor];
    _tallTextField.delegate = self;
    _tallTextField.tag = 1501;
    [tallBackView addSubview:_tallTextField];
    
    
    UIView *weightBackView = [[UIView alloc] initWithFrame:CGRectMake(tallBackView.x, tallBackView.y + tallBackView.height + 5, tallBackView.width, tallBackView.height)];
    weightBackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    weightBackView.layer.cornerRadius = 5.f;
    [self.view addSubview:weightBackView];
    
    UIImageView *weightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(tallImageView.x, tallImageView.y, tallImageView.width, tallImageView.height)];
    weightImageView.image = [UIImage imageNamed:@"guide_weight"];
    [weightBackView addSubview:weightImageView];
    
    self.weightTextField = [[UITextField alloc] initWithFrame:CGRectMake(weightImageView.x + weightImageView.width + 5, weightImageView.y, _nameTextField.width, _nameTextField.height)];
    NSString *weightHolderText = @"请输入体重(kg)";
    NSMutableAttributedString *weightPlaceholder = [[NSMutableAttributedString alloc] initWithString:weightHolderText];
    [weightPlaceholder addAttribute:NSForegroundColorAttributeName
                           value:[UIColor colorWithWhite:1 alpha:0.5]
                           range:NSMakeRange(0, weightHolderText.length)];
    [weightPlaceholder addAttribute:NSFontAttributeName
                           value:[UIFont boldSystemFontOfSize:14]
                           range:NSMakeRange(0, weightHolderText.length)];
    _weightTextField.attributedPlaceholder = weightPlaceholder;
    _weightTextField.textColor = [UIColor whiteColor];
    _weightTextField.delegate = self;
    _weightTextField.tag = 1502;
    [weightBackView addSubview:_weightTextField];
    
    self.enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _enterButton.frame = CGRectMake((SCREEN_WIDTH - 80) / 2, SCREEN_HEIGHT - 100, 80, 40);
    _enterButton.backgroundColor = [UIColor redColor];
    _enterButton.layer.cornerRadius = 5.f;
    [_enterButton setTitle:@"enter" forState:UIControlStateNormal];
    [_enterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:_enterButton];
    [_enterButton addTarget:self action:@selector(enterButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)enterButtonAction {
    flag = YES;
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [userDef setBool:flag forKey:@"notFirst"];
    [userDef synchronize];
    
    
    if ([_nameTextField.text isEqualToString:@""]) {
//        self.tipLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 200) / 2, SCREEN_HEIGHT / 2, 200, 45)];
//        _tipLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        _tipLabel.hidden = NO;
        _tipLabel.alpha = 1;
        _tipLabel.text = @"昵称不能为空";
//        _tipLabel.font = kFONT_SIZE_15;
//        _tipLabel.textColor = [UIColor whiteColor];
//        _tipLabel.textAlignment = NSTextAlignmentCenter;
//        _tipLabel.layer.cornerRadius = 5.f;
//        _tipLabel.clipsToBounds = YES;
//        [self.view addSubview:_tipLabel];
        [UIView animateWithDuration:1 delay:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _tipLabel.alpha = 0;
        } completion:^(BOOL finished) {
//            [_tipLabel removeFromSuperview];
            _tipLabel.hidden = YES;
        }];
    } else if([_nameTextField.text containsString:@" "]) {
//        self.tipLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 200) / 2, SCREEN_HEIGHT / 2, 200, 45)];
//        _tipLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        _tipLabel.hidden = NO;
        _tipLabel.alpha = 1;
        _tipLabel.text = @"昵称中不能包含空格";
//        _tipLabel.font = kFONT_SIZE_15;
//        _tipLabel.textColor = [UIColor whiteColor];
//        _tipLabel.textAlignment = NSTextAlignmentCenter;
//        _tipLabel.layer.cornerRadius = 5.f;
//        _tipLabel.clipsToBounds = YES;
//        [self.view addSubview:_tipLabel];
        [UIView animateWithDuration:1 delay:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _tipLabel.alpha = 0;
        } completion:^(BOOL finished) {
//            [_tipLabel removeFromSuperview];
            _tipLabel.hidden = YES;
        }];

    } else if ([_tallTextField.text isEqualToString:@""]) {
//        self.tipLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 200) / 2, SCREEN_HEIGHT / 2, 200, 45)];
//        _tipLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        _tipLabel.hidden = NO;
        _tipLabel.alpha = 1;
        _tipLabel.text = @"身高不能为空";
//        _tipLabel.font = kFONT_SIZE_15;
//        _tipLabel.textColor = [UIColor whiteColor];
//        _tipLabel.textAlignment = NSTextAlignmentCenter;
//        _tipLabel.layer.cornerRadius = 5.f;
//        _tipLabel.clipsToBounds = YES;
        [self.view addSubview:_tipLabel];
        [UIView animateWithDuration:1 delay:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _tipLabel.alpha = 0;
        } completion:^(BOOL finished) {
//            [_tipLabel removeFromSuperview];
            _tipLabel.hidden = YES;
        }];

    } else if ([_weightTextField.text isEqualToString:@""]) {
//        self.tipLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 200) / 2, SCREEN_HEIGHT / 2, 200, 45)];
//        _tipLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        _tipLabel.hidden = NO;
        _tipLabel.alpha = 1;
        _tipLabel.text = @"体重不能为空";
//        _tipLabel.font = kFONT_SIZE_15;
//        _tipLabel.textColor = [UIColor whiteColor];
//        _tipLabel.textAlignment = NSTextAlignmentCenter;
//        _tipLabel.layer.cornerRadius = 5.f;
//        _tipLabel.clipsToBounds = YES;
//        [self.view addSubview:_tipLabel];
        [UIView animateWithDuration:1 delay:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _tipLabel.alpha = 0;
        } completion:^(BOOL finished) {
//            [_tipLabel removeFromSuperview];
            _tipLabel.hidden = YES;
        }];

    } else {
        [_userManager openSQLite];
        [_userManager createTable];
        [_userManager insertIntoWithUserName:_nameTextField.text age:_ageTextField.text tall:_tallTextField.text weight:_weightTextField.text];

        self.view.window.rootViewController = _rootTabBarController;
    }

}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ((textField.tag == 1499) && (textField.text.length > 7)) {
        _enterButton.userInteractionEnabled = NO;
//        self.tipLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 200) / 2, SCREEN_HEIGHT / 2, 200, 45)];
//        _tipLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        _tipLabel.hidden = NO;
        _tipLabel.alpha = 1;
        _tipLabel.text = @"昵称不得长于7个字符";
//        _tipLabel.font = kFONT_SIZE_15;
//        _tipLabel.textColor = [UIColor whiteColor];
//        _tipLabel.textAlignment = NSTextAlignmentCenter;
//        _tipLabel.layer.cornerRadius = 5.f;
//        _tipLabel.clipsToBounds = YES;
//        [self.view addSubview:_tipLabel];
        [UIView animateWithDuration:1 delay:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _tipLabel.alpha = 0;
        } completion:^(BOOL finished) {
//            [_tipLabel removeFromSuperview];
            _tipLabel.hidden = YES;
        }];
    } else {
        _enterButton.userInteractionEnabled = YES;
    }
    if (textField.tag == 1500) {
        if ([textField.text integerValue] > 100 | [textField.text integerValue] < 0) {
            _enterButton.userInteractionEnabled = NO;
//            self.tipLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 200) / 2, SCREEN_HEIGHT / 2, 200, 45)];
//            _tipLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
            _tipLabel.hidden = NO;
            _tipLabel.alpha = 1;
            _tipLabel.text = @"请输入正确年龄";
//            _tipLabel.font = kFONT_SIZE_15;
//            _tipLabel.textColor = [UIColor whiteColor];
//            _tipLabel.textAlignment = NSTextAlignmentCenter;
//            _tipLabel.layer.cornerRadius = 5.f;
//            _tipLabel.clipsToBounds = YES;
//            [self.view addSubview:_tipLabel];
            [UIView animateWithDuration:1 delay:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                _tipLabel.alpha = 0;
            } completion:^(BOOL finished) {
//                [_tipLabel removeFromSuperview];
                _tipLabel.hidden = YES;
            }];
        } else {
            _enterButton.userInteractionEnabled = YES;
        }
    }
    if (textField.tag == 1501) {
        if ([textField.text integerValue] > 300 | [textField.text integerValue] < 100) {
            _enterButton.userInteractionEnabled = NO;
//            self.tipLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 200) / 2, SCREEN_HEIGHT / 2, 200, 45)];
//            _tipLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
            _tipLabel.hidden = NO;
            _tipLabel.alpha = 1;
            _tipLabel.text = @"请输入正确身高";
//            _tipLabel.font = kFONT_SIZE_15;
//            _tipLabel.textColor = [UIColor whiteColor];
//            _tipLabel.textAlignment = NSTextAlignmentCenter;
//            _tipLabel.layer.cornerRadius = 5.f;
//            _tipLabel.clipsToBounds = YES;
//            [self.view addSubview:_tipLabel];
            [UIView animateWithDuration:1 delay:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                _tipLabel.alpha = 0;
            } completion:^(BOOL finished) {
//                [_tipLabel removeFromSuperview];
                _tipLabel.hidden = YES;
            }];

        } else {
            _enterButton.userInteractionEnabled = YES;
        }
    }
    if (textField.tag == 1502) {
        if ([textField.text integerValue] > 300 | [textField.text integerValue] < 10) {
            _enterButton.userInteractionEnabled = YES;
//            self.tipLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 200) / 2, SCREEN_HEIGHT / 2, 200, 45)];
//            _tipLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
            _tipLabel.hidden = NO;
            _tipLabel.alpha = 1;
            _tipLabel.text = @"请输入正确体重";
//            _tipLabel.font = kFONT_SIZE_15;
//            _tipLabel.textColor = [UIColor whiteColor];
//            _tipLabel.textAlignment = NSTextAlignmentCenter;
//            _tipLabel.layer.cornerRadius = 5.f;
//            _tipLabel.clipsToBounds = YES;
//            [self.view addSubview:_tipLabel];
            [UIView animateWithDuration:1 delay:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                _tipLabel.alpha = 0;
            } completion:^(BOOL finished) {
//                [_tipLabel removeFromSuperview];
                _tipLabel.hidden = YES;
            }];

        } else {
            _enterButton.userInteractionEnabled = YES;
        }
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (1499 == textField.tag) {
        textField.keyboardType = UIKeyboardTypeNamePhonePad;
    }
    if (textField.tag == 1500) {
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    if (1501 == textField.tag | 1502 == textField.tag) {
        textField.keyboardType = UIKeyboardTypeDecimalPad;
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_nameTextField resignFirstResponder];
    [_ageTextField resignFirstResponder];
    [_tallTextField resignFirstResponder];
    [_weightTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
