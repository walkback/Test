//
//  ChangePhone_ViewController.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/6/15.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "ChangePhone_ViewController.h"
#import "LogIn_ViewController.h"
#import "ChangePhone_view.h"
#import "ChangePhone_Request.h"
#import "Code_Request.h"
#import "Macro.h"
#import <Masonry.h>

@interface ChangePhone_ViewController () <UITextFieldDelegate>

@property (nonatomic, strong) ChangePhone_view *changephoneview;

@property (nonatomic, copy) NSString *phone_str;
@property (nonatomic, copy) NSString *code_str;
//@property (nonatomic, copy) NSString *password_str;
@property (nonatomic, strong) NSTimer *timer;
@property (assign) int vcode;
@end

@implementation ChangePhone_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"更改手机号";
    self.view.backgroundColor = Line_Color;
    
    self.changephoneview = [[ChangePhone_view alloc] init];
    self.changephoneview.phone_field.delegate = self;
    self.changephoneview.code_field.delegate = self;
    self.changephoneview.password_field.delegate = self;
    [self.changephoneview.layer setCornerRadius:5];
    self.changephoneview.layer.masksToBounds = YES;
    [self.view addSubview:self.changephoneview];
    [self.changephoneview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
    
    [self.changephoneview.code_button addTarget:self action:@selector(obtain_code:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.changephoneview.phone_field addTarget:self action:@selector(phone:) forControlEvents:UIControlEventEditingChanged];
    [self.changephoneview.code_field addTarget:self action:@selector(code:) forControlEvents:UIControlEventEditingChanged];
//    [self.changephoneview.password_field addTarget:self action:@selector(password:) forControlEvents:UIControlEventEditingChanged];
    
    [self.changephoneview.submit_button addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark 验证码
- (void)obtain_code:(UIButton *)sender {
    if (self.phone_str.length == 11 ) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = NSLocalizedString(@"Preparing...", @"HUD preparing title");
        hud.minSize = CGSizeMake(150.f, 100.f);
        Code_Request *code_request = [[Code_Request alloc] init];
        code_request.requestArgument = @{@"phone":self.phone_str,
                                         @"type":@"3"};
        [code_request startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
            NSLog(@"request = %@",request.responseJSONObject);
            int code = [request.responseJSONObject[@"code"] intValue];
            NSString *message = request.responseJSONObject[@"message"];
            if (code != 100) {
                [hud hideAnimated:YES];
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = message;
                [hud mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.mas_equalTo(self.view);
                }];
                [hud hideAnimated:YES afterDelay:2.f];
            } else {
                [hud hideAnimated:YES];
                
                self.vcode = [request.responseJSONObject[@"vcode"] intValue];
                [ManagerTool alert:request.responseJSONObject[@"vcode"]];
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                hud.mode = MBProgressHUDModeCustomView;
                UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                hud.customView = [[UIImageView alloc] initWithImage:image];
                hud.square = YES;
                hud.label.text = NSLocalizedString(message, @"HUD done title");
                [hud hideAnimated:YES afterDelay:3.f];
                
                __block NSInteger time = 59; //倒计时时间
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
                dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
                dispatch_source_set_event_handler(_timer, ^{
                    if(time <= 0){ //倒计时结束，关闭
                        dispatch_source_cancel(_timer);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //设置按钮的样式
                            [sender setTitle:@"重新发送" forState:UIControlStateNormal];
                            [sender setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                            sender.userInteractionEnabled = YES;
                        });
                    }else{
                        int seconds = time % 60;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //设置按钮显示读秒效果
                            [sender.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
                            [sender setTitle:[NSString stringWithFormat:@"(%.2d)重新发送", seconds] forState:UIControlStateNormal];
                            [sender setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                            sender.userInteractionEnabled = NO;
                        });
                        time--;
                    }
                });
                dispatch_resume(_timer);
            }
        } failure:^(__kindof LCBaseRequest *request, NSError *error) {
            [hud hideAnimated:YES];
            NSString *message = request.responseJSONObject[@"message"];
            NSLog(@"error = %@",error);
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = message;
            [hud mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(self.view);
            }];
            [hud hideAnimated:YES afterDelay:2.f];
        }];
    } else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"请输入正确手机号格式!", @"HUD message title");
        [hud mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.view);
        }];
        [hud hideAnimated:YES afterDelay:2.f];
    }
}

#pragma mark 监听
- (void)phone:(UITextField *)textfield {
    self.phone_str = textfield.text;
    if (self.phone_str.length == 11 &&
        self.code_str.length == 5 ){
        [self.changephoneview.submit_button setBackgroundColor:Default_Blue_Color];
    } else {
        [self.changephoneview.submit_button setBackgroundColor:[UIColor colorWithRed:53/255.0 green:127/255.0  blue:218/255.0  alpha:0.5/1.0]];
    }
}

- (void)code:(UITextField *)textfield {
    self.code_str = textfield.text;
    if (self.phone_str.length == 11 &&
        self.code_str.length == 5 ){
        [self.changephoneview.submit_button setBackgroundColor:Default_Blue_Color];
    } else {
        [self.changephoneview.submit_button setBackgroundColor:[UIColor colorWithRed:53/255.0 green:127/255.0  blue:218/255.0  alpha:0.5/1.0]];
    }
}

//- (void)password:(UITextField *)textfield {
//    self.password_str = textfield.text;
//    if (self.phone_str.length == 11 &&
//        self.code_str.length == 5 &&
//        self.password_str.length >= 6 && self.password_str.length <= 12) {
//        [self.changephoneview.submit_button setBackgroundColor:Default_Blue_Color];
//    } else {
//        [self.changephoneview.submit_button setBackgroundColor:[UIColor colorWithRed:53/255.0 green:127/255.0  blue:218/255.0  alpha:0.5/1.0]];
//    }
//}

#pragma mark 限制输入长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (self.changephoneview.phone_field == textField) {
        if (self.phone_str.length < 11) {
            return YES;
        }
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength >= 11) {
            return NO;
        }
    }
    
    if (self.changephoneview.code_field == textField) {
        if (self.code_str.length < 5) {
            return YES;
        }
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength >= 5) {
            return NO;
        }
    }
    
//    if (self.changephoneview.password_field == textField) {
//        if (self.password_str.length < 12) {
//            return YES;
//        }
//        NSInteger existedLength = textField.text.length;
//        NSInteger selectedLength = range.length;
//        NSInteger replaceLength = string.length;
//        if (existedLength - selectedLength + replaceLength >= 12) {
//            return NO;
//        }
//    }
    
    return YES;
}

#pragma mark 提交
- (void)submit:(UIButton *)sender {
    if (self.phone_str.length == 11 &&
        self.code_str.length == 5 ) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = NSLocalizedString(@"Preparing...", @"HUD preparing title");
        hud.minSize = CGSizeMake(150.f, 100.f);
        ChangePhone_Request *changePhone_Request = [[ChangePhone_Request alloc] init];
        changePhone_Request.requestArgument = @{@"tmiId":TMI_Id,
                                                @"TmiContactPhone":self.phone_str,
                                                @"vcode":self.code_str};
        NSLog(@"---输出修改密码的东西  =%@",@{@"tmiId":TMI_Id,
                                     @"TmiContactPhone":self.phone_str,
                                     @"vcode":self.code_str});
        NSLog(@"vcode = %@", changePhone_Request.requestArgument );
        [changePhone_Request startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
            NSLog(@"request = %@", request.responseJSONObject );
            int code = [request.responseJSONObject[@"code"] intValue];
            NSString *message = request.responseJSONObject[@"message"];
            if (code != 100) {
                [hud hideAnimated:YES];
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = message;
                [hud mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.mas_equalTo(self.view);
                }];
                [hud hideAnimated:YES afterDelay:2.f];
            } else {
                [hud hideAnimated:YES];
                
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeCustomView;
                UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                hud.customView = [[UIImageView alloc] initWithImage:image];
                hud.square = YES;
                hud.label.text = NSLocalizedString(message, @"HUD done title");
                [hud hideAnimated:YES afterDelay:2.f];
                
                self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(changepassword) userInfo:nil repeats:NO];
            }
        } failure:^(__kindof LCBaseRequest *request, NSError *error) {
            [hud hideAnimated:YES];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"请求失败!", @"HUD message title");;
            [hud mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(self.view);
            }];
            [hud hideAnimated:YES afterDelay:2.f];
        }];
    } else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"请输入对应密码!", @"HUD message title");
        [hud mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.view);
        }];
        [hud hideAnimated:YES afterDelay:2.f];
    }
}

#pragma mark 延迟返回
- (void)changepassword {
    
    [self.navigationController popViewControllerAnimated:YES];
    
//    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
//    [USER_DEF removePersistentDomainForName:appDomain];
//    LogIn_ViewController *logIn = [[LogIn_ViewController alloc] init];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:logIn];
//    [UIApplication sharedApplication].keyWindow.rootViewController = nav;

}

#pragma mark 关闭键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
