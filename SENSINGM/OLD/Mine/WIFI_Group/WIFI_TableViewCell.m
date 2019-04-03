//
//  WIFI_TableViewCell.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/6/15.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "WIFI_TableViewCell.h"
#import <Masonry.h>

@implementation WIFI_TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.wifi_name_lab = [UILabel new];
        self.wifi_name_lab.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.wifi_name_lab];
        [self.wifi_name_lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(10);
            make.right.equalTo(self.contentView).offset(-100);
        }];
        
        UIImageView *selectimage = [UIImageView new];
        selectimage.image = [UIImage imageNamed:@"右箭头 (1)"];
        [self.contentView addSubview:selectimage];
        [selectimage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-20);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
        
        self.wifi_signal = [UIImageView new];
        [self.contentView addSubview:self.wifi_signal];
        [self.wifi_signal mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView);
            make.right.equalTo(selectimage.mas_left);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
