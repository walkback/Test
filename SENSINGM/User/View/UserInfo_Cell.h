//
//  UserInfo_Cell.h
//  SENSINGM
//
//  Created by 吴志刚 on 2018/12/12.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserInfo_Cell : UITableViewCell

@property (nonatomic, strong) UIView *content_view;
@property (nonatomic, strong) UILabel *title_lab;
@property (nonatomic, strong) UILabel *content_lab;
@property (nonatomic, strong) UIButton *push_but;

@end

NS_ASSUME_NONNULL_END
