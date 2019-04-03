//
//  UserManagement_Cell.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/12/12.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "UserManagement_Cell.h"

@implementation UserManagement_Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor colorWithRed:239/255.0 green:242/255.0 blue:245/255.0 alpha:1.0];
        
        UIView *content_view = [UIView new];
        content_view.backgroundColor = UIColor.whiteColor;
        [content_view.layer setCornerRadius:5];
        content_view.layer.masksToBounds = true;
        [self.contentView addSubview:content_view];
        [content_view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(-15);
            make.height.mas_equalTo(44);
        }];
        
        _user_name_lab = [UILabel new];
        _user_name_lab.font = [UIFont systemFontOfSize:15];
        _user_name_lab.textColor = TEXTCOLOR;
        _user_name_lab.textAlignment = NSTextAlignmentCenter;
        [content_view addSubview:_user_name_lab];
        [_user_name_lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(content_view);
            make.left.right.equalTo(content_view);
        }];
        
        _delete_but = [UIButton new];
        [_delete_but setBackgroundImage:[UIImage imageNamed:@"删除"] forState:UIControlStateNormal];
        [content_view addSubview:_delete_but];
        [_delete_but mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(content_view);
            make.size.mas_equalTo(CGSizeMake(16, 16));
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
