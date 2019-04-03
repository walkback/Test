//
//  ChooseWIFI_view.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/6/15.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "ChooseWIFI_view.h"
#import "Macro.h"
#import <Masonry.h>

@implementation ChooseWIFI_view

- (instancetype)init {
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView *imageview = [UIImageView new];
        imageview.image = [UIImage imageNamed:@"wifi-1"];
        [self addSubview:imageview];
        [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(40);
            make.centerX.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(80, 80));
        }];
        
        self.wifi_name_field = [UITextField new];
        self.wifi_name_field.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 0)];
        self.wifi_name_field.leftViewMode = UITextFieldViewModeAlways;
        self.wifi_name_field.font = [UIFont systemFontOfSize:18];
        [self.wifi_name_field.layer setCornerRadius:22];
        self.wifi_name_field.layer.masksToBounds = YES;
        [self.wifi_name_field.layer setBorderWidth:1];
        [self.wifi_name_field.layer setBorderColor:[Default_Blue_Color CGColor]];
        [self addSubview:self.wifi_name_field];
        [self.wifi_name_field mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageview.mas_bottom).offset(20);
            make.left.equalTo(self).offset(20);
            make.right.equalTo(self).offset(-20);
            make.height.mas_equalTo(44);
        }];
        
        self.wifi_password_field = [UITextField new];
        self.wifi_password_field.font = [UIFont systemFontOfSize:18];
        self.wifi_password_field.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 0)];
        self.wifi_password_field.leftViewMode = UITextFieldViewModeAlways;
        [self.wifi_password_field.layer setCornerRadius:22];
        self.wifi_password_field.layer.masksToBounds = YES;
        [self.wifi_password_field.layer setBorderWidth:1];
        [self.wifi_password_field.layer setBorderColor:[Default_Blue_Color CGColor]];
        [self addSubview:self.wifi_password_field];
        [self.wifi_password_field mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.wifi_name_field.mas_bottom).offset(20);
            make.left.equalTo(self).offset(20);
            make.right.equalTo(self).offset(-20);
            make.height.mas_equalTo(44);
        }];
        
        self.change_wifi_button = [UIButton new];
        [self.change_wifi_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.change_wifi_button setTitle:@"更换其他WI-FI" forState:UIControlStateNormal];
        self.change_wifi_button.titleLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.change_wifi_button];
        [self.change_wifi_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.wifi_password_field.mas_bottom).offset(20);
            make.right.equalTo(self).offset(-30);
            make.size.mas_equalTo(CGSizeMake(80, 14.5));
        }];
        
        self.connection_but = [UIButton new];
        [self.connection_but setBackgroundColor:Default_Blue_Color];
        [self.connection_but.layer setCornerRadius:22];
        self.connection_but.layer.masksToBounds = YES;
        [self.connection_but setTitle:@"连接" forState:UIControlStateNormal];
        [self addSubview:self.connection_but];
        [self.connection_but mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.wifi_password_field.mas_bottom).offset(50);
            make.left.equalTo(self).offset(20);
            make.right.equalTo(self).offset(-20);
            make.height.mas_equalTo(44);
            make.bottom.equalTo(self).offset(-90);
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
