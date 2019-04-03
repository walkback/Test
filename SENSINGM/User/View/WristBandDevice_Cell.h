//
//  UserDevice_Cell.h
//  SENSINGM
//
//  Created by 吴志刚 on 2018/12/11.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WristBandDevice_Cell : UITableViewCell

@property (nonatomic, strong) UIImageView *device_imagev;

@property (nonatomic, strong) UILabel *device_name_lab;
@property (nonatomic, strong) UILabel *device_data_lab;

@property (nonatomic, strong) UIButton *switch_but;
@property (nonatomic, strong) UILabel *electricity_lab;

@property (nonatomic, strong) UIImageView *step_imagev;
@property (nonatomic, strong) UIImageView *sleep_imagev;
@property (nonatomic, strong) UIImageView *heartbeat_imagev;

@property (nonatomic, strong) UILabel *stepcount_lab;
@property (nonatomic, strong) UILabel *sleeptime_lab;
@property (nonatomic, strong) UILabel *heartbeat_num_lab;

@property (nonatomic, strong) UILabel *stepcount_update_lab;
@property (nonatomic, strong) UILabel *sleeptime_update_lab;
@property (nonatomic, strong) UILabel *heartbeat_update_lab;


@end

NS_ASSUME_NONNULL_END
