//
//  AddAlarmClock_TableViewCell.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/7/9.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "AddAlarmClock_TableViewCell.h"

@implementation AddAlarmClock_TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.name_label = [UILabel new];
        self.name_label.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:self.name_label];
        [self.name_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(10);
        }];
        
        self.detail_label = [UILabel new];
        self.detail_label.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:self.detail_label];
        [self.detail_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.name_label.mas_right);
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
