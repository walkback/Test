//
//  Music_player_view.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/6/20.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "Music_player_view.h"
#import "Macro.h"
#import <Masonry.h>

@implementation Music_player_view

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        UIImageView * lineView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        lineView.backgroundColor = [UIColor  lightGrayColor];
        [self addSubview:lineView];
        
        self.play_stop_button = [UIButton new];
        [self.play_stop_button setImage:[UIImage imageNamed:@"播放 (1)"] forState:UIControlStateNormal];
        [self addSubview:self.play_stop_button];
        [self.play_stop_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.centerY.mas_equalTo(self).offset(0);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        
        self.previous_button = [UIButton new];
        [self.previous_button setImage:[UIImage imageNamed:@"047操作_上一首"] forState:UIControlStateNormal];
        [self addSubview:self.previous_button];
        [self.previous_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.play_stop_button);
            make.left.equalTo(self.play_stop_button).offset(-60);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        
        self.next_button = [UIButton new];
        [self.next_button setImage:[UIImage imageNamed:@"048操作_下一首"] forState:UIControlStateNormal];
        [self addSubview:self.next_button];
        [self.next_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.play_stop_button);
            make.right.equalTo(self.play_stop_button).offset(60);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        
//        self.slider = [[UISlider alloc] init];
//        [self addSubview:self.slider];
//        [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.play_stop_button.mas_bottom).offset(20);
//            make.left.mas_equalTo(self.previous_button);
//            make.right.mas_equalTo(self.next_button);
//            make.height.mas_equalTo(8);
//        }];
//
//        self.schedule_label = [UILabel new];
//        self.schedule_label.font = [UIFont systemFontOfSize:14];
//        [self addSubview:self.schedule_label];
//        [self.schedule_label mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.slider.mas_bottom).offset(10);
//            make.left.mas_equalTo(self.slider);
//        }];
//
//        self.total_label = [UILabel new];
//        self.total_label.textAlignment = NSTextAlignmentRight;
//        self.total_label.font = [UIFont systemFontOfSize:14];
//        [self addSubview:self.total_label];
//        [self.total_label mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.slider.mas_bottom).offset(10);
//            make.left.mas_equalTo(self.schedule_label.mas_right);
//            make.right.mas_equalTo(self.slider);
//        }];

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
