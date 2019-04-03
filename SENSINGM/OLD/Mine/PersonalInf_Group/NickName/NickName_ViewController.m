//
//  NickName_ViewController.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/7/4.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "NickName_ViewController.h"
#import "Change_Nickname_Request.h"

@interface NickName_ViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *nickname_field;
@property (nonatomic, copy) NSString *nickname_new_str;

@end

@implementation NickName_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"修改昵称";
    self.view.backgroundColor = Line_Color;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(submit:)];
    
    self.nickname_field = [UITextField new];
    self.nickname_field.placeholder = @"请输入昵称";
    self.nickname_field.text = [NSString stringIsEmpty:self.original_nickname_str];
    [self.nickname_field addTarget:self action:@selector(change_nickname:) forControlEvents:UIControlEventEditingChanged];
    self.nickname_field.font = [UIFont systemFontOfSize:16];
    self.nickname_field.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.nickname_field];
    if (KIsiPhoneX) {
        [self.nickname_field mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(98);
            make.left.right.equalTo(self.view);
            make.height.mas_equalTo(44);
        }];
    } else {
        [self.nickname_field mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(84);
            make.left.right.equalTo(self.view);
            make.height.mas_equalTo(44);
        }];
    }
}


- (void)submit:(UIButton *)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = NSLocalizedString(@"Preparing...", @"HUD preparing title");
    hud.minSize = CGSizeMake(150.f, 100.f);
    if (![self.nickname_new_str isEqualToString:@""]) {
        Change_Nickname_Request *change_Nickname_Request = [[Change_Nickname_Request alloc] init];
        change_Nickname_Request.requestArgument = @{@"tmiId":TMI_Id,@"tmiName":self.nickname_new_str};
        [change_Nickname_Request startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
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
                [self.navigationController popViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh" object:nil];
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
        [hud hideAnimated:YES];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"请输入昵称！", @"HUD message title");;
        [hud mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.view);
        }];
        [hud hideAnimated:YES afterDelay:2.f];
    }
}

#pragma mark 监听
- (void)change_nickname:(UITextField *)textfield {
    CGFloat maxLength = 11;
    NSString *toBeString = textfield.text;
    //获取高亮部分
    UITextRange *selectedRange = [textfield markedTextRange];
    UITextPosition *position = [textfield positionFromPosition:selectedRange.start offset:0];
    if (!position || !selectedRange)
    {
        if (toBeString.length > maxLength)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:maxLength];
            if (rangeIndex.length == 1)
            {
                textfield.text = [toBeString substringToIndex:maxLength];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, maxLength)];
                textfield.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
    self.nickname_new_str = textfield.text;
}


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
