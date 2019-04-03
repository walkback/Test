//
//  Address_TableViewCell.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/6/16.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "Address_TableViewCell.h"
#import "Macro.h"
#import <Masonry.h>

@implementation Address_TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    
        self.address_lab = [UILabel new];
        self.address_lab.textAlignment = NSTextAlignmentLeft;
        self.address_lab.backgroundColor = Line_Color;
        self.address_lab.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:self.address_lab];
        [self.address_lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(12);
            make.left.equalTo(self.contentView).offset(100);
            make.right.equalTo(self.contentView).offset(10);
            make.height.mas_equalTo(40);
        }];
        
        self.header_label = [UILabel new];
        self.header_label.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:self.header_label];
        [self.header_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.address_lab);
            make.left.equalTo(self.contentView).offset(20);
            make.size.mas_equalTo(CGSizeMake(76.375, 19.5));
        }];
        
        self.address_detail = [UITextView new];
        self.address_detail.delegate = self;
        self.address_detail.textAlignment = NSTextAlignmentLeft;
        self.address_detail.backgroundColor = Line_Color;
        self.address_detail.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:self.address_detail];
        [self.address_detail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.address_lab.mas_bottom).offset(5);
            make.left.equalTo(self.contentView).offset(100);
            make.right.equalTo(self.contentView).offset(10);
            make.height.mas_equalTo(40);
            make.bottom.equalTo(self.contentView).offset(-20);
        }];
        
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
