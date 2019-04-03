//
//  SystemScenario_Cell.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/12/17.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "SystemScenario_Cell.h"

@implementation SystemScenario_Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _bg_imagev = [UIImageView new];
        [self.contentView addSubview:_bg_imagev];
        [_bg_imagev mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(WIDTH * 0.48);
        }];
        
        UIImageView *shadow_imagev = [UIImageView new];
        shadow_imagev.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
        [self.contentView addSubview:shadow_imagev];
        [shadow_imagev mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(20);
        }];
        
        _switch_but = [UIButton new];
        [_switch_but setBackgroundImage:[UIImage imageNamed:@"关"] forState:UIControlStateNormal];
        [self.contentView addSubview:_switch_but];
        [_switch_but mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(-15);
            make.size.mas_equalTo(CGSizeMake(35, 20));
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
