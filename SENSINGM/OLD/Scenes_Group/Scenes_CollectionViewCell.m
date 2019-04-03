//
//  Scenes_CollectionViewCell.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/6/21.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "Scenes_CollectionViewCell.h"
#import "Macro.h"
#import <Masonry.h>

@implementation Scenes_CollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.imageview = [UIImageView new];
//        self.imageview.image = [UIImage imageNamed:@"55"];
        [self.contentView addSubview:self.imageview];
        [self.imageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.centerX.mas_equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(80, 80));
        }];
        
        self.title_label = [UILabel new];
//        self.title_label.text = @"睡觉";
        self.title_label.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:self.title_label];
        [self.title_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
        }];
        
    }
    return self;
}

@end
