//
//  HeartRateData_View.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/12/14.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "HeartRateData_View.h"

@implementation HeartRateData_View


- (instancetype)init {
    if (self = [super init]) {
        _heart_imagev = [UIImageView new];
        [_heart_imagev.layer setCornerRadius:70];
        _heart_imagev.layer.masksToBounds = true;
        [_heart_imagev.layer setBorderWidth:2];
        [_heart_imagev.layer setBorderColor:[UIColor colorWithRed:239/255.0 green:242/255.0 blue:245/255.0 alpha:1.0].CGColor];
        [self addSubview:_heart_imagev];
        [_heart_imagev mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(20);
            make.centerX.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(140, 140));
        }];
        
        _result_lab = [UILabel new];
        _result_lab.textAlignment = NSTextAlignmentCenter;
        _result_lab.font = [UIFont systemFontOfSize:50];
        _result_lab.textColor = UIColor.whiteColor;
        [_heart_imagev addSubview:_result_lab];
        [_result_lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self->_heart_imagev);
            make.left.right.equalTo(self->_heart_imagev);
        }];
        
        UILabel *result = [UILabel new];
        result.text = @"上次测量结果";
        result.textAlignment = NSTextAlignmentCenter;
        result.font = [UIFont systemFontOfSize:12];
        result.textColor = TEXTCOLOR;
        [_heart_imagev addSubview:result];
        [result mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self->_result_lab.mas_bottom);
            make.left.right.equalTo(self->_heart_imagev);
        }];
        
        
        UILabel *height = [UILabel new];
        height.text = @"最高:";
        height.font = [UIFont systemFontOfSize:12];
        height.textColor = TEXTCOLOR;
        [self addSubview:height];
        [height mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self->_heart_imagev.mas_bottom).offset(30);
            make.left.equalTo(self).offset(20);
            make.width.mas_equalTo(30);
            make.bottom.equalTo(self).offset(-15);
        }];
        
        _height_lat = [UILabel new];
        _height_lat.font = [UIFont systemFontOfSize:20];
        _height_lat.textColor = UIColor.whiteColor;
        [self addSubview:_height_lat];
        [_height_lat mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(height);
            make.left.equalTo(height.mas_right).offset(6);
            make.width.mas_equalTo(25);
        }];
        
        UILabel *times = [UILabel new];
        times.text = @"次/分";
        times.font = [UIFont systemFontOfSize:12];
        times.textColor = TEXTCOLOR;
        [self addSubview:times];
        [times mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(height);
            make.left.equalTo(self->_height_lat.mas_right).offset(6);
            make.width.mas_equalTo(30);
        }];
        
        
        UILabel *low_times = [UILabel new];
        low_times.text = @"次/分";
        low_times.font = [UIFont systemFontOfSize:12];
        low_times.textColor = TEXTCOLOR;
        [self addSubview:low_times];
        [low_times mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(height);
            make.right.equalTo(self).offset(-20);
            make.width.mas_equalTo(30);
        }];
        
        _low_lat = [UILabel new];
        _low_lat.font = [UIFont systemFontOfSize:20];
        _low_lat.textColor = UIColor.whiteColor;
        [self addSubview:_low_lat];
        [_low_lat mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(low_times);
            make.right.equalTo(low_times.mas_left).offset(-6);
            make.width.mas_equalTo(25);
        }];
        
        UILabel *low = [UILabel new];
        low.text = @"最高:";
        low.font = [UIFont systemFontOfSize:12];
        low.textColor = TEXTCOLOR;
        [self addSubview:low];
        [low mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(height);
            make.right.equalTo(self->_low_lat.mas_left).offset(-6);
            make.width.mas_equalTo(30);
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
