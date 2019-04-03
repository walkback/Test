

//
//  DeviceTableViewCell.m
//  WaekLight
//
//  Created by apple001 on 2018/6/19.
//  Copyright © 2018年 HJTech. All rights reserved.
//

#import "DeviceTableViewCell.h"

@implementation DeviceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:( NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor  whiteColor];
        
        UIImageView * leftImageView = [[UIImageView  alloc]initWithFrame:CGRectMake(30, 15, 50, 50)];
        leftImageView.image = [UIImage  imageNamed:@"sleep_back.png"];
        [self.contentView  addSubview:leftImageView];
        
        self.titleContentLabel = [[UILabel  alloc]initWithFrame:CGRectMake(CGRectGetMaxX(leftImageView.frame) + 15, leftImageView.frame.origin.y, 200, 20)];
        self.titleContentLabel.text = @"设备类型1";
        [self.contentView  addSubview: self.titleContentLabel];
        
        self.bottomDetailLabel = [[UILabel  alloc]initWithFrame:CGRectMake(CGRectGetMaxX(leftImageView.frame) + 15, CGRectGetMaxY(self.titleContentLabel.frame) + 10, 200, 20)];
        self.bottomDetailLabel.text = @"卧室大灯";
        [self.contentView  addSubview: self.bottomDetailLabel];
      
    
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
