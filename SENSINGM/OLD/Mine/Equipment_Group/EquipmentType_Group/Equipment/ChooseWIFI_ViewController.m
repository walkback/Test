//
//  ChooseWIFI_ViewController.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/6/15.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "ChooseWIFI_ViewController.h"
#import "ChooseWIFI_view.h"
#import "Macro.h"
#import <Masonry.h>

#if TARGET_IPHONE_SIMULATOR

#else
#import <SystemConfiguration/CaptiveNetwork.h>

#endif

@interface ChooseWIFI_ViewController () <UITextFieldDelegate>

@property (nonatomic, strong) ChooseWIFI_view *choosewifiview;
@property (nonatomic, copy) NSString *current_wifi_name;

@end

@implementation ChooseWIFI_ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change_wifi_name:) name:@"wifiname" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"WI-FI";
    self.view.backgroundColor = Line_Color;
    
    self.choosewifiview = [[ChooseWIFI_view alloc] init];
    [self.choosewifiview.layer setCornerRadius:5];
    self.choosewifiview.layer.masksToBounds = YES;
    [self.view addSubview:self.choosewifiview];
    [self.choosewifiview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(74);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
    }];
    
    if (![[NSString stringIsEmpty:self.wifi_name_str] isEqualToString:@""]) {
        self.choosewifiview.wifi_name_field.text = [NSString stringIsEmpty:self.wifi_name_str];
    } else {
        self.choosewifiview.wifi_name_field.text = @"输入wifi名称";
    }
    
    [self.choosewifiview.wifi_name_field addTarget:self action:@selector(wifi_name:) forControlEvents:UIControlEventEditingChanged];
    
    [self.choosewifiview.connection_but addTarget:self action:@selector(connectionwifi:) forControlEvents:UIControlEventTouchUpInside];
    
//    [self get_current_wifi_inf];
}

#pragma mark wifi名称变更
- (void)change_wifi_name:(NSNotification *)notif {
    self.current_wifi_name = notif.object;
    self.choosewifiview.wifi_name_field.text = [NSString stringIsEmpty:self.wifi_name_str];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"wifiname" object:nil];
}

#pragma mark 获取wifi信息
- (NSString *)get_current_wifi_inf {
    NSString *currentSSID = @"Not Found";
    
#if TARGET_IPHONE_SIMULATOR
    return currentSSID;
#else
    CFArrayRef myArray = CNCopySupportedInterfaces();
    if (myArray != nil){
        NSDictionary* myDict = (__bridge NSDictionary *) CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
        if (myDict != nil){
            currentSSID = [myDict valueForKey:@"SSID"];
            self.current_wifi_name = currentSSID;
            self.choosewifiview.wifi_name_field.text = self.current_wifi_name;
        } else {
            currentSSID = @"<<NONE>>";
        }
    } else {
        currentSSID = @"<<NONE>>";
    }
    CFRelease(myArray);
    return currentSSID;
    
#endif

}

#pragma mark 连接wifi
- (void)connectionwifi:(UIButton *)sender {
    
#if TARGET_IPHONE_SIMULATOR
    
#else
    if (@available(iOS 11.0, *)) {
        // 创建将要连接的WIFI配置实例
        //        NEHotspotConfiguration * hotspotConfig = [[NEHotspotConfiguration alloc] initWithSSID:self.wifi_name_str passphrase:@"" isWEP:NO];
        
        NEHotspotConfiguration * hotspotConfig = [[NEHotspotConfiguration alloc] initWithSSID:@"R2WiFi-1"];
        
        // 开始连接 (调用此方法后系统会自动弹窗确认)
        [[NEHotspotConfigurationManager sharedManager] applyConfiguration:hotspotConfig completionHandler:^(NSError * _Nullable error) {
            if(error) {
                NSLog(@"错误原因：%@",error);
            } else {
                NSLog(@"加入网络成功");
            }
        }];
    } else {
        
    }
#endif
  
}

#pragma mark 监听
- (void)wifi_name:(UITextField *)textfield {
    self.wifi_name_str = textfield.text;
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
