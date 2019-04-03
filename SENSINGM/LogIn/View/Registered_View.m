//
//  Registered_View.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/12/10.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "Registered_View.h"

@implementation Registered_View

- (instancetype)init {
    if (self = [super init]) {
        _back_but = [UIButton new];
        [_back_but setBackgroundImage:[UIImage imageNamed:@"退出"] forState:UIControlStateNormal];
        [self addSubview:_back_but];
        [_back_but mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(IS_IPhoneX ? 44 + 17 : 20 + 17);
            make.left.equalTo(self).offset(15);
            make.size.mas_equalTo(CGSizeMake(24, 24));
        }];
        
        _title_lab = [UILabel new];
        _title_lab.textAlignment = NSTextAlignmentCenter;
        _title_lab.font = [UIFont systemFontOfSize:30];
        _title_lab.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        [self addSubview:_title_lab];
        [_title_lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self->_back_but.mas_bottom).offset(10);
            make.centerX.mas_equalTo(self);
            make.left.right.equalTo(self);
        }];
        
        UILabel *phone = [UILabel new];
        phone.textAlignment = NSTextAlignmentCenter;
        phone.text = @"+86";
        phone.textColor = TEXTCOLOR;
        phone.font = [UIFont systemFontOfSize:14];
        [self addSubview:phone];
        [phone mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.title_lab.mas_bottom).offset(64);
            make.width.mas_equalTo(50);
            make.left.equalTo(self).offset(30);
        }];
        
        _phone_filed = [UITextField new];
        _phone_filed.delegate = self;
        _phone_filed.keyboardType = UIKeyboardTypeNumberPad;
        _phone_filed.placeholder = @"请填写您的手机号码";
        _phone_filed.font = [UIFont systemFontOfSize:14];
        _phone_filed.textAlignment = NSTextAlignmentCenter;
        _phone_filed.textColor = TEXTCOLOR;
        [self addSubview:_phone_filed];
        [_phone_filed mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(phone);
            make.left.equalTo(self).offset(105);
            make.right.equalTo(self).offset(-105);
            make.height.mas_equalTo(30);
        }];
        
        _code_but = [UIButton new];
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
            make.top.equalTo(self->_phone_filed.mas_bottom).offset(10);
            make.left.equalTo(self).offset(30);
            make.right.equalTo(self).offset(-30);
            make.height.mas_equalTo(1);
        }];
        
        
        UILabel *code = [UILabel new];
        code.textAlignment = NSTextAlignmentCenter;
        code.text = @"验证码";
        code.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        code.font = [UIFont systemFontOfSize:14];
        [self addSubview:code];
        [code mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line_imageview.mas_bottom).offset(20);
            make.width.mas_equalTo(50);
            make.left.equalTo(self).offset(30);
        }];

        _code_filed = [UITextField new];
        _code_filed.delegate = self;
        _code_filed.keyboardType = UIKeyboardTypeNumberPad;
        _code_filed.placeholder = @"请填写您收到的短信验证码";
        _code_filed.font = [UIFont systemFontOfSize:14];
        _code_filed.textAlignment = NSTextAlignmentCenter;
        _code_filed.textColor = TEXTCOLOR;
        [self addSubview:_code_filed];
        [_code_filed mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(code);
            make.left.equalTo(self).offset(90);
            make.right.equalTo(self).offset(-90);
            make.height.mas_equalTo(30);
        }];
        
        UIImageView *line_imageview_two = [UIImageView new];
        line_imageview_two.backgroundColor = Line_Color;
        [self addSubview:line_imageview_two];
        [line_imageview_two mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self->_code_filed.mas_bottom).offset(10);
            make.left.equalTo(self).offset(30);
            make.right.equalTo(self).offset(-30);
            make.height.mas_equalTo(1);
        }];
        
        UILabel *password = [UILabel new];
        password.textAlignment = NSTextAlignmentCenter;
        password.text = @"密码";
        password.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        password.font = [UIFont systemFontOfSize:14];
        [self addSubview:password];
        [password mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line_imageview_two.mas_bottom).offset(20);
            make.width.mas_equalTo(50);
            make.left.equalTo(self).offset(30);
        }];
        
        _password_filed = [UITextField new];
        _password_filed.delegate = self;
        _password_filed.keyboardType = UIKeyboardTypeASCIICapable;
        _password_filed.secureTextEntry = true;
        _password_filed.placeholder = @"请填写您的密码";
        _password_filed.font = [UIFont systemFontOfSize:14];
        _password_filed.textAlignment = NSTextAlignmentCenter;
        _password_filed.textColor = TEXTCOLOR;
        [self addSubview:_password_filed];
        [_password_filed mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(password);
            make.left.equalTo(self).offset(90);
            make.right.equalTo(self).offset(-90);
            make.height.mas_equalTo(30);
        }];
        
        UIImageView *line_imageview_three = [UIImageView new];
        line_imageview_three.backgroundColor = Line_Color;
        [self addSubview:line_imageview_three];
        [line_imageview_three mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self->_password_filed.mas_bottom).offset(10);
            make.left.equalTo(self).offset(30);
            make.right.equalTo(self).offset(-30);
            make.height.mas_equalTo(1);
        }];
        
        _agree_but = [UIButton new];
        [_agree_but setBackgroundImage:[UIImage imageNamed:@"选择框"] forState:UIControlStateNormal];
        [self addSubview:_agree_but];
        [_agree_but mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line_imageview_three.mas_bottom).offset(12);
            make.left.equalTo(self).offset(30);
            make.size.mas_equalTo(CGSizeMake(14, 14));
        }];
        
        _already_lab = [UILabel new];
        _already_lab.font = [UIFont systemFontOfSize:14];
        _already_lab.textColor = TEXTCOLOR;
        _already_lab.text = @"我已注册并同意";
        [self addSubview:_already_lab];
        [_already_lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self->_agree_but);
            make.left.equalTo(self->_agree_but.mas_right).offset(5);
        }];
        
        _protocol_but = [UIButton new];
        [_protocol_but setTitle:@"《用户服务协议》" forState:UIControlStateNormal];
        [_protocol_but setTitleColor:[UIColor colorWithRed:61/255.0 green:144/255.0 blue:227/255.0 alpha:1.0] forState:UIControlStateNormal];
        _protocol_but.titleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_protocol_but];
        [_protocol_but mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self->_agree_but);
            make.left.equalTo(self.already_lab.mas_right);
            make.width.mas_equalTo(115);
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
            make.top.equalTo(self->_protocol_but.mas_bottom).offset(30);
            make.centerX.mas_equalTo(self);
            make.left.equalTo(self).offset(40);
            make.right.equalTo(self).offset(-40);
            make.height.mas_equalTo(35);
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
