//
//  LogIn_ViewController.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/6/14.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "LogIn_ViewController.h"
#import "Registered_ViewController.h"
#import "MusicMenuViewController.h"
#import "TabBar_ViewController.h"

#import "Login_view.h"
#import "Login_Request.h"

#import "Macro.h"
#import "NSString+EmptyProcessing.h"
#import <Masonry.h>

@interface LogIn_ViewController () <UITextFieldDelegate,UIApplicationDelegate>

@property (nonatomic, strong) Login_view *login_view;
@property (nonatomic, copy) NSString *id_string;
@property (nonatomic, copy) NSString *password_string;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic) BOOL use_code_login;
@end

@implementation LogIn_ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _use_code_login = false;
    
    self.login_view = [Login_view new];
    self.login_view.ID_field.delegate = self;
    self.login_view.PassWord_field.delegate = self;
    [self.view addSubview:self.login_view];
    [self.login_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
    
    // 手机号
    _login_view.ID_field.delegate = self;
    [[_login_view.ID_field rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        self.id_string = x;
        self->_login_view.ID_field.text = self.id_string;
        
        if (self.id_string.length == 11 &&
            self.password_string.length > 6 &&
            self.password_string.length < 23) {
            [self->_login_view.login_button setBackgroundColor:[UIColor colorWithRed:255/255.0 green:203/255.0 blue:6/255.0 alpha:1]];
        } else {
            [self->_login_view.login_button setBackgroundColor:[UIColor colorWithRed:255/255.0 green:203/255.0 blue:6/255.0 alpha:0.5]];
        }
    }];
    
    // 密码
    _login_view.PassWord_field.delegate = self;
    [[_login_view.PassWord_field rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        self.password_string = x;
        self->_login_view.PassWord_field.text = self.password_string;
        
        if (self.id_string.length == 11 &&
            self.password_string.length > 6 &&
            self.password_string.length < 23) {
            [self->_login_view.login_button setBackgroundColor:[UIColor colorWithRed:255/255.0 green:203/255.0 blue:6/255.0 alpha:1]];
        } else {
            [self->_login_view.login_button setBackgroundColor:[UIColor colorWithRed:255/255.0 green:203/255.0 blue:6/255.0 alpha:0.5]];
        }
    }];
    
#pragma mark 使用验证码登录
    [[_login_view.use_codeLogin_but rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        x.selected = !x.selected;
        if (x.selected && self->_use_code_login == false) {
            self->_login_view.code_but.hidden = false;
            self->_use_code_login = true;
            [self->_login_view.use_codeLogin_but setTitle:@"密码登录" forState:UIControlStateNormal];
            self->_login_view.PassWord_field.placeholder = @"请填写您的验证码";
        } else {
            self->_login_view.code_but.hidden = true;
            self->_use_code_login = false;
            [self->_login_view.use_codeLogin_but setTitle:@"验证码登录" forState:UIControlStateNormal];
            self->_login_view.PassWord_field.placeholder = @"请填写您的密码";
        }
    }];
    
#pragma mark 注册
    [[self.login_view.registered_button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        Registered_ViewController *registeredvc = [[Registered_ViewController alloc] init];
        registeredvc.type = 0;
        [self.navigationController pushViewController:registeredvc animated:YES];
    }];
    
#pragma mark 忘记密码
    [[self.login_view.forget_password_but rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        Registered_ViewController *registeredvc = [[Registered_ViewController alloc] init];
        registeredvc.type = 1;
        [self.navigationController pushViewController:registeredvc animated:YES];
    }];
    
#pragma mark 登录
    [[_login_view.login_button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        SSTabBar_ViewController *tabbar = [[SSTabBar_ViewController alloc] init];
        [self.navigationController presentViewController:tabbar animated:true completion:nil];
    }];
}

#pragma mark 关闭键盘
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES]; //实现该方法是需要注意view需要是继承UIControl而来的
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
