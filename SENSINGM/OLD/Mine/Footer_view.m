//
//  Footer_view.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/7/11.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "Footer_view.h"

@implementation Footer_view

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor redColor];
        
        UIView *wifi_view = [UIView new];
        [wifi_view.layer setCornerRadius:10];
        wifi_view.layer.masksToBounds = YES;
        wifi_view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"圆角矩形6"]];
        [self addSubview:wifi_view];
        [wifi_view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(40);
            make.left.equalTo(self).offset(20);
            make.right.equalTo(self).offset(- (WIDTH / 2 + 5));
            make.height.mas_equalTo(WIDTH / 4 - 10);
        }];
        self.wifi_button = [UIButton new];
        [wifi_view addSubview:self.wifi_button];
        [self.wifi_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(wifi_view);
        }];
        self.wifi_label = [UILabel new];
        self.wifi_label.text = @"WLAN";
        self.wifi_label.font = [UIFont systemFontOfSize:14];
        [wifi_view addSubview:self.wifi_label];
        [self.wifi_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(wifi_view).offset(10);
            make.left.equalTo(wifi_view).offset(8);
        }];
        
        self.wifiname_label = [UILabel new];
        self.wifiname_label.font = [UIFont systemFontOfSize:14];
        [self.set_button addSubview:self.wifiname_label];
        [wifi_view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(wifi_view).offset(10);
            make.left.equalTo(wifi_view).offset(8);
        }];
        
        
        UIView *device_view = [UIView new];
        [device_view.layer setCornerRadius:10];
        device_view.layer.masksToBounds = YES;
        device_view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"圆角矩形6拷贝"]];
        [self addSubview:device_view];
        [device_view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(40);
            make.left.equalTo(self).offset(WIDTH / 2 + 5);
            make.right.equalTo(self).offset(-20);
            make.height.mas_equalTo(WIDTH / 4 - 10);
        }];
        self.device_button = [UIButton new];
        [device_view addSubview:self.device_button];
        [self.device_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(device_view);
        }];
        self.device_label = [UILabel new];
        self.device_label.text = @"我的设备";
        self.device_label.font = [UIFont systemFontOfSize:14];
        [device_view addSubview:self.device_label];
        [self.device_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(device_view).offset(10);
            make.left.equalTo(device_view).offset(8);
        }];
        
        UIView *accountSafe_view = [UIView new];
        [accountSafe_view.layer setCornerRadius:10];
        accountSafe_view.layer.masksToBounds = YES;
        accountSafe_view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"圆角矩形6拷贝2"]];
        [self addSubview:accountSafe_view];
        [accountSafe_view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(wifi_view.mas_bottom).offset(30);
            make.centerX.mas_equalTo(wifi_view);
            make.right.equalTo(self).offset(- (WIDTH / 2 + 5));
            make.height.mas_equalTo(WIDTH / 4 - 10);
        }];
        self.accountSafe_button = [UIButton new];
        [accountSafe_view addSubview:self.accountSafe_button];
        [self.accountSafe_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(accountSafe_view);
        }];
        self.accountSafe_label = [UILabel new];
        self.accountSafe_label.text = @"账号与安全";
        self.accountSafe_label.font = [UIFont systemFontOfSize:14];
        [accountSafe_view addSubview:self.accountSafe_label];
        [self.accountSafe_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(accountSafe_view).offset(10);
            make.left.equalTo(accountSafe_view).offset(8);
        }];
        
        UIView *set_view = [UIView new];
        [set_view.layer setCornerRadius:10];
        set_view.layer.masksToBounds = YES;
        set_view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"圆角矩形6拷贝2_62"]];
        [self addSubview:set_view];
        [set_view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(device_view.mas_bottom).offset(30);
            make.centerX.mas_equalTo(device_view);
            make.right.equalTo(self).offset(-20);
            make.height.mas_equalTo(WIDTH / 4 - 10);
        }];
        self.set_button = [UIButton new];
        [set_view addSubview:self.set_button];
        [self.set_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(set_view);
        }];
        self.set_label = [UILabel new];
        self.set_label.text = @"设置";
        self.set_label.font = [UIFont systemFontOfSize:14];
        [set_view addSubview:self.set_label];
        [self.set_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(set_view).offset(10);
            make.left.equalTo(set_view).offset(8);
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
