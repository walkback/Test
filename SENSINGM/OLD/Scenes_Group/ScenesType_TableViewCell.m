//
//  ScenesType_TableViewCell.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/6/27.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "ScenesType_TableViewCell.h"

@implementation ScenesType_TableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
