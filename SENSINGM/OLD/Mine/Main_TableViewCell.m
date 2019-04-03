//
//  Main_TableViewCell.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/6/15.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "Main_TableViewCell.h"
#import <Masonry.h>

@implementation Main_TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.set_content = [UILabel new];
        self.set_content.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:self.set_content];
        [self.set_content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(30);
        }];
        
        self.wifi_name = [UILabel new];
        [self.contentView addSubview:self.wifi_name];
        [self.wifi_name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.set_content.mas_right);
            make.right.equalTo(self.contentView);
            make.centerY.mas_equalTo(self.set_content);
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
