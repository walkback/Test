//
//  AlarmClock_TableViewCell.h
//  SENSINGM
//
//  Created by 吴志刚 on 2018/7/9.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlarmClock_TableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *time_Label;
@property (nonatomic, strong) UILabel *clockname_Label;
@property (nonatomic, strong) UILabel *repeat_label;
@property (nonatomic, strong) UISwitch *switch_button;

@end
