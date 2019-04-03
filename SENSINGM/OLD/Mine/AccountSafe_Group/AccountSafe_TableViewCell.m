//
//  AccountSafe_TableViewCell.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/6/15.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "AccountSafe_TableViewCell.h"
#import <Masonry.h>

@implementation AccountSafe_TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.change_lab = [UILabel new];
        self.change_lab.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:self.change_lab];
        [self.change_lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(30);
        }];
        
        self.phone_lab = [UILabel new];
        self.phone_lab.font = [UIFont systemFontOfSize:16];
        self.phone_lab.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.phone_lab];
        [self.phone_lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView);
            make.left.equalTo(self.change_lab.mas_right);
            make.right.equalTo(self.contentView).offset(-20);
        }];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
