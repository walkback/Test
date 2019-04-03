//
//  Login_view.h
//  SENSINGM
//
//  Created by 吴志刚 on 2018/6/14.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Login_view : UIView

@property (nonatomic, strong) UIImageView *headportrait_imagev;

@property (nonatomic, strong) UITextField *ID_field;
@property (nonatomic, strong) UITextField *PassWord_field;

@property (nonatomic, strong) UIButton *use_codeLogin_but;
@property (nonatomic, strong) UIButton *code_but;
@property (nonatomic, strong) UIButton *login_button;

@property (nonatomic, strong) UIButton *registered_button;
@property (nonatomic, strong) UIButton *forget_password_but;

@end
