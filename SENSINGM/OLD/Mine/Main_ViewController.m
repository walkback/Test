//
//  Main_ViewController.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/6/15.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "Main_ViewController.h"
#import "Main_TableViewCell.h"
#import "WIFI_ViewController.h"
#import "WIFISetViewController.h"
#import "AccountSafe_ViewController.h"
#import "Setting_ViewController.h"
#import "PersonalInf_ViewController.h"
#import "SecondViewController.h"
#import "Device_ViewController.h"
#import "Member_Info_Request.h"
#import "Header_view.h"
#import "Footer_view.h"
#import "Macro.h"
#import <Masonry.h>

#define iOS10 ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0)

@interface Main_ViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) Header_view *headerview;
@property (nonatomic, strong) Footer_view *footerview;
@end

@implementation Main_ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    self.mm_drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeNone;
    self.mm_drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh:) name:@"refresh" object:nil];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的";
    self.view.backgroundColor = Line_Color;
    self.navigationController.navigationBar.hidden = YES;
    
    self.headerview = [[Header_view alloc] init];
    self.headerview.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"组1"]];
    [self.view addSubview:self.headerview];
    [self.headerview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(HEIGHT / 2 - 50);
    }];
    
    self.footerview = [[Footer_view alloc] init];
    [self.footerview.layer setCornerRadius:10];
    self.footerview.layer.masksToBounds = YES;
    self.footerview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.footerview];
    [self.footerview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(HEIGHT / 2 + 80);
    }];

    [self get_member_info];
    
//    self.tableView = [[UITableView alloc] init];
//    [self.tableView registerClass:[Main_TableViewCell class] forCellReuseIdentifier:@"cell"];
//    self.tableView.scrollEnabled = NO;
//    [self.tableView.layer setCornerRadius:5];
//    self.tableView.layer.masksToBounds = YES;
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//    [self.view addSubview:self.tableView];
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.headerview.mas_bottom).offset(10);
//        make.left.equalTo(self.view).offset(10);
//        make.right.equalTo(self.view).offset(-10);
//        make.height.mas_equalTo(176);
//    }];
    
    [self.headerview.headportrait_button addTarget:self action:@selector(personalinf:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.footerview.wifi_button  addTarget:self action:@selector(wifiButtonClick:) forControlEvents:UIControlEventTouchUpInside ];

    [self.footerview.device_button addTarget:self action:@selector(device:) forControlEvents:UIControlEventTouchUpInside];
    [self.footerview.accountSafe_button addTarget:self action:@selector(accountSafe:) forControlEvents:UIControlEventTouchUpInside];
    [self.footerview.set_button addTarget:self action:@selector(setting:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark 刷新
- (void)refresh:(NSNotification *)notif {
    [self get_member_info];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refresh" object:nil];
}

#pragma mark 获取个人信息
- (void)get_member_info {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = NSLocalizedString(@"Preparing...", @"HUD preparing title");
    hud.minSize = CGSizeMake(150.f, 100.f);
    
    Member_Info_Request *member_Info_Request = [[Member_Info_Request alloc] init];
    member_Info_Request.requestArgument = @{@"tmiId":TMI_Id};
    [member_Info_Request startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
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
            NSDictionary *dictionary = request.responseJSONObject[@"tbMemberInfo"];

            if (![[NSString stringIsEmpty:dictionary[@"tmi_head_img"]] isEqualToString:@""]) {
                [self.headerview.headportrait_button setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:PHOTO_URL([NSString stringIsEmpty:dictionary[@"tmi_head_img"]])]]] forState:UIControlStateNormal];
            } else {
                [self.headerview.headportrait_button setBackgroundImage:[UIImage imageNamed:@"sleep_back"] forState:UIControlStateNormal];
            }

            self.headerview.nickname_lab.text = [NSString stringIsEmpty:dictionary[@"tmi_name"]];
        }
        [self.tableView reloadData];
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

#pragma mark 个人信息
- (void)personalinf:(UIButton *)sender {
    PersonalInf_ViewController *PersonalInf = [[PersonalInf_ViewController alloc] init];
    UIBarButtonItem * backButtonItem = [[UIBarButtonItem alloc] init];
    backButtonItem.title = @"";
    self.navigationItem.backBarButtonItem = backButtonItem;
    [self.navigationController pushViewController:PersonalInf animated:YES];
}

#pragma mark 我的设备 账号与安全 设置
-(void)wifiButtonClick:(UIButton *)sender
{
    WIFISetViewController * wifiSetVC  = [[WIFISetViewController  alloc]init];
    [self.navigationController pushViewController:wifiSetVC animated:YES];
}
- (void)device:(UIButton *)sender {
    Device_ViewController *device = [[Device_ViewController alloc] init];
    UIBarButtonItem * backButtonItem = [[UIBarButtonItem alloc] init];
    backButtonItem.title = @"";
    self.navigationItem.backBarButtonItem = backButtonItem;
    [self.navigationController pushViewController:device animated:YES];
}

- (void)accountSafe:(UIButton *)sender {
    AccountSafe_ViewController *accountSafe = [[AccountSafe_ViewController alloc] init];
    UIBarButtonItem * backButtonItem = [[UIBarButtonItem alloc] init];
    backButtonItem.title = @"";
    self.navigationItem.backBarButtonItem = backButtonItem;
    [self.navigationController pushViewController:accountSafe animated:YES];
}

- (void)setting:(UIButton *)sender {
    Setting_ViewController *setting = [[Setting_ViewController alloc] init];
    UIBarButtonItem * backButtonItem = [[UIBarButtonItem alloc] init];
    backButtonItem.title = @"";
    self.navigationItem.backBarButtonItem = backButtonItem;
    [self.navigationController pushViewController:setting animated:YES];
}

/**
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Main_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row == 0) {
        cell.set_content.text = @"WLAN";
    }
    if (indexPath.row == 1) {
        cell.set_content.text = @"我的设备";
    }
    if (indexPath.row == 2) {
        cell.set_content.text = @"账号与安全";
    }
    if (indexPath.row == 3) {
        cell.set_content.text = @"设置";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        NSString * urlString = @"App-Prefs:root=WIFI";
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlString]]) {
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:nil];
            } else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
            }
        }
    }
    if (indexPath.row == 1) {
        SecondViewController *equipmentType = [[SecondViewController alloc] init];
        [self.navigationController pushViewController:equipmentType animated:YES];
    }
    if (indexPath.row == 2) {
        AccountSafe_ViewController *accountSafe = [[AccountSafe_ViewController alloc] init];
        [self.navigationController pushViewController:accountSafe animated:YES];
    }
    if (indexPath.row == 3) {
        Setting_ViewController *setting = [[Setting_ViewController alloc] init];
        [self.navigationController pushViewController:setting animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

***/

@end
