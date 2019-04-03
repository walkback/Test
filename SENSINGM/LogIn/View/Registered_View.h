//
//  Registered_View.h
//  SENSINGM
//
//  Created by 吴志刚 on 2018/12/10.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Registered_View : UIView <UITextFieldDelegate>
@property (nonatomic, strong) UILabel *title_lab;
@property (nonatomic, strong) UILabel *already_lab;

@property (nonatomic, strong) UIButton *back_but;
@property (nonatomic, strong) UITextField *phone_filed;
@property (nonatomic, strong) UITextField *code_filed;
@property (nonatomic, strong) UITextField *password_filed;
@property (nonatomic, strong) UIButton *code_but;

@property (nonatomic, strong) UIButton *agree_but;
@property (nonatomic, strong) UIButton *protocol_but;

@property (nonatomic, strong) UIButton *login_button;
@end

NS_ASSUME_NONNULL_END
