//
//  TimeSetting_Cell.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/12/17.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "TimeSetting_Cell.h"

@implementation TimeSetting_Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
         _datePicker = [[UIDatePicker alloc] init];
         _datePicker.datePickerMode = UIDatePickerModeTime;
         [self.contentView addSubview:_datePicker];
         [_datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.left.right.bottom.equalTo(self.contentView);
         make.height.mas_equalTo(174);
         }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
