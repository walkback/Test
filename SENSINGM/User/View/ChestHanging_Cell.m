//
//  ChestHanging_Cell.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/12/12.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "ChestHanging_Cell.h"

@implementation ChestHanging_Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor colorWithRed:239/255.0 green:242/255.0 blue:245/255.0 alpha:1.0];
        
        UIView *content_view = [UIView new];
        content_view.backgroundColor = UIColor.whiteColor;
        [content_view.layer setCornerRadius:4];
        content_view.layer.masksToBounds = true;
        [self.contentView addSubview:content_view];
        [content_view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(-15);
        }];
        
        _device_imagev = [UIImageView new];
        [content_view addSubview:_device_imagev];
        [_device_imagev mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(content_view).offset(15);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        
        _switch_but = [UIButton new];
        [_switch_but.layer setCornerRadius:10];
        _switch_but.layer.masksToBounds = true;
        [_switch_but setBackgroundImage:[UIImage imageNamed:@"关"] forState:UIControlStateNormal];
        [content_view addSubview:_switch_but];
        [_switch_but mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(content_view).offset(15);
            make.right.equalTo(content_view).offset(-35);
            make.size.mas_equalTo(CGSizeMake(40, 25));
        }];
        
        _device_name_lab = [UILabel new];
        _device_name_lab.font = [UIFont systemFontOfSize:16];
        _device_name_lab.textColor = TEXTCOLOR;
        [content_view addSubview:_device_name_lab];
        [_device_name_lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self->_switch_but);
            make.left.equalTo(self->_device_imagev.mas_right).offset(16);
            make.right.equalTo(self->_switch_but.mas_left);
            make.top.equalTo(content_view).offset(19);
        }];
        
        _electricity_lab = [UILabel new];
        _electricity_lab.textAlignment = NSTextAlignmentCenter;
        _electricity_lab.font = [UIFont systemFontOfSize:14];
        _electricity_lab.textColor = TEXTCOLOR;
        [content_view addSubview:_electricity_lab];
        [_electricity_lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self->_switch_but);
            make.top.equalTo(self->_switch_but.mas_bottom).offset(8);
            make.width.mas_equalTo(80);
        }];
        
        _device_data_lab = [UILabel new];
        _device_data_lab.font = [UIFont systemFontOfSize:14];
        _device_data_lab.textColor = TEXTCOLOR;
        [content_view addSubview:_device_data_lab];
        [_device_data_lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self->_electricity_lab);
            make.right.equalTo(self->_electricity_lab.mas_left);
            make.left.equalTo(self->_device_imagev.mas_right).offset(15);
        }];
        
        UIImageView *line_imageview = [UIImageView new];
        line_imageview.backgroundColor = Line_Color;
        [self.contentView addSubview:line_imageview];
        [line_imageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self->_device_imagev.mas_bottom).offset(20);
            make.left.right.equalTo(content_view);
            make.height.mas_equalTo(1);
            make.bottom.equalTo(content_view).offset(-44);
        }];
        
        _sun_imagev = [UIImageView new];
        _sun_imagev.image = [UIImage imageNamed:@"亮度"];
        [content_view addSubview:_sun_imagev];
        
        _greenLeaf_imagev = [UIImageView new];
        _greenLeaf_imagev.image = [UIImage imageNamed:@"生理"];
        [content_view addSubview:_greenLeaf_imagev];
        
        _ev_imagev = [UIImageView new];
        _ev_imagev.image = [UIImage imageNamed:@"UV"];
        [content_view addSubview:_ev_imagev];
        
        _step_imagev = [UIImageView new];
        _step_imagev.image = [UIImage imageNamed:@"记步"];
        [content_view addSubview:_step_imagev];
        
        // 实现masonry水平固定间隔方法
        [@[_sun_imagev,_greenLeaf_imagev,_ev_imagev,_step_imagev] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal
                        withFixedSpacing:(WIDTH - 71 - 30) / 4
                             leadSpacing:7
                             tailSpacing:(WIDTH - 71 - 30) / 4];
        // 设置array的垂直方向的约束
        [@[_sun_imagev,_greenLeaf_imagev,_ev_imagev,_step_imagev] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line_imageview.mas_bottom).offset(15);
            make.size.mas_equalTo(CGSizeMake(16, 16));
        }];
        
        _suncount_lab = [UILabel new];
        _suncount_lab.font = [UIFont systemFontOfSize:14];
        _suncount_lab.textColor = TEXTCOLOR;
        [content_view addSubview:_suncount_lab];
        [_suncount_lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self->_sun_imagev).offset(-8);
            make.left.equalTo(self->_sun_imagev.mas_right).offset(6);
            make.right.equalTo(self->_greenLeaf_imagev.mas_left);
        }];
        
        _healthvalue_lab = [UILabel new];
        _healthvalue_lab.font = [UIFont systemFontOfSize:14];
        _healthvalue_lab.textColor = TEXTCOLOR;
        [content_view addSubview:_healthvalue_lab];
        [_healthvalue_lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self->_greenLeaf_imagev).offset(-8);
            make.left.equalTo(self->_greenLeaf_imagev.mas_right).offset(6);
            make.right.equalTo(self->_ev_imagev.mas_left);
        }];
        
        _evcount_lab = [UILabel new];
        _evcount_lab.font = [UIFont systemFontOfSize:14];
        _evcount_lab.textColor = TEXTCOLOR;
        [content_view addSubview:_evcount_lab];
        [_evcount_lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self->_ev_imagev).offset(-8);
            make.left.equalTo(self->_ev_imagev.mas_right).offset(6);
            make.right.equalTo(self->_step_imagev.mas_left);
        }];
        
        _stepcount_lab = [UILabel new];
        _stepcount_lab.font = [UIFont systemFontOfSize:14];
        _stepcount_lab.textColor = TEXTCOLOR;
        [content_view addSubview:_stepcount_lab];
        [_stepcount_lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self->_step_imagev).offset(-8);
            make.left.equalTo(self->_step_imagev.mas_right).offset(6);
            make.right.equalTo(content_view);
        }];
        
        // 更新
        _suncount_update_lab = [UILabel new];
        _suncount_update_lab.font = [UIFont systemFontOfSize:12];
        _suncount_update_lab.textColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0];
        [content_view addSubview:_suncount_update_lab];
        [_suncount_update_lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self->_sun_imagev).offset(7);
            make.left.equalTo(self->_sun_imagev.mas_right).offset(6);
            make.right.equalTo(self->_greenLeaf_imagev.mas_left);
        }];
        
        _healthvalue_update_lab = [UILabel new];
        _healthvalue_update_lab.font = [UIFont systemFontOfSize:12];
        _healthvalue_update_lab.textColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0];
        [content_view addSubview:_healthvalue_update_lab];
        [_healthvalue_update_lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self->_greenLeaf_imagev).offset(7);
            make.left.equalTo(self->_greenLeaf_imagev.mas_right).offset(6);
            make.right.equalTo(self->_ev_imagev.mas_left);
        }];
        
        _evcount_update_lab = [UILabel new];
        _evcount_update_lab.font = [UIFont systemFontOfSize:12];
        _evcount_update_lab.textColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0];
        [content_view addSubview:_evcount_update_lab];
        [_evcount_update_lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self->_ev_imagev).offset(7);
            make.left.equalTo(self->_ev_imagev.mas_right).offset(6);
            make.right.equalTo(self->_step_imagev.mas_left);
        }];
        
        _stepcount_update_lab = [UILabel new];
        _stepcount_update_lab.font = [UIFont systemFontOfSize:12];
        _stepcount_update_lab.textColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0];
        [content_view addSubview:_stepcount_update_lab];
        [_stepcount_update_lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self->_step_imagev).offset(7);
            make.left.equalTo(self->_step_imagev.mas_right).offset(6);
            make.right.equalTo(content_view);
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
