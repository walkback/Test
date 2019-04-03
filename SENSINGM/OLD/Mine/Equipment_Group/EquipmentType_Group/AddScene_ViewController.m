//
//  AddScene_ViewController.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/7/2.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "AddScene_ViewController.h"
#import "AddScene_Request.h"
#import "AddFile_Request.h"

@interface AddScene_ViewController () <UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TZImagePickerControllerDelegate>

@property (nonatomic, strong) UITextField *scene_name_field;
@property (nonatomic, strong) UIButton *select_image_but;
@property (nonatomic, strong) UIView *center_view;
@property (nonatomic, strong) UIActionSheet *sheet;

@property (nonatomic, strong) UIButton *submit_but;
@property (nonatomic, strong) UIButton *cancel_but;

@property (nonatomic, copy) NSString *scene_name_string;
@property (nonatomic, copy) NSString *url_image;
@property (nonatomic, weak) NSString *url_string;

@property (nonatomic, strong) TZImagePickerController *imagePC;

@end

@implementation AddScene_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.modalPresentationStyle = UIModalPresentationCustom;
    
    self.center_view = [UIView new];
    [self.center_view.layer setCornerRadius:5];
    self.center_view.layer.masksToBounds = YES;
    self.center_view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.center_view];
    [self.center_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
    }];
    
    [self center_view_layout];
}

- (void)center_view_layout {
    self.scene_name_field = [UITextField new];
    [self.scene_name_field.layer setCornerRadius:5];
    self.scene_name_field.layer.masksToBounds = YES;
    [self.scene_name_field.layer setBorderWidth:0.5];
    [self.scene_name_field.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [self.scene_name_field addTarget:self action:@selector(scene_name:) forControlEvents:UIControlEventEditingChanged];
    self.scene_name_field.placeholder = @"输入分类名称";
    self.scene_name_field.font = [UIFont systemFontOfSize:16];
    self.scene_name_field.textAlignment = NSTextAlignmentCenter;
    [self.center_view addSubview:self.scene_name_field];
    [self.scene_name_field mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.center_view);
        make.top.equalTo(self.center_view).offset(20);
        make.left.equalTo(self.center_view).offset(20);
        make.right.equalTo(self.center_view).offset(-20);
        make.height.mas_equalTo(44);
    }];
    
    self.select_image_but = [UIButton new];
    [self.select_image_but addTarget:self action:@selector(select_image:) forControlEvents:UIControlEventTouchUpInside];
    [self.select_image_but setTitle:@"添加分类图片" forState:UIControlStateNormal];
    self.select_image_but.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.select_image_but.layer setCornerRadius:5];
    self.select_image_but.layer.masksToBounds = YES;
    [self.select_image_but setBackgroundColor:Default_Blue_Color];
    [self.center_view addSubview:self.select_image_but];
    [self.select_image_but mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.center_view);
        make.top.equalTo(self.scene_name_field.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(WIDTH / 3, 44));
    }];
    
    UIImageView *lineimage = [UIImageView new];
    lineimage.backgroundColor = Line_Color;
    [self.center_view addSubview:lineimage];
    [lineimage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.select_image_but.mas_bottom).offset(30);
        make.left.right.equalTo(self.center_view);
        make.height.mas_equalTo(1);
    }];
    
    UIImageView *lineimage2 = [UIImageView new];
    lineimage2.backgroundColor = Line_Color;
    [self.center_view addSubview:lineimage2];
    [lineimage2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineimage.mas_bottom);
        make.centerX.mas_equalTo(self.center_view);
        make.width.mas_equalTo(2);
        make.bottom.equalTo(self.center_view);
    }];

    self.cancel_but = [UIButton new];
    [self.cancel_but setTitle:@"关闭" forState:UIControlStateNormal];
    self.cancel_but.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.cancel_but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.cancel_but addTarget:self action:@selector(closed) forControlEvents:UIControlEventTouchUpInside];
    [self.center_view addSubview:self.cancel_but];
    [self.cancel_but mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.select_image_but.mas_bottom).offset(30);
        make.left.equalTo(self.center_view);
        make.size.mas_equalTo(CGSizeMake((WIDTH - 40) / 2 - 1, 44));
        make.bottom.equalTo(self.center_view);
    }];
    
    self.submit_but = [UIButton new];
//    [self.submit_but setBackgroundColor:Default_Blue_Color];
    [self.submit_but setTitle:@"确定" forState:UIControlStateNormal];
    self.submit_but.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.submit_but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.submit_but addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [self.center_view addSubview:self.submit_but];
    [self.submit_but mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.select_image_but.mas_bottom).offset(30);
        make.right.equalTo(self.center_view);
        make.size.mas_equalTo(CGSizeMake((WIDTH - 40) / 2 - 1, 44));
        make.bottom.equalTo(self.center_view);
    }];
    
}

#pragma mark 拍照/照片
- (void)select_image:(UIButton *)sender {
    self.imagePC = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    __block UIView *current_view = self.view;
    __block NSString *url_string = self.url_image;
    [self.imagePC setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:current_view animated:YES];
        hud.label.text = NSLocalizedString(@"Preparing...", @"HUD preparing title");
        hud.minSize = CGSizeMake(150.f, 100.f);
        
        [PPNetworkHelper uploadImagesWithURL:BASE_URL(@"add_file") parameters:NULL name:@"file" images:photos fileNames:@[@"image"] imageScale:0.0001 imageType:@"png" progress:^(NSProgress *progress) { } success:^(id responseObject)  {
            NSLog(@"request = %@",responseObject);
            int code = [responseObject[@"code"] intValue];
            NSString *message = responseObject[@"message"];
            if (code == 100) {
                [hud hideAnimated:YES];
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:current_view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = message;
                [hud mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.mas_equalTo(current_view);
                }];
                [hud hideAnimated:YES afterDelay:2.f];
                
                url_string = [NSString stringIsEmpty:responseObject[@"url"]];
                self.url_string = url_string;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Refresh" object:nil];

            } else {
                [hud hideAnimated:YES];
            }
        } failure:^(NSError *error) {
            [hud hideAnimated:YES];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:current_view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"请求失败!", @"HUD message title");
            [hud mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(current_view);
            }];
            [hud hideAnimated:YES afterDelay:2.f];
        }];
    }];
    [self presentViewController:self.imagePC animated:YES completion:nil];//跳转
}

#pragma mark 取消
- (void)closed {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 提交
- (void)submit {
    
    if ([[NSString  stringIsEmpty:self.scene_name_string] isEqualToString:@""]) {
        [ManagerTool  alert:@"请填入组的名称"];
        return;
    }
    if ([[NSString  stringIsEmpty:self.url_string] isEqualToString:@""]) {
        [ManagerTool  alert:@"请添加分类的图片"];
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = NSLocalizedString(@"正在加载...", @"HUD preparing title");
    hud.minSize = CGSizeMake(150.f, 100.f);
    
    if (![self.scene_name_string isEqualToString:@""] && ![self.url_image isEqualToString:@""]) {
        AddScene_Request *addScene_Request = [[AddScene_Request alloc] init];
        addScene_Request.requestArgument = @{@"tmiId":TMI_Id,
                                             @"tmgName":self.scene_name_string,
                                             @"tmgPhoto":PHOTO_URL(self.url_string)};
        [addScene_Request startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
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
                [self dismissViewControllerAnimated:YES completion:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Refresh" object:nil];
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
    }
}

#pragma mark 关闭键盘
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES]; //实现该方法是需要注意view需要是继承UIControl而来的
}

#pragma mark 监听
- (void)scene_name:(UITextField *)textfield {
    CGFloat maxLength = 5;
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
    self.scene_name_string = textfield.text;
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
