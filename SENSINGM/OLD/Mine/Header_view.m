//
//  Header_view.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/6/15.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "Header_view.h"
#import <Masonry.h>

@implementation Header_view

- (instancetype)init {
    if (self = [super init]) {
        
        self.headportrait_button = [UIButton new];
        [self.headportrait_button setImage:[UIImage imageNamed:@"2"] forState:UIControlStateNormal];
        [self.headportrait_button.layer setCornerRadius:40];
        self.headportrait_button.layer.masksToBounds = YES;
        [self addSubview:self.headportrait_button];
        [self.headportrait_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(50);
            make.centerX.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(80, 80));
        }];
        
        self.nickname_lab = [UILabel new];
        self.nickname_lab.textAlignment = NSTextAlignmentCenter;
        self.nickname_lab.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.5];
        self.nickname_lab.textColor = [UIColor whiteColor];
        self.nickname_lab.font = [UIFont systemFontOfSize:14];
        [self.nickname_lab.layer setCornerRadius:15];
        self.nickname_lab.layer.masksToBounds = YES;
        [self addSubview:self.nickname_lab];
        [self.nickname_lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.top.equalTo(self.headportrait_button.mas_bottom).offset(20);
            make.size.mas_equalTo(CGSizeMake(80, 30));
        }];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
