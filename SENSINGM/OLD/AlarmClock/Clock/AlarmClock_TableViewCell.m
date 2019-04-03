//
//  AlarmClock_TableViewCell.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/7/9.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "AlarmClock_TableViewCell.h"

@implementation AlarmClock_TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.time_Label = [UILabel new];
        self.time_Label.font = [UIFont systemFontOfSize:32];
        [self.contentView addSubview:self.time_Label];
        [self.time_Label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(20);
        }];
        
        self.clockname_Label = [UILabel new];
//        self.clockname_Label.text = @"读书时间";
        self.clockname_Label.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:self.clockname_Label];
        [self.clockname_Label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.time_Label.mas_right).offset(10);
            make.bottom.equalTo(self.time_Label.mas_bottom).offset(-5);
        }];
        
        self.repeat_label = [UILabel new];
        self.repeat_label.textAlignment = NSTextAlignmentRight;
        self.repeat_label.textColor = Default_Blue_Color;
        self.repeat_label.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.repeat_label];
        [self.repeat_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-10);
            make.bottom.equalTo(self.contentView).offset(-10);
        }];
        
        self.switch_button = [UISwitch new];
        self.switch_button.transform = CGAffineTransformMakeScale(0.7, 0.7);
        [self.contentView addSubview:self.switch_button];
        [self.switch_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(10);
            make.right.equalTo(self.contentView).offset(-10);
        }];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
