//
//  StepDay_View.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/12/13.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "StepDay_View.h"

@implementation StepDay_View

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
        
        UIView *data_view = [UIView new];
        data_view.backgroundColor = UIColor.whiteColor;
        [self addSubview:data_view];
        [data_view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self->_date_lab.mas_bottom).offset(10);
            make.left.equalTo(self).offset(15);
            make.right.equalTo(self).offset(-15);
            make.height.mas_equalTo(150);
        }];
        
        _totalDistance_lab = [UILabel new];
        _totalDistance_lab.font = [UIFont systemFontOfSize:25];
        _totalDistance_lab.textColor = [UIColor colorWithRed:26/255.0 green:128/255.0 blue:255/255.0 alpha:1.0];
        [self addSubview:_totalDistance_lab];
        
        _totalNumber_lab = [UILabel new];
        _totalNumber_lab.textAlignment = NSTextAlignmentRight;
        _totalNumber_lab.font = [UIFont systemFontOfSize:25];
        _totalNumber_lab.textColor = [UIColor colorWithRed:26/255.0 green:128/255.0 blue:255/255.0 alpha:1.0];
        [self addSubview:_totalNumber_lab];
        
        // 实现masonry水平固定间隔方法
        [@[_totalDistance_lab,_totalNumber_lab] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
        // 设置array的垂直方向的约束
        [@[_totalDistance_lab,_totalNumber_lab] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(data_view.mas_bottom).offset(25);
            make.width.mas_equalTo((WIDTH - 30) / 2);
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
