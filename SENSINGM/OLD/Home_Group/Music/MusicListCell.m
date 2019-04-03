//
//  MusicListCell.m
//  SENSINGM
//
//  Created by apple on 2018/7/12.
//  Copyright © 2018年 吴志刚. All rights reserved.
//

#import "MusicListCell.h"

@implementation MusicListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.musicNameLable = [[UILabel  alloc]init];
        self.musicNameLable.textColor = RGB(81, 81, 81);
        self.musicNameLable.textAlignment = NSTextAlignmentLeft;
        self.musicNameLable.font = [UIFont systemFontOfSize:14];
        [self.contentView  addSubview:self.musicNameLable];
        [self.musicNameLable  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.width.offset(200);
            make.top.equalTo(self).offset(12);
            make.height.mas_equalTo(20);
        }];
        
        
        self.musicOpenButton = [UIButton   buttonWithType:UIButtonTypeCustom];
        [self.contentView  addSubview:self.musicOpenButton];
        [self.musicOpenButton  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-10);
            make.width.offset(44);
            make.top.equalTo(self).offset(0);
            make.height.mas_equalTo(44);
        }];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
