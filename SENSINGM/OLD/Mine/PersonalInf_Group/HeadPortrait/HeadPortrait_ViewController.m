//
//  HeadPortrait_ViewController.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/7/4.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "HeadPortrait_ViewController.h"
#import "AddFile_Request.h"
#import "Change_UesrName_Adress_Request.h"

@interface HeadPortrait_ViewController () <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TZImagePickerControllerDelegate>

@property (nonatomic, strong) UIImageView *headPortrait_image;
@property (nonatomic, strong) UIActionSheet *sheet;
@property (nonatomic, copy) NSString *url_image;

@property (nonatomic, strong) TZImagePickerController *imagePC;

@end

@implementation HeadPortrait_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"修改头像";
    self.view.backgroundColor = Line_Color;
    
    UIButton *leftbutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"top_back"] forState:UIControlStateNormal];
    [leftbutton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftbutton];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"选择"] style:UIBarButtonItemStyleDone target:self action:@selector(select_photo:)];
 
    self.headPortrait_image = [UIImageView new];
    self.headPortrait_image.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.headPortrait_image];
    [self.headPortrait_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(WIDTH, WIDTH));
    }];
    if (![[NSString stringIsEmpty:self.url_photo_st] isEqualToString:@""]) {
        [self.headPortrait_image sd_setImageWithURL:[NSURL URLWithString:PHOTO_URL([NSString stringIsEmpty:self.url_photo_st])]];
    } 
}

- (void)select_photo:(UIButton *)sender {
    self.imagePC = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    __block UIView *current_view = self.view;
    __block NSString *url_string = self.url_image;
    __block UIImageView *imageview = self.headPortrait_image;
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
                [imageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringIsEmpty:PHOTO_URL(url_string)]]];
                
                if (![[NSString stringIsEmpty:TMI_Id] isEqualToString:@""] &&
                    ![[NSString stringIsEmpty:url_string] isEqualToString:@""]) {
                    Change_UesrName_Adress_Request *change_UesrName_Adress_Request = [[Change_UesrName_Adress_Request alloc] init];
                    change_UesrName_Adress_Request.requestArgument = @{@"memberId":TMI_Id,
                                                                       @"tmiHeadImg":url_string
                                                                       };
                    [change_UesrName_Adress_Request startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
                        NSLog(@"request = %@",request.responseJSONObject);
                        int code = [request.responseJSONObject[@"code"] intValue];
                        NSString *message = request.responseJSONObject[@"message"];
                        if (code != 100) {
                            [hud hideAnimated:YES];
                            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:current_view animated:YES];
                            hud.mode = MBProgressHUDModeText;
                            hud.label.text = message;
                            [hud mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.center.mas_equalTo(current_view);
                            }];
                            [hud hideAnimated:YES afterDelay:2.f];
                        } else {
                            [hud hideAnimated:YES];;
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh" object:nil];
                        }
                    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
                        [hud hideAnimated:YES];
                        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:current_view animated:YES];
                        hud.mode = MBProgressHUDModeText;
                        hud.label.text = NSLocalizedString(@"请求失败!", @"HUD message title");;
                        [hud mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.center.mas_equalTo(current_view);
                        }];
                        [hud hideAnimated:YES afterDelay:2.f];
                    }];
                }
                
            } else {
                [hud hideAnimated:YES];
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:current_view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = message;
                [hud mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.mas_equalTo(current_view);
                }];
                [hud hideAnimated:YES afterDelay:2.f];
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

- (void)back:(UIButton *)sender {
//    [self changheadportrait];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)changheadportrait {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = NSLocalizedString(@"正在加载...", @"HUD preparing title");
    hud.minSize = CGSizeMake(150.f, 100.f);
    
    if (![[NSString stringIsEmpty:TMI_Id] isEqualToString:@""] &&
        ![[NSString stringIsEmpty:self.url_image] isEqualToString:@""]) {
        Change_UesrName_Adress_Request *change_UesrName_Adress_Request = [[Change_UesrName_Adress_Request alloc] init];
        change_UesrName_Adress_Request.requestArgument = @{@"memberId":TMI_Id,
                                                           @"tmiHeadImg":self.url_image
                                                           };
        [change_UesrName_Adress_Request startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
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
        hud.label.text = NSLocalizedString(@"缺少参数!", @"HUD message title");;
        [hud mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.view);
        }];
        [hud hideAnimated:YES afterDelay:2.f];
    }
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
