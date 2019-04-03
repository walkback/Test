//
//  AddDevice_ViewController.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/6/15.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "AddDevice_ViewController.h"
#import "AddDevice_TableViewCell.h"
#import "ScanCode_ViewController.h"
#import "ChooseWIFI_ViewController.h"
#import "AddDevice_view.h"
#import "GetDeviceWifi_Request.h"
#import "ConnectionDevice_Request.h"
#import "Macro.h"
#import <Masonry.h>
#import <SystemConfiguration/CaptiveNetwork.h>

@interface AddDevice_ViewController () <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) AddDevice_view *adddeviceview;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *verification_but;

@property (nonatomic, copy) NSString *wifiname;
@property (nonatomic, copy) NSString *codingfield_str;
@property (nonatomic, strong) NSDictionary *dictionary;
@end

@implementation AddDevice_ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self get_current_wifi_inf];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"添加设备";
    self.view.backgroundColor = Line_Color;
    UIBarButtonItem *rightbaritem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"二维码"] style:UIBarButtonItemStyleDone target:self action:@selector(scanCode)];
    self.navigationItem.rightBarButtonItem = rightbaritem;
    
//    self.adddeviceview = [[AddDevice_view alloc] init];
//    [self.adddeviceview.layer setCornerRadius:5];
//    self.adddeviceview.layer.masksToBounds = YES;
//    [self.view addSubview:self.adddeviceview];
//    if (KIsiPhoneX) {
//        [self.adddeviceview mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.view).offset(98);
//            make.left.equalTo(self.view).offset(10);
//            make.right.equalTo(self.view).offset(-10);
//        }];
//    } else {
//        [self.adddeviceview mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.view).offset(74);
//            make.left.equalTo(self.view).offset(10);
//            make.right.equalTo(self.view).offset(-10);
//        }];
//    }
    
    UILabel *remind_lab = [UILabel new];
    remind_lab.font = [UIFont systemFontOfSize:14];
    remind_lab.text = @"请确认您的设备已接通电源!";
    [self.view addSubview:remind_lab];
    if (KIsiPhoneX) {
        [remind_lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.view);
            make.top.equalTo(self.view).offset(108);
        }];
    } else {
        [remind_lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.view);
            make.top.equalTo(self.view).offset(84);
        }];
    }

    self.tableView = [[UITableView alloc] init];
    [self.tableView.layer setCornerRadius:5];
    self.tableView.layer.masksToBounds = YES;
    [self.tableView registerClass:[AddDevice_TableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(remind_lab.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(132);
    }];
    
    UILabel *note_label = [UILabel new];
    note_label.font = [UIFont systemFontOfSize:14];
    note_label.text = @"温馨提示:若输错设备编码,将无法绑定设备!";
    [self.view addSubview:note_label];
    [note_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(20);
    }];
    
    self.verification_but = [UIButton new];
    [self.verification_but.layer setCornerRadius:22];
    self.verification_but.layer.masksToBounds = YES;
    [self.verification_but addTarget:self action:@selector(binding_device:) forControlEvents:UIControlEventTouchUpInside];
    [self.verification_but setTitle:@"立刻绑定" forState:UIControlStateNormal];
    [self.verification_but setBackgroundColor:Default_Blue_Color];
    [self.view addSubview:self.verification_but];
    [self.verification_but mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(note_label.mas_bottom).offset(60);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(44);
    }];
    
    [self get_current_wifi_inf];
}

#pragma mark 扫码
- (void)scanCode {
    ScanCode_ViewController *scanode = [[ScanCode_ViewController alloc] init];
    [self.navigationController pushViewController:scanode animated:YES];
}

#pragma mark 获取wifi信息
- (NSString *)get_current_wifi_inf {
    NSString *currentSSID = @"Not Found";
    CFArrayRef myArray = CNCopySupportedInterfaces();
    if (myArray != nil){
        NSDictionary* myDict = (__bridge NSDictionary *) CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
        self.wifiname = [myDict valueForKey:@"SSID"];
        if (myDict != nil){
            currentSSID = [myDict valueForKey:@"SSID"];
        } else {
            currentSSID = @"<<NONE>>";
        }
    } else {
        currentSSID = @"<<NONE>>";
    }
    [self.tableView reloadData];
    CFRelease(myArray);
    return currentSSID;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddDevice_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0) {
        cell.add_inf_lab.text = @"设备编码";
        cell.coding_field.hidden = NO;
        if (![[NSString stringIsEmpty:self.codingfield_str] isEqualToString:@""]) {
            cell.coding_field.text = [NSString stringIsEmpty:self.codingfield_str];
        } else {
            cell.coding_field.placeholder = @"请输入设备编号";
        }
        cell.coding_field.delegate = self;
        [cell.coding_field addTarget:self action:@selector(coding_field:) forControlEvents:UIControlEventEditingChanged];
    }
    if (indexPath.row == 1) {
        cell.add_inf_lab.text = @"设备名称";
        cell.device_name_lab.hidden = NO;
        cell.device_name_lab.text = [NSString stringIsEmpty:self.dictionary[@"tdiName"]];
    }
    if (indexPath.row == 2) {
        cell.add_inf_lab.text = @"WI-FI";
        cell.add_status.hidden = NO;
        cell.add_status.text = [NSString stringIsEmpty:self.dictionary[@"tdiWifiAccount"]];
//        if ([self.wifiname isEqualToString:@""]) {
//            cell.add_status.text = @"未连接";
//        } else {
//            cell.add_status.text = self.wifiname;
//        }
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        ChooseWIFI_ViewController *choose_wifi = [[ChooseWIFI_ViewController alloc] init];
        UIBarButtonItem * backButtonItem = [[UIBarButtonItem alloc] init];
        backButtonItem.title = @"";
        self.navigationItem.backBarButtonItem = backButtonItem;
        choose_wifi.wifi_name_str = [NSString stringIsEmpty:self.dictionary[@"tdiWifiAccount"]];
        [self.navigationController pushViewController:choose_wifi animated:YES];
    }
}

#pragma mark 监听
- (void)coding_field:(UITextField *)textField {
    self.codingfield_str = textField.text;
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    self.codingfield_str = textField.text;
    [self obtain_wifi];
    return YES;
}

#pragma mark 获取wifi
- (void)obtain_wifi {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = NSLocalizedString(@"正在加载...", @"HUD preparing title");
    hud.minSize = CGSizeMake(150.f, 100.f);
    if (![[NSString stringIsEmpty:self.codingfield_str] isEqualToString:@""]) {
        GetDeviceWifi_Request *getDeviceWifi_Request = [[GetDeviceWifi_Request alloc] init];
        getDeviceWifi_Request.requestArgument = @{@"tdiNumber":self.codingfield_str};
        [getDeviceWifi_Request startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
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
                self.dictionary = request.responseJSONObject[@"tbDeviceInfo"];
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
    } else {
        [hud hideAnimated:YES];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"请输入设备编码!", @"HUD message title");;
        [hud mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.view);
        }];
        [hud hideAnimated:YES afterDelay:2.f];
    }
}

#pragma mark 绑定设备
- (void)binding_device:(UIButton *)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = NSLocalizedString(@"正在加载...", @"HUD preparing title");
    hud.minSize = CGSizeMake(150.f, 100.f);
    
    NSString *tdiId = [NSString stringIsEmpty:self.dictionary[@"tdiId"]];
    NSString *tdiNumber = [NSString stringIsEmpty:self.dictionary[@"tdiNumber"]];
    
    if (![[NSString stringIsEmpty:tdiId] isEqualToString:@""] &&
        ![[NSString stringIsEmpty:tdiNumber] isEqualToString:@""] &&
        ![[NSString stringIsEmpty:TMI_Id] isEqualToString:@""]) {
        ConnectionDevice_Request *connectionDevice_Request = [[ConnectionDevice_Request alloc] init];
        connectionDevice_Request.requestArgument = @{@"tmiId":TMI_Id,
                                                     @"tdiId":tdiId,
                                                     @"tdiNumber":tdiNumber
                                                     };
        [connectionDevice_Request startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
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
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh" object:nil];
                [self.navigationController popViewControllerAnimated:YES];
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
    } else {
        [hud hideAnimated:YES];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"缺少必要参数!", @"HUD message title");;
        [hud mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.view);
        }];
        [hud hideAnimated:YES afterDelay:2.f];
    }
}


#pragma mark 关闭键盘
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES]; //实现该方法是需要注意view需要是继承UIControl而来的
    [self obtain_wifi];
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
