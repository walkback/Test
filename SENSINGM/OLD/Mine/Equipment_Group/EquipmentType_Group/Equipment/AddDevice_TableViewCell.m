//
//  AddDevice_TableViewCell.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/6/15.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "AddDevice_TableViewCell.h"
#import "Macro.h"
#import <Masonry.h>

@implementation AddDevice_TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.add_inf_lab = [UILabel new];
        self.add_inf_lab.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:self.add_inf_lab];
        [self.add_inf_lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.left.equalTo(self.contentView).offset(10);
            make.width.mas_equalTo(76.375);
        }];
        
        self.coding_field = [UITextField new];
        self.coding_field.hidden = YES;
        self.coding_field.placeholder = @"请输入设备编号";
        self.coding_field.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:self.coding_field];
        [self.coding_field mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView);
            make.left.equalTo(self.add_inf_lab.mas_right);
            make.right.equalTo(self.contentView);
        }];
        
        self.device_name_lab = [UILabel new];
        self.device_name_lab.hidden = YES;
        self.device_name_lab.textAlignment = NSTextAlignmentLeft;
        self.device_name_lab.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:self.device_name_lab];
        [self.device_name_lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView);
            make.left.equalTo(self.add_inf_lab.mas_right);
            make.right.equalTo(self.contentView);
        }];

        self.add_status = [UILabel new];
        self.add_status.hidden = YES;
        self.add_status.textAlignment = NSTextAlignmentRight;
        self.add_status.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:self.add_status];
        [self.add_status mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView);
            make.left.equalTo(self.add_inf_lab.mas_right);
            make.right.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
