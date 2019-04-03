//
//  Equipment_TableViewCell.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/6/15.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "Equipment_TableViewCell.h"
#import "Macro.h"
#import <Masonry.h>

@implementation Equipment_TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.photo_image = [UIImageView new];
        [self.contentView addSubview:self.photo_image];
        [self.photo_image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(20);
            make.size.mas_equalTo(CGSizeMake(50, 50));
            make.left.equalTo(self.contentView).offset(38);
            make.bottom.equalTo(self.contentView).offset(-20);
        }];

        self.equipment_typename_lab = [UILabel new];
        self.equipment_typename_lab.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:self.equipment_typename_lab];
        [self.equipment_typename_lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.photo_image);
            make.left.equalTo(self.photo_image.mas_right).offset(10);
            make.right.equalTo(self.contentView).offset(-100);
        }];

        self.equipment_location_lab = [UILabel new];
        self.equipment_location_lab.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:self.equipment_location_lab];
        [self.equipment_location_lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.photo_image);
            make.left.equalTo(self.photo_image.mas_right).offset(10);
            make.right.equalTo(self.contentView);
        }];
        
        self.switch_but = [UISwitch new];
        [self.switch_but setOnTintColor:Default_Blue_Color];
        self.switch_but.transform = CGAffineTransformMakeScale(0.7, 0.7);
        [self.contentView addSubview:self.switch_but];
        [self.switch_but mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.equipment_typename_lab);
            make.right.equalTo(self.contentView).offset(-20);
        }];
        
        self.defaut_device_but = [UIButton new];
        self.defaut_device_but.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.defaut_device_but setTitle:@"默认设备" forState:UIControlStateNormal];
        [self.defaut_device_but setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.contentView addSubview:self.defaut_device_but];
        [self.defaut_device_but mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.equipment_location_lab);
            make.right.equalTo(self.contentView).offset(-20);
            make.size.mas_equalTo(CGSizeMake(80, 20));
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
