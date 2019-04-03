//
//  CollectionViewCell.m
//  CollectionView-nib
//
//  Created by chenyufeng on 15/10/30.
//  Copyright © 2015年 chenyufengweb. All rights reserved.
//

#import "CollectionViewCell.h"

#define UISCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define CELL_WIDTH (([[UIScreen mainScreen] bounds].size.width - 40) / 3)

@implementation CollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{

  self = [super initWithFrame:frame];
  if (self) {
    //这里需要初始化ImageView；
      self.imageView = [UIImageView new];
      [self.contentView addSubview:self.imageView];
      [self.imageView setUserInteractionEnabled:true];
      [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.left.right.bottom.equalTo(self.contentView);
      }];
      
      self.descLabel = [UILabel new];
      self.descLabel.textAlignment = NSTextAlignmentCenter;
      self.descLabel.textAlignment = NSTextAlignmentCenter;
      self.descLabel.font = [UIFont systemFontOfSize:18];
      [self.contentView addSubview:self.descLabel];
      [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
          make.center.mas_equalTo(self.imageView);
      }];
      
      [self.layer setCornerRadius:10];
      self.layer.masksToBounds = YES;
      self.deleteButton = [UIButton new];
      [self.deleteButton setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 10, 0)];
      [self.contentView addSubview:self.deleteButton];
      [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.equalTo(self.imageView);
          make.right.equalTo(self.imageView);
          make.size.mas_equalTo(CGSizeMake(44, 44));
      }];
  }
  return self;
}

@end
