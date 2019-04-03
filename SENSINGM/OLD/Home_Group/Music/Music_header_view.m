//
//  Music_header_view.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/6/20.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "Music_header_view.h"
#import "Macro.h"
#import <Masonry.h>

@implementation Music_header_view

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.imageView = [UIImageView new];
        [self.imageView.layer setCornerRadius:3];
        self.imageView.layer.masksToBounds = YES;
        [self addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self).offset(10);
            make.size.mas_equalTo(CGSizeMake(WIDTH / 3 , WIDTH / 3));
            make.bottom.equalTo(self).offset(-10);
        }];
        
        self.music_title_lab = [UILabel new];
        self.music_title_lab.font = [UIFont systemFontOfSize:18];
        self.music_title_lab.numberOfLines = 0;
        [self addSubview:self.music_title_lab];
        [self.music_title_lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imageView.mas_right).offset(20);
            make.top.equalTo(self).offset(10);
            make.right.equalTo(self).offset(-10);
        }];
        
        self.detail_label = [UILabel new];
        self.detail_label.font = [UIFont systemFontOfSize:14];
        self.detail_label.textColor = [UIColor grayColor];
        self.detail_label.numberOfLines = 0;
        [self addSubview:self.detail_label];
        [self.detail_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imageView.mas_right).offset(20);
            make.top.equalTo(self.music_title_lab.mas_bottom).offset(10);
            make.right.equalTo(self).offset(-10);
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
