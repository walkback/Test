//
//  Registered_ViewController.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/12/10.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "Registered_ViewController.h"
#import "Registered_View.h"
#import "Protocol_ViewController.h"

@interface Registered_ViewController () <UITextFieldDelegate>
{
    Registered_View *registeredView;
}

@property (nonatomic, copy) NSString *phone_string;
@property (nonatomic, copy) NSString *code_string;
@property (nonatomic, copy) NSString *password_string;

@property (nonatomic) BOOL agree_bool;
@end

@implementation Registered_ViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = true;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    _agree_bool = false;
    
    registeredView = [Registered_View new];
    [self.view addSubview:registeredView];
    [registeredView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
    
#pragma mark 跳转类型
    if (self.type == 0) {
        registeredView.title_lab.text = @"用户注册";
    } else if (self.type == 1) {
        registeredView.title_lab.text = @"重置密码";
        registeredView.agree_but.hidden = true;
        registeredView.already_lab.hidden = true;
        registeredView.protocol_but.hidden = true;
    }
    
    // 手机号
    registeredView.phone_filed.delegate = self;
    [registeredView.phone_filed addTarget:self action:@selector(textchange:) forControlEvents:UIControlEventEditingChanged];
    [[registeredView.phone_filed rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        self.phone_string = x;
        self->registeredView.phone_filed.text = [NSString stringIsEmpty:self.phone_string];

        if (self.type == 0) {
            if (self.phone_string.length == 11 && self.code_string.length == 5 &&
                self.password_string.length > 6 && self.password_string.length < 23 &&
                self.agree_bool == true) {
                [self->registeredView.login_button setBackgroundColor:[UIColor colorWithRed:255/255.0 green:203/255.0 blue:6/255.0 alpha:1]];
            } else {
                [self->registeredView.login_button setBackgroundColor:[UIColor colorWithRed:255/255.0 green:203/255.0 blue:6/255.0 alpha:0.5]];
            }
        } else if (self.type == 1) {
            if (self.phone_string.length == 11 && self.code_string.length == 5 &&
                self.password_string.length > 6 && self.password_string.length < 23) {
                [self->registeredView.login_button setBackgroundColor:[UIColor colorWithRed:255/255.0 green:203/255.0 blue:6/255.0 alpha:1]];
            } else {
                [self->registeredView.login_button setBackgroundColor:[UIColor colorWithRed:255/255.0 green:203/255.0 blue:6/255.0 alpha:0.5]];
            }
        }
    }];
    
    // 验证码
    registeredView.code_filed.delegate = self;
    [registeredView.code_filed addTarget:self action:@selector(textchange:) forControlEvents:UIControlEventEditingChanged];
    [[registeredView.code_filed rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        self.code_string = x;
        self->registeredView.code_filed.text = [NSString stringIsEmpty:self.code_string];
        
        if (self.type == 0) {
            if (self.phone_string.length == 11 && self.code_string.length == 5 &&
                self.password_string.length > 6 && self.password_string.length < 23 &&
                self.agree_bool == true) {
                [self->registeredView.login_button setBackgroundColor:[UIColor colorWithRed:255/255.0 green:203/255.0 blue:6/255.0 alpha:1]];
            } else {
                [self->registeredView.login_button setBackgroundColor:[UIColor colorWithRed:255/255.0 green:203/255.0 blue:6/255.0 alpha:0.5]];
            }
        } else if (self.type == 1) {
            if (self.phone_string.length == 11 && self.code_string.length == 5 &&
                self.password_string.length > 6 && self.password_string.length < 23) {
                [self->registeredView.login_button setBackgroundColor:[UIColor colorWithRed:255/255.0 green:203/255.0 blue:6/255.0 alpha:1]];
            } else {
                [self->registeredView.login_button setBackgroundColor:[UIColor colorWithRed:255/255.0 green:203/255.0 blue:6/255.0 alpha:0.5]];
            }
        }
    }];
    
    // 密码
    registeredView.password_filed.delegate = self;
    [registeredView.password_filed addTarget:self action:@selector(textchange:) forControlEvents:UIControlEventEditingChanged];
    [[registeredView.password_filed rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        self.password_string = x;
        self->registeredView.password_filed.text = [NSString stringIsEmpty:self.password_string];
        if (self.type == 0) {
            if (self.phone_string.length == 11 && self.code_string.length == 5 &&
                self.password_string.length > 6 && self.password_string.length < 23 &&
                self.agree_bool == true) {
                [self->registeredView.login_button setBackgroundColor:[UIColor colorWithRed:255/255.0 green:203/255.0 blue:6/255.0 alpha:1]];
            } else {
                [self->registeredView.login_button setBackgroundColor:[UIColor colorWithRed:255/255.0 green:203/255.0 blue:6/255.0 alpha:0.5]];
            }
        } else if (self.type == 1) {
            if (self.phone_string.length == 11 && self.code_string.length == 5 &&
                self.password_string.length > 6 && self.password_string.length < 23) {
                [self->registeredView.login_button setBackgroundColor:[UIColor colorWithRed:255/255.0 green:203/255.0 blue:6/255.0 alpha:1]];
            } else {
                [self->registeredView.login_button setBackgroundColor:[UIColor colorWithRed:255/255.0 green:203/255.0 blue:6/255.0 alpha:0.5]];
            }
        }
    }];
    
#pragma mark t返回
    [[registeredView.back_but rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self.navigationController popViewControllerAnimated:true];
    }];
    
#pragma mark 获取验证码
    [[registeredView.code_but rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        if (![[NSString stringIsEmpty:self.phone_string] isEqualToString:@""]) {
            NSDictionary *parameter = @{@"tcce_login_user":self.phone_string};
            [PPNetworkHelper POST:BASE_URL(@"tbCommunityCenterEmployee/get") parameters:parameter success:^(id responseObject) {
                NSLog(@"responseObject = %@",responseObject);
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                int code = [responseObject[@"code"] intValue];
                NSString * message = responseObject[@"message"];
                if(code != 100){
                    hud.label.text = message;
                    [hud hideAnimated:YES afterDelay:2.f];
                } else {
                    hud.label.text = message;
                    [hud hideAnimated:YES afterDelay:1.f];
                    
                    __block NSInteger time = 59; //倒计时时间
                    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
                    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
                    dispatch_source_set_event_handler(_timer, ^{
                        if(time <= 0){ //倒计时结束，关闭
                            dispatch_source_cancel(_timer);
                            dispatch_async(dispatch_get_main_queue(), ^{
                                //设置按钮的样式
                                [x setTitle:@"获取验证码" forState:UIControlStateNormal];
                                [x setTitleColor:[UIColor colorWithRed:153/255.0 green:206/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
                                [x.layer setBorderWidth:1];
                                [x.layer setBorderColor:[UIColor colorWithRed:153/255.0 green:206/255.0 blue:255/255.0 alpha:1].CGColor];
                                x.userInteractionEnabled = YES;
                            });
                        }else{
                            int seconds = time % 60;
                            dispatch_async(dispatch_get_main_queue(), ^{
                                //设置按钮显示读秒效果
                                [x.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
                                [x setTitle:[NSString stringWithFormat:@"(%.2d)重新发送", seconds] forState:UIControlStateNormal];
                                [x setTitleColor:[UIColor colorWithRed:153/255.0 green:206/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
                                [x.layer setBorderWidth:1];
                                [x.layer setBorderColor:[UIColor colorWithRed:153/255.0 green:206/255.0 blue:255/255.0 alpha:1].CGColor];
                                x.userInteractionEnabled = NO;
                            });
                            time--;
                        }
                    });
                    dispatch_resume(_timer);
                }
            } failure:^(NSError *error) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = NSLocalizedString(@"请确保网络正常", @"HUD preparing title");
                [hud hideAnimated:YES afterDelay:2.f];
            }];
        } else {
            if ([[NSString stringIsEmpty:self.phone_string] isEqualToString:@""]) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = NSLocalizedString(@"请输入手机号", @"HUD preparing title");
                [hud hideAnimated:YES afterDelay:2.f];
            }
        }
    }];
    
#pragma mark 同意协议
    [[registeredView.agree_but rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        x.selected = !x.selected;
        
        if (x.selected && self->_agree_bool == false) {
            [self->registeredView.agree_but setBackgroundColor:[UIColor colorWithRed:61/255.0 green:144/255.0 blue:227/255.0 alpha:1.0]];
            self->_agree_bool = true;
            if (self.type == 0) {
                if (self.phone_string.length == 11 && self.code_string.length == 5 &&
                    self.password_string.length > 6 && self.password_string.length < 23 &&
                    self.agree_bool == true) {
                    [self->registeredView.login_button setBackgroundColor:[UIColor colorWithRed:255/255.0 green:203/255.0 blue:6/255.0 alpha:1]];
                }
            }
        } else {
            [self->registeredView.agree_but setBackgroundColor:UIColor.whiteColor];
            self->_agree_bool = false;
            [self->registeredView.login_button setBackgroundColor:[UIColor colorWithRed:255/255.0 green:203/255.0 blue:6/255.0 alpha:0.5]];
        }
    }];
    
#pragma mark 协议内容
    [[registeredView.protocol_but rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        Protocol_ViewController *protocol = [[Protocol_ViewController alloc] init];
        [self.navigationController pushViewController:protocol animated:true];
    }];
    
#pragma mark 登录/确定按钮
    [[registeredView.login_button rac_signalForControlEvents:UIControlEventAllEvents] subscribeNext:^(__kindof UIControl * _Nullable x) {
        if (self.type == 0) {
            // 注册
        } else if (self.type == 1) {
            // 重置密码
        }
    }];
    
}

- (void)textchange:(UITextField *)textField {
    if (textField == registeredView.phone_filed) {
        if (registeredView.phone_filed.text.length > 11) {
            UITextRange *markedRange = [textField markedTextRange];
            if (markedRange) {
                return;
            }
            NSRange range = [textField.text rangeOfComposedCharacterSequenceAtIndex:11];
            textField.text = [textField.text substringToIndex:range.location];
        }
    }
    if (textField == registeredView.code_filed) {
        if (registeredView.code_filed.text.length > 5) {
            UITextRange *markedRange = [textField markedTextRange];
            if (markedRange) {
                return;
            }
            NSRange range = [textField.text rangeOfComposedCharacterSequenceAtIndex:5];
            textField.text = [textField.text substringToIndex:range.location];
        }
    }
    if (textField == registeredView.password_filed) {
        if (registeredView.password_filed.text.length > 22) {
            UITextRange *markedRange = [textField markedTextRange];
            if (markedRange) {
                return;
            }
            NSRange range = [textField.text rangeOfComposedCharacterSequenceAtIndex:22];
            textField.text = [textField.text substringToIndex:range.location];
        }
    }
}

/**
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == registeredView.phone_filed) {
        [string isEqualToString:self.phone_string];
        if (self.phone_string.length <= 10 && self.phone_string.length > 0) {
            return YES;
        } else if (self.phone_string.length > 11) {
            return NO;
        }
    }
    
    if (textField == registeredView.code_filed) {
        [string isEqualToString:self.code_string];
        if (self.code_string.length <= 4 && self.code_string.length > 0) {
            return YES;
        } else if (self.code_string.length > 4) {
            return NO;
        }
    }
    
    if (textField == registeredView.password_filed) {
        [string isEqualToString:self.password_string];
        if (self.password_string.length <= 21 && self.password_string.length > 0) {
            return YES;
        } else if (self.password_string.length > 22 ) {
            return NO;
        }
    }
    
    return YES;
}
 **/

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:true];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
