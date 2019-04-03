//
//  ChestHanging_Cell.h
//  SENSINGM
//
//  Created by 吴志刚 on 2018/12/12.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChestHanging_Cell : UITableViewCell

@property (nonatomic, strong) UIImageView *device_imagev;

@property (nonatomic, strong) UILabel *device_name_lab;
@property (nonatomic, strong) UILabel *device_data_lab;

@property (nonatomic, strong) UIButton *switch_but;
@property (nonatomic, strong) UILabel *electricity_lab;

@property (nonatomic, strong) UIImageView *sun_imagev;
@property (nonatomic, strong) UIImageView *greenLeaf_imagev;
@property (nonatomic, strong) UIImageView *ev_imagev;
@property (nonatomic, strong) UIImageView *step_imagev;

@property (nonatomic, strong) UILabel *suncount_lab;
@property (nonatomic, strong) UILabel *healthvalue_lab;
@property (nonatomic, strong) UILabel *evcount_lab;
@property (nonatomic, strong) UILabel *stepcount_lab;

@property (nonatomic, strong) UILabel *suncount_update_lab;
@property (nonatomic, strong) UILabel *healthvalue_update_lab;
@property (nonatomic, strong) UILabel *evcount_update_lab;
@property (nonatomic, strong) UILabel *stepcount_update_lab;

@end

NS_ASSUME_NONNULL_END
