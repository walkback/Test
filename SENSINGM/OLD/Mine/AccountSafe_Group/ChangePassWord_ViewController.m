//
//  ChangePassWord_ViewController.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/6/15.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "ChangePassWord_ViewController.h"
#import "ChangePassWord_view.h"
#import "Change_PassWord_Request.h"
#import "Macro.h"
#import <Masonry.h>

@interface ChangePassWord_ViewController () <UITextFieldDelegate>

@property (nonatomic, strong) ChangePassWord_view *changepassword_view;

@property (nonatomic, copy) NSString *password_old;
@property (nonatomic, copy) NSString *password_new;
@property (nonatomic, copy) NSString *password_new_again;

@property (nonatomic, strong) NSTimer *timer;
@end

@implementation ChangePassWord_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"更改密码";
    
    self.changepassword_view = [[ChangePassWord_view alloc] init];
    self.changepassword_view.old_password.delegate = self;
    self.changepassword_view.password_new.delegate = self;
    self.changepassword_view.password_again_new.delegate = self;
    [self.changepassword_view.layer setCornerRadius:5];
    self.changepassword_view.layer.masksToBounds = YES;
    [self.view addSubview:self.changepassword_view];
    [self.changepassword_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
    
    [self.changepassword_view.old_password addTarget:self action:@selector(old_password:) forControlEvents:UIControlEventEditingChanged];
    [self.changepassword_view.password_new addTarget:self action:@selector(password_new:) forControlEvents:UIControlEventEditingChanged];
    [self.changepassword_view.password_again_new addTarget:self action:@selector(password_again_new:) forControlEvents:UIControlEventEditingChanged];

    [self.changepassword_view.submit_button addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark 监听
- (void)old_password:(UITextField *)textfield {
    self.password_old = textfield.text;
    if (self.password_old.length >= 6 && self.password_old.length <= 12 &&
         self.password_new.length >= 6 && self.password_new.length <= 12 &&
         self.password_new_again.length >= 6 && self.password_new_again.length <= 12 &&
        [self.password_new isEqualToString:self.password_new_again]) {
        [self.changepassword_view.submit_button setBackgroundColor:Default_Blue_Color];
    } else {
        [self.changepassword_view.submit_button setBackgroundColor:[UIColor colorWithRed:53/255.0 green:127/255.0  blue:218/255.0  alpha:0.5/1.0]];
    }

}

- (void)password_new:(UITextField *)textfield {
    self.password_new = textfield.text;
    if (self.password_old.length >= 6 && self.password_old.length <= 12 &&
        self.password_new.length >= 6 && self.password_new.length <= 12 &&
        self.password_new_again.length >= 6 && self.password_new_again.length <= 12 &&
        [self.password_new isEqualToString:self.password_new_again]) {
        [self.changepassword_view.submit_button setBackgroundColor:Default_Blue_Color];

    } else {
        [self.changepassword_view.submit_button setBackgroundColor:[UIColor colorWithRed:53/255.0 green:127/255.0  blue:218/255.0  alpha:0.5/1.0]];
    }
}

- (void)password_again_new:(UITextField *)textfield {
    self.password_new_again = textfield.text;
    if (self.password_old.length >= 6 && self.password_old.length <= 12 &&
        self.password_new.length >= 6 && self.password_new.length <= 12 &&
        self.password_new_again.length >= 6 && self.password_new_again.length <= 12 &&
        [self.password_new isEqualToString:self.password_new_again]) {
        [self.changepassword_view.submit_button setBackgroundColor:Default_Blue_Color];
    } else {
        [self.changepassword_view.submit_button setBackgroundColor:[UIColor colorWithRed:53/255.0 green:127/255.0  blue:218/255.0  alpha:0.5/1.0]];
    }
}

#pragma mark 限制输入长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (self.changepassword_view.old_password == textField) {
        if (self.password_old.length < 12) {
            return YES;
        }
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength >= 12) {
            return NO;
        }
    }
    
    if (self.changepassword_view.password_new == textField) {
        if (self.password_new.length < 12) {
            return YES;
        }
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength >= 12) {
            return NO;
        }
    }
    
    if (self.changepassword_view.password_again_new == textField) {
        if (self.password_new_again.length < 12) {
            return YES;
        }
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength >= 12) {
            return NO;
        }
    }
    
    return YES;
}

#pragma mark 提交
- (void)submit:(UIButton *)sender {
    if (self.password_old.length >= 6 && self.password_old.length <= 12 &&
        self.password_new.length >= 6 && self.password_new.length <= 12 &&
        self.password_new_again.length >= 6 && self.password_new_again.length <= 12 &&
        [self.password_new isEqualToString:self.password_new_again]) {
        if (![self.password_old isEqualToString:@""] &&
            ![self.password_new_again isEqualToString:@""] &&
            ![self.password_new isEqualToString:@""]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.label.text = NSLocalizedString(@"Preparing...", @"HUD preparing title");
            hud.minSize = CGSizeMake(150.f, 100.f);
            Change_PassWord_Request *change_passWord_request = [[Change_PassWord_Request alloc] init];
            change_passWord_request.requestArgument = @{@"memberId":TMI_Id,
                                                        @"oldPass":self.password_old,
                                                        @"newPass":self.password_new_again};
            [change_passWord_request startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
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
}

#pragma mark 关闭键盘
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES]; //实现该方法是需要注意view需要是继承UIControl而来的
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
