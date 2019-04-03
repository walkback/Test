//
//  Login_view.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/6/14.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "Login_view.h"
#import "Macro.h"
#import <Masonry.h>

@interface Login_view ()



@end

@implementation Login_view

- (instancetype)init {
    if (self = [super init]) {
        
        self.backgroundColor = UIColor.whiteColor;
        
        UIImageView *bg_imagev = [UIImageView new];
        [self addSubview:bg_imagev];
        [bg_imagev mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(WIDTH, WIDTH * 0.5));
        }];
        
        _headportrait_imagev = [UIImageView new];
        _headportrait_imagev.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"头像背景"]];
        [self addSubview:_headportrait_imagev];
        [_headportrait_imagev mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.top.equalTo(bg_imagev.mas_bottom).offset(-50);
            make.size.mas_equalTo(CGSizeMake(100, 100));
        }];
        
        UILabel *login_lab = [UILabel new];
        login_lab.textAlignment = NSTextAlignmentCenter;
        login_lab.text = @"登录";
        login_lab.textColor = [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1.0];
        login_lab.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 30];
        [self addSubview:login_lab];
        [login_lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.top.equalTo(self->_headportrait_imagev.mas_bottom).offset(20);
            make.left.right.equalTo(self);
        }];
        
        UILabel *phone = [UILabel new];
        phone.textAlignment = NSTextAlignmentRight;
        phone.text = @"+86";
        phone.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        phone.font = [UIFont systemFontOfSize:14];
        [self addSubview:phone];
        [phone mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(login_lab.mas_bottom).offset(50);
            make.left.equalTo(self);
            make.width.mas_equalTo(25 + 42);
        }];
        
        _ID_field = [UITextField new];
        _ID_field.keyboardType = UIKeyboardTypeNumberPad;
        _ID_field.font = [UIFont systemFontOfSize:14];
        _ID_field.textAlignment = NSTextAlignmentCenter;
        _ID_field.placeholder = @"请填写您的手机号";
        [self addSubview:_ID_field];
        [_ID_field mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(phone);
            make.centerX.mas_equalTo(self);
            make.left.equalTo(self).offset(105);
            make.right.equalTo(self).offset(-105);
            make.height.mas_equalTo(20);
        }];
        
        _code_but = [UIButton new];
        _code_but.hidden = true;
        [_code_but.layer setCornerRadius:4];
        _code_but.layer.masksToBounds = true;
        [_code_but.layer setBorderWidth:1];
        [_code_but.layer setBorderColor:[UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0].CGColor];
        [_code_but setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_code_but setTitleColor:[UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0] forState:UIControlStateNormal];
        _code_but.titleLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_code_but];
        [_code_but mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(phone);
            make.right.equalTo(self).offset(-30);
            make.size.mas_equalTo(CGSizeMake(75, 30));
        }];
        
        UIImageView *line_imageview = [UIImageView new];
        line_imageview.backgroundColor = Line_Color;
        [self addSubview:line_imageview];
        [line_imageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self->_ID_field.mas_bottom).offset(10);
            make.height.mas_equalTo(1);
            make.left.equalTo(self).offset(33);
            make.right.equalTo(self).offset(-33);
        }];
        
        UILabel *password = [UILabel new];
        password.textAlignment = NSTextAlignmentRight;
        password.text = @"密码";
        password.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        password.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 14];
        [self addSubview:password];
        [password mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line_imageview.mas_bottom).offset(20);
            make.left.equalTo(self);
            make.width.mas_equalTo(25 + 42);
        }];
        
        _PassWord_field = [UITextField new];
        _PassWord_field.font = [UIFont systemFontOfSize:14];
        _PassWord_field.secureTextEntry = true;
        _PassWord_field.keyboardType = UIKeyboardTypeASCIICapable;
        _PassWord_field.textAlignment = NSTextAlignmentCenter;
        _PassWord_field.placeholder = @"请填写您的密码";
        [self addSubview:_PassWord_field];
        [_PassWord_field mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(password);
            make.centerX.mas_equalTo(self);
            make.left.equalTo(self).offset(67);
            make.right.equalTo(self).offset(-67);
            make.height.mas_equalTo(20);
        }];
        
        UIImageView *line_imageview_two = [UIImageView new];
        line_imageview_two.backgroundColor = Line_Color;
        [self addSubview:line_imageview_two];
        [line_imageview_two mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self->_PassWord_field.mas_bottom).offset(10);
            make.height.mas_equalTo(1);
            make.left.equalTo(self).offset(33);
            make.right.equalTo(self).offset(-33);
        }];
        
        _use_codeLogin_but = [UIButton new];
        [_use_codeLogin_but setTitle:@"验证码登录" forState:UIControlStateNormal];
        _use_codeLogin_but.titleLabel.font = [UIFont systemFontOfSize:14];
        [_use_codeLogin_but setTitleColor:[UIColor colorWithRed:99/255.0 green:173/255.0 blue:247/255.0 alpha:1.0] forState:UIControlStateNormal];
        [self addSubview:_use_codeLogin_but];
        [_use_codeLogin_but mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line_imageview_two.mas_bottom).offset(15);
            make.left.equalTo(self).offset(32);
            make.width.mas_equalTo(80);
        }];
        
        _login_button = [UIButton new];
        [_login_button setTitle:@"登录" forState:UIControlStateNormal];
        [_login_button setTitleColor:[UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1.0] forState:UIControlStateNormal];
        _login_button.titleLabel.font = [UIFont systemFontOfSize:15];
        [_login_button setBackgroundColor:[UIColor colorWithRed:255/255.0 green:203/255.0 blue:6/255.0 alpha:0.5]];
        [_login_button.layer setCornerRadius:4];
        _login_button.layer.masksToBounds = true;
        [self addSubview:_login_button];
        [_login_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self->_use_codeLogin_but.mas_bottom).offset(30);
            make.centerX.mas_equalTo(self);
            make.left.equalTo(self).offset(41);
            make.right.equalTo(self).offset(-41);
            make.height.mas_equalTo(35);
        }];
        
        UIImageView *line_imageview_three = [UIImageView new];
        line_imageview_three.backgroundColor = Line_Color;
        [self addSubview:line_imageview_three];
        [line_imageview_three mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.bottom.equalTo(self).offset(-20);
            make.width.mas_equalTo(1);
            make.height.mas_equalTo(15);
        }];
        
        _registered_button = [UIButton new];
        [_registered_button setTitle:@"立即注册" forState:UIControlStateNormal];
        [_registered_button setTitleColor:[UIColor colorWithRed:99/255.0 green:173/255.0 blue:247/255.0 alpha:1.0] forState:UIControlStateNormal];
        _registered_button.titleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_registered_button];
        [_registered_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(line_imageview_three);
            make.right.equalTo(line_imageview_three.mas_left).offset(-10);
            make.width.mas_equalTo(60);
        }];
        
        _forget_password_but = [UIButton new];
        [_forget_password_but setTitle:@"忘记密码" forState:UIControlStateNormal];
        [_forget_password_but setTitleColor:[UIColor colorWithRed:99/255.0 green:173/255.0 blue:247/255.0 alpha:1.0] forState:UIControlStateNormal];
        _forget_password_but.titleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_forget_password_but];
        [_forget_password_but mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(line_imageview_three);
            make.left.equalTo(line_imageview_three.mas_right).offset(10);
            make.width.mas_equalTo(60);
        }];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
