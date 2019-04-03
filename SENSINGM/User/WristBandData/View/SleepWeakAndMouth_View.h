//
//  SleepWeak_View.h
//  SENSINGM
//
//  Created by 吴志刚 on 2018/12/14.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SleepWeakAndMouth_View : UIView

@property (nonatomic, strong) UIButton *left_but;
@property (nonatomic, strong) UILabel *date_lab;
@property (nonatomic, strong) UIButton *right_but;

@property (nonatomic, strong) UILabel *deepsleepTime_lab;
@property (nonatomic, strong) UILabel *shallowTime_lab;
@property (nonatomic, strong) UILabel *quality_lab;

@end

NS_ASSUME_NONNULL_END
