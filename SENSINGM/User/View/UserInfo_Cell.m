//
//  UserInfo_Cell.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/12/12.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "UserInfo_Cell.h"

@implementation UserInfo_Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor colorWithRed:239/255.0 green:242/255.0 blue:245/255.0 alpha:1.0];
        
        _content_view = [UIView new];
        _content_view.backgroundColor = UIColor.whiteColor;
        [self.contentView addSubview:_content_view];
        [_content_view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(-15);
        }];
        
        _title_lab = [UILabel new];
        [_title_lab setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
        _title_lab.textColor = TEXTCOLOR;
        [_content_view addSubview:_title_lab];
        [_title_lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self->_content_view).offset(15);
            make.bottom.equalTo(self->_content_view).offset(-15);
            make.width.mas_equalTo(60);
        }];
        
        _push_but = [UIButton new];
        [_push_but setBackgroundImage:[UIImage imageNamed:@"右-箭头"] forState:UIControlStateNormal];
        [_content_view addSubview:_push_but];
        [_push_but mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self->_title_lab);
            make.right.equalTo(self->_content_view).offset(-9);
            make.size.mas_equalTo(CGSizeMake(10, 10));
        }];
        
        _content_lab = [UILabel new];
        _content_lab.textAlignment = NSTextAlignmentRight;
        _content_lab.font = [UIFont systemFontOfSize:14];
        _content_lab.textColor = [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1.0];
        [_content_view addSubview:_content_lab];
        [_content_lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self->_title_lab);
            make.right.equalTo(self->_push_but.mas_left).offset(-9);
            make.left.equalTo(self->_title_lab.mas_right).offset(9);
        }];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
