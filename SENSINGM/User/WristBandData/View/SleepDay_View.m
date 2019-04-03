//
//  SleepDay_View.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/12/14.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "SleepDay_View.h"

@implementation SleepDay_View

- (instancetype)init {
    if (self = [super init]) {
        _left_but = [UIButton new];
        [_left_but setBackgroundImage:[UIImage imageNamed:@"退出"] forState:UIControlStateNormal];
        [self addSubview:_left_but];
        [_left_but mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(10);
            make.left.equalTo(self).offset(15);
            make.size.mas_equalTo(CGSizeMake(18, 18));
        }];
        
        _right_but = [UIButton new];
        [_right_but setBackgroundImage:[UIImage imageNamed:@"前进"] forState:UIControlStateNormal];
        [self addSubview:_right_but];
        [_right_but mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(10);
            make.right.equalTo(self).offset(-15);
            make.size.mas_equalTo(CGSizeMake(18, 18));
        }];
        
        _date_lab = [UILabel new];
        _date_lab.textAlignment = NSTextAlignmentCenter;
        _date_lab.font = [UIFont systemFontOfSize:12];
        _date_lab.textColor = TEXTCOLOR;
        [self addSubview:_date_lab];
        [_date_lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.centerY.mas_equalTo(self->_left_but);
            make.left.equalTo(self->_left_but.mas_right).offset(10);
            make.right.equalTo(self->_right_but.mas_left).offset(-10);
        }];
        
        // 深睡
        UIImageView *deepSleeping = [UIImageView new];
        [deepSleeping.layer setCornerRadius:4];
        deepSleeping.layer.masksToBounds = true;
        deepSleeping.backgroundColor = [UIColor colorWithRed:128/255.0 green:28/255.0 blue:230/255.0 alpha:1.0];
        [self addSubview:deepSleeping];
        [deepSleeping mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self->_date_lab.mas_bottom).offset(20);
            make.left.equalTo(self).offset(15);
            make.size.mas_equalTo(CGSizeMake(8, 8));
        }];
        
        UILabel *deepSleeping_lab = [UILabel new];
        deepSleeping_lab.text = @"深睡";
        deepSleeping_lab.font = [UIFont systemFontOfSize:12];
        deepSleeping_lab.textColor = TEXTCOLOR;
        [self addSubview:deepSleeping_lab];
        [deepSleeping_lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(deepSleeping);
            make.left.equalTo(deepSleeping.mas_right).offset(6);
            make.width.mas_equalTo(25);
        }];
        
        // 浅睡
        UIImageView *shallowSleeping = [UIImageView new];
        [shallowSleeping.layer setCornerRadius:4];
        shallowSleeping.layer.masksToBounds = true;
        shallowSleeping.backgroundColor = [UIColor colorWithRed:151/255.0 green:73/255.0 blue:230/255.0 alpha:1.0];
        [self addSubview:shallowSleeping];
        [shallowSleeping mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(deepSleeping);
            make.left.equalTo(deepSleeping_lab.mas_right).offset(14);
            make.size.mas_equalTo(CGSizeMake(8, 8));
        }];
        
        UILabel *shallowSleeping_lab = [UILabel new];
        shallowSleeping_lab.text = @"浅睡";
        shallowSleeping_lab.font = [UIFont systemFontOfSize:12];
        shallowSleeping_lab.textColor = TEXTCOLOR;
        [self addSubview:shallowSleeping_lab];
        [shallowSleeping_lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(deepSleeping);
            make.left.equalTo(shallowSleeping.mas_right).offset(6);
            make.width.mas_equalTo(25);
        }];
        
        // 睡眠时长
        UILabel *sleepTime = [UILabel new];
        sleepTime.text = @"睡眠时长";
        sleepTime.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
        sleepTime.font = [UIFont systemFontOfSize:12];
        [self addSubview:sleepTime];
        [sleepTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(deepSleeping_lab.mas_bottom).offset(20);
            make.left.equalTo(self).offset(15);
            make.width.mas_equalTo(60);
        }];
        
        _sleepTime_lab = [UILabel new];
        _sleepTime_lab.font = [UIFont systemFontOfSize:25];
        _sleepTime_lab.textColor = [UIColor colorWithRed:128/255.0 green:28/255.0 blue:230/255.0 alpha:1.0];
        [self addSubview:_sleepTime_lab];
        [_sleepTime_lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(sleepTime.mas_bottom).offset(10);
            make.left.equalTo(self).offset(15);
            make.width.mas_equalTo(140);
        }];
        
        // 开始
        UILabel *start = [UILabel new];
        start.text = @"开始";
        start.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
        start.font = [UIFont systemFontOfSize:12];
        [self addSubview:start];
        [start mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self->_sleepTime_lab.mas_bottom).offset(10);
            make.left.equalTo(self).offset(15);
            make.width.mas_equalTo(30);
        }];
        
        _startTime_lab = [UILabel new];
        _startTime_lab.font = [UIFont systemFontOfSize:12];
        _startTime_lab.textColor = [UIColor colorWithRed:128/255.0 green:28/255.0 blue:230/255.0 alpha:1.0];
        [self addSubview:_startTime_lab];
        [_startTime_lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(start.mas_bottom).offset(5);
            make.left.equalTo(self).offset(15);
            make.width.mas_equalTo(50);
        }];
        
        // 结束
        UILabel *end = [UILabel new];
        end.text = @"开始";
        end.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
        end.font = [UIFont systemFontOfSize:12];
        [self addSubview:end];
        [end mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self->_startTime_lab.mas_bottom).offset(10);
            make.left.equalTo(self).offset(15);
            make.width.mas_equalTo(30);
        }];
        
        _endTime_lab = [UILabel new];
        _endTime_lab.font = [UIFont systemFontOfSize:12];
        _endTime_lab.textColor = [UIColor colorWithRed:128/255.0 green:28/255.0 blue:230/255.0 alpha:1.0];
        [self addSubview:_endTime_lab];
        [_endTime_lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(end.mas_bottom).offset(5);
            make.left.equalTo(self).offset(15);
            make.width.mas_equalTo(50);
        }];
        
        
        // 深睡时长 浅睡时长 质量
        _deepsleepTime_lab = [UILabel new];
        _deepsleepTime_lab.textAlignment = NSTextAlignmentCenter;
        _deepsleepTime_lab.font = [UIFont systemFontOfSize:25];
        _deepsleepTime_lab.textColor = [UIColor colorWithRed:128/255.0 green:28/255.0 blue:230/255.0 alpha:1.0];
        [self addSubview:_deepsleepTime_lab];
        
        _shallowTime_lab = [UILabel new];
        _shallowTime_lab.textAlignment = NSTextAlignmentCenter;
        _shallowTime_lab.font = [UIFont systemFontOfSize:25];
        _shallowTime_lab.textColor = [UIColor colorWithRed:128/255.0 green:28/255.0 blue:230/255.0 alpha:1.0];
        [self addSubview:_shallowTime_lab];
        
        _quality_lab = [UILabel new];
        _quality_lab.textAlignment = NSTextAlignmentCenter;
        _quality_lab.font = [UIFont systemFontOfSize:25];
        _quality_lab.textColor = [UIColor colorWithRed:128/255.0 green:28/255.0 blue:230/255.0 alpha:1.0];
        [self addSubview:_quality_lab];
        
        // 实现masonry水平固定间隔方法
        [@[_deepsleepTime_lab,_shallowTime_lab,_quality_lab] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
        // 设置array的垂直方向的约束
        [@[_deepsleepTime_lab,_shallowTime_lab,_quality_lab] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self->_endTime_lab.mas_bottom).offset(25);
            make.width.mas_equalTo((WIDTH - 30) / 3);
        }];
        
        UILabel *deepsleepTime = [UILabel new];
        deepsleepTime.text = @"深睡";
        deepsleepTime.textAlignment = NSTextAlignmentCenter;
        deepsleepTime.font = [UIFont systemFontOfSize:12];
        deepsleepTime.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
        [self addSubview:deepsleepTime];
        
        UILabel *shallowTime = [UILabel new];
        shallowTime.text = @"浅睡";
        shallowTime.textAlignment = NSTextAlignmentCenter;
        shallowTime.font = [UIFont systemFontOfSize:12];
        shallowTime.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
        [self addSubview:shallowTime];
        
        UILabel *quality = [UILabel new];
        quality.text = @"睡眠质量";
        quality.textAlignment = NSTextAlignmentCenter;
        quality.font = [UIFont systemFontOfSize:12];
        quality.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
        [self addSubview:quality];
        
        // 实现masonry水平固定间隔方法
        [@[deepsleepTime,shallowTime,quality] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
        // 设置array的垂直方向的约束
        [@[deepsleepTime,shallowTime,quality] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self->_quality_lab.mas_bottom).offset(10);
            make.width.mas_equalTo((WIDTH - 30) / 3);
            make.bottom.equalTo(self).offset(-15);
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
