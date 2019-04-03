//
//  GroupTableViewCell.h
//  WaekLight
//
//  Created by apple001 on 2018/6/16.
//  Copyright © 2018年 HJTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView * leftImageView;
@property (nonatomic, strong) UIImageView * rightImageView;

@property (nonatomic, strong) UILabel * leftTitleLabel;
@property (nonatomic, strong) UILabel * rightTitleLabel;

@property (nonatomic, strong) UIButton * leftCellButton;
@property (nonatomic, strong) UIButton * rightCellButton;

@property (nonatomic, strong) UIImageView * editLeftImageView;//编辑状态左边的选中图片
@property (nonatomic, strong) UIImageView * editRightImageView;//编辑状态右边的选中图片

-(void)reloadLeftEdit:(BOOL)leftResult  rightEdit:(BOOL)rightResult;
-(void)reloadEdit:(BOOL)result;

@end
