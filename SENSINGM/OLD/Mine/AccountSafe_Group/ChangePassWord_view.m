//
//  ChangePassWord_view.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/6/15.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "ChangePassWord_view.h"
#import "Macro.h"
#import <Masonry.h>

@implementation ChangePassWord_view

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
                make.height.mas_equalTo(137);
            }];
        } else {
            [headerview mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).offset(74);
                make.left.equalTo(self).offset(10);
                make.right.equalTo(self).offset(-10);
                make.height.mas_equalTo(137);
            }];
        }

        UIImageView *ID_image = [UIImageView new];
        ID_image.image = [UIImage imageNamed:@"密码_u154"];
        [headerview addSubview:ID_image];
        [ID_image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headerview).offset(10);
            make.left.equalTo(headerview).offset(10);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
        
        self.old_password = [UITextField new];
        self.old_password.font = [UIFont systemFontOfSize:16];
        self.old_password.secureTextEntry = YES;
        self.old_password.placeholder = @"请输入旧密码";
        self.old_password.keyboardType = UIKeyboardTypeASCIICapable;
        self.old_password.textColor = [UIColor blackColor];
        [headerview addSubview:self.old_password];
        [self.old_password mas_makeConstraints:^(MASConstraintMaker *make) {
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
        
        self.password_new = [UITextField new];
        self.password_new.secureTextEntry = YES;
        self.password_new.keyboardType = UIKeyboardTypeASCIICapable;
        self.password_new.font = [UIFont systemFontOfSize:16];
        self.password_new.placeholder = @"新密码(6-12位字母数字组合)";
        self.password_new.textColor = [UIColor blackColor];
        [headerview addSubview:self.password_new];
        [self.password_new mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(password_image);
            make.left.equalTo(password_image.mas_right).offset(10);
            make.right.equalTo(headerview);
            make.height.mas_equalTo(30);
        }];
 
        UIImageView *lineimage2 = [UIImageView new];
        lineimage2.backgroundColor = Line_Color;
        [headerview addSubview:lineimage2];
        [lineimage2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(password_image.mas_bottom).offset(10);
            make.left.right.equalTo(headerview);
            make.height.mas_equalTo(1);
        }];
        
        UIImageView *password = [UIImageView new];
        password.image = [UIImage imageNamed:@"密码_u154"];
        [headerview addSubview:password];
        [password mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lineimage2.mas_bottom).offset(10);
            make.centerX.mas_equalTo(ID_image);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
        
        self.password_again_new = [UITextField new];
        self.password_again_new.keyboardType = UIKeyboardTypeASCIICapable;
        self.password_again_new.font = [UIFont systemFontOfSize:16];
        self.password_again_new.placeholder = @"确认密码";
        self.password_again_new.secureTextEntry = YES;
        self.password_again_new.textColor = [UIColor blackColor];
        [headerview addSubview:self.password_again_new];
        [self.password_again_new mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(password);
            make.left.equalTo(password.mas_right).offset(10);
            make.right.equalTo(headerview).offset(-100);
            make.height.mas_equalTo(30);
        }];
                
        self.submit_button = [UIButton new];
        [self.submit_button setBackgroundColor:[UIColor colorWithRed:53/255.0 green:127/255.0  blue:218/255.0  alpha:0.5/1.0]];
        [self.submit_button setTitle:@"确定修改" forState:UIControlStateNormal];
        self.submit_button.titleLabel.font = [UIFont systemFontOfSize:18];
        [self.submit_button.layer setCornerRadius:3];
        self.submit_button.layer.masksToBounds = YES;
        [self addSubview:self.submit_button];
        [self.submit_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headerview.mas_bottom).offset(30);
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
