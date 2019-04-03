//
//  AddDevice_view.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/6/15.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "AddDevice_view.h"
#import "Macro.h"
#import <Masonry.h>

@implementation AddDevice_view

- (instancetype)init {
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
//        self.headportrait_image = [UIImageView new];
//        self.headportrait_image.image = [UIImage imageNamed:@"444"];
//        [self addSubview:self.headportrait_image];
//        [self.headportrait_image mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self).offset(20);
//            make.centerX.equalTo(self);
//            make.size.mas_equalTo(CGSizeMake(80, 80));
//        }];
        
        self.point_label = [UILabel new];
        self.point_label.text = @"请确认您的设备已接通电源";
        self.point_label.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.point_label];
        [self.point_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headportrait_image.mas_bottom).offset(20);
            make.centerX.mas_equalTo(self);
            make.bottom.equalTo(self).offset(-20);
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
