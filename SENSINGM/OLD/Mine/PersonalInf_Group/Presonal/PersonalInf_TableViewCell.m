//
//  PersonalInf_TableViewCell.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/6/16.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "PersonalInf_TableViewCell.h"
#import "Macro.h"
#import <Masonry.h>

@implementation PersonalInf_TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.header_label = [UILabel new];
        self.header_label.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:self.header_label];
        [self.header_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(12);
            make.left.equalTo(self.contentView).offset(20);
            make.width.mas_equalTo(WIDTH / 2);
            make.bottom.equalTo(self.contentView).offset(-12);
        }];
        
        self.headportrait_image = [UIImageView new];
        [self.headportrait_image.layer setCornerRadius:20];
        self.headportrait_image.layer.masksToBounds = YES;
        [self.contentView addSubview:self.headportrait_image];
        [self.headportrait_image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.header_label);
            make.left.equalTo(self.header_label.mas_right);
            make.right.equalTo(self.contentView).offset(-10);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        
        self.detail_inf_lab = [UILabel new];
        self.detail_inf_lab.textAlignment = NSTextAlignmentRight;
        self.detail_inf_lab.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:self.detail_inf_lab];
        [self.detail_inf_lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-10);
            make.top.equalTo(self.contentView).offset(12);
            make.width.mas_equalTo(WIDTH / 2);
            make.bottom.equalTo(self.contentView).offset(-12);
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
