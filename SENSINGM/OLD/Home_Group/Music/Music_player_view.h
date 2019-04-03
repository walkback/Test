//
//  Music_player_view.h
//  SENSINGM
//
//  Created by 吴志刚 on 2018/6/20.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Music_player_view : UIView

@property (nonatomic, strong) UIButton *play_stop_button;
@property (nonatomic, strong) UIButton *previous_button; // 上一首
@property (nonatomic, strong) UIButton *next_button;  // 下一首
//@property (nonatomic, strong) UISlider *slider;
//@property (nonatomic, strong) UILabel *schedule_label; // 进度时间
//@property (nonatomic, strong) UILabel *total_label;    // 总时间

@end
