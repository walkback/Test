//
//  Equipment_TableViewCell.h
//  SENSINGM
//
//  Created by 吴志刚 on 2018/6/15.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Equipment_TableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *photo_image;
@property (nonatomic, strong) UILabel *equipment_typename_lab; // 设备类型名称
@property (nonatomic, strong) UILabel *equipment_location_lab; // 设备地点
@property (nonatomic, strong) UISwitch *switch_but; // 滑动开关

@property (nonatomic, strong) UIButton *defaut_device_but;

@end
