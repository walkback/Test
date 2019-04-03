//
//  ChangePassWord_view.h
//  SENSINGM
//
//  Created by 吴志刚 on 2018/6/15.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePassWord_view : UIView

@property (nonatomic, strong) UITextField *old_password;
@property (nonatomic, strong) UITextField *password_new;
@property (nonatomic, strong) UITextField *password_again_new;

@property (nonatomic, strong) UIButton *submit_button;
@end
