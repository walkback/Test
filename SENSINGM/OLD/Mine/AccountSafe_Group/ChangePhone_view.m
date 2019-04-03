//
//  ChangePhone_view.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/6/15.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "ChangePhone_view.h"
#import "Macro.h"
#import <Masonry.h>

@implementation ChangePhone_view

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = Line_Color;
        UIView *headerview = [UIView new];
        [headerview.layer setCornerRadius:5];
        headerview.layer.masksToBounds = YES;
        headerview.backgroundColor = [UIColor whiteColor];
        [self addSubview:headerview];
        if (KIsiPhoneX) {
            [headerview mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).offset(98);
                make.left.equalTo(self).offset(10);
                make.right.equalTo(self).offset(-10);
                make.height.mas_equalTo(91);
            }];
        } else {
            [headerview mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).offset(74);
                make.left.equalTo(self).offset(10);
                make.right.equalTo(self).offset(-10);
                make.height.mas_equalTo(91);
            }];
        }

        UIImageView *ID_image = [UIImageView new];
        ID_image.image = [UIImage imageNamed:@"phone"];
        [headerview addSubview:ID_image];
        [ID_image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headerview).offset(10);
            make.left.equalTo(headerview).offset(10);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
        
        self.phone_field = [UITextField new];
        self.phone_field.font = [UIFont systemFontOfSize:16];
        self.phone_field.placeholder = @"请输入手机号";
        self.phone_field.keyboardType = UIKeyboardTypeNumberPad;
        self.phone_field.textColor = [UIColor blackColor];
        [headerview addSubview:self.phone_field];
        [self.phone_field mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(ID_image);
            make.left.equalTo(ID_image.mas_right).offset(10);
            make.right.equalTo(headerview);
            make.height.mas_equalTo(30);
        }];
        
        UIImageView *lineimage1 = [UIImageView new];
        lineimage1.backgroundColor = Line_Color;
        [headerview addSubview:lineimage1];
        [lineimage1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ID_image.mas_bottom).offset(10);
            make.left.right.equalTo(headerview);
            make.height.mas_equalTo(1);
        }];
        
        UIImageView *password_image = [UIImageView new];
        password_image.image = [UIImage imageNamed:@"密码_u154"];
        [headerview addSubview:password_image];
        [password_image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lineimage1.mas_bottom).offset(10);
            make.centerX.mas_equalTo(ID_image);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];

        self.code_field = [UITextField new];
        self.code_field.keyboardType = UIKeyboardTypeNumberPad;
        self.code_field.font = [UIFont systemFontOfSize:16];
        self.code_field.placeholder = @"请输入验证码";
        self.code_field.textColor = [UIColor blackColor];
        [headerview addSubview:self.code_field];
        [self.code_field mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(password_image);
            make.left.equalTo(password_image.mas_right).offset(10);
            make.right.equalTo(headerview).offset(-100);
            make.height.mas_equalTo(30);
        }];
        
        self.code_button = [UIButton new];
        [self.code_button.layer setCornerRadius:3];
        self.code_button.layer.masksToBounds = YES;
        [self.code_button.layer setBorderWidth:1];
        [self.code_button.layer setBorderColor:[Default_Blue_Color CGColor]];
        [self.code_button setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.code_button setTitleColor:Default_Blue_Color forState:UIControlStateNormal];
        self.code_button.titleLabel.font = [UIFont systemFontOfSize:16];
        [headerview addSubview:self.code_button];
        [self.code_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(password_image);
            make.right.equalTo(headerview).offset(-5);
            make.size.mas_equalTo(CGSizeMake(100, 30));
        }];
        
//        UIImageView *lineimage2 = [UIImageView new];
//        lineimage2.backgroundColor = Line_Color;
//        [headerview addSubview:lineimage2];
//        [lineimage2 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(password_image.mas_bottom).offset(10);
//            make.left.right.equalTo(headerview);
//            make.height.mas_equalTo(1);
//        }];
//
//        UIImageView *password = [UIImageView new];
//        password.image = [UIImage imageNamed:@"密码_u154"];
//        [headerview addSubview:password];
//        [password mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(lineimage2.mas_bottom).offset(10);
//            make.centerX.mas_equalTo(ID_image);
//            make.size.mas_equalTo(CGSizeMake(25, 25));
//        }];
//
//        self.password_field = [UITextField new];
//        self.password_field.keyboardType = UIKeyboardTypeASCIICapable;
//        self.password_field.font = [UIFont systemFontOfSize:16];
//        self.password_field.placeholder = @"请输入登录密码";
//        self.password_field.secureTextEntry = YES;
//        self.password_field.textColor = [UIColor blackColor];
//        [headerview addSubview:self.password_field];
//        [self.password_field mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.mas_equalTo(password);
//            make.left.equalTo(password.mas_right).offset(10);
//            make.right.equalTo(headerview).offset(-100);
//            make.height.mas_equalTo(30);
//        }];

        UILabel *prompt_lab = [UILabel new];
        prompt_lab.numberOfLines = 0;
        prompt_lab.font = [UIFont systemFontOfSize:16];
        prompt_lab.textColor = [UIColor lightGrayColor];
        prompt_lab.text = @"提示：更改后，个人信息不变，下次用新的手机号登录";
        [self addSubview:prompt_lab];
        [prompt_lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headerview.mas_bottom).offset(20);
            make.left.equalTo(self).offset(10);
            make.right.equalTo(self);
        }];

        self.submit_button = [UIButton new];
        [self.submit_button setBackgroundColor:[UIColor colorWithRed:53/255.0 green:127/255.0  blue:218/255.0  alpha:0.5/1.0]];
        [self.submit_button setTitle:@"确定" forState:UIControlStateNormal];
        self.submit_button.titleLabel.font = [UIFont systemFontOfSize:18];
        [self.submit_button.layer setCornerRadius:3];
        self.submit_button.layer.masksToBounds = YES;
        [self addSubview:self.submit_button];
        [self.submit_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(prompt_lab.mas_bottom).offset(20);
            make.left.equalTo(self).offset(20);
            make.right.equalTo(self).offset(-20);
            make.height.mas_equalTo(40);
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
