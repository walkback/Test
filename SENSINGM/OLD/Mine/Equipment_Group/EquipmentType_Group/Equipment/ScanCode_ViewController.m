//
//  ScanCode_ViewController.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/6/15.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "ScanCode_ViewController.h"
#import "Macro.h"
#import <Masonry.h>
#import <SGQRCode.h>

@interface ScanCode_ViewController () <SGQRCodeScanManagerDelegate,SGQRCodeAlbumManagerDelegate>
@property (nonatomic, strong) SGQRCodeScanManager *manager;
@property (nonatomic, strong) SGQRCodeScanningView *scanningView;
@property (nonatomic, strong) UILabel *promptLabel;

@end

@implementation ScanCode_ViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.scanningView addTimer];
    [_manager startRunning];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.scanningView removeTimer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"二维码扫描";
    self.view.backgroundColor = Line_Color;
    
    UILabel *point_label = [UILabel new];
    point_label.text = @"扫描设备上的二维码进行绑定设备";
    point_label.textAlignment = NSTextAlignmentCenter;
    point_label.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:point_label];
    [point_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(74);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(19.09375);
    }];
    
    [self.view addSubview:self.scanningView];
    [self setupQRCodeScanning];
    [self.view addSubview:self.promptLabel];
    
//    // 扫描二维码创建
//    SGQRCodeScanManager *scanManager = [SGQRCodeScanManager sharedManager];
//    NSArray *array = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code,
//                       AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode128Code];
//    [scanManager setupSessionPreset:AVCaptureSessionPreset1920x1080 metadataObjectTypes:array currentController:self];
//    scanManager.delegate = self;
//
//    /// 从相册中读取二维码方法
//    SGQRCodeAlbumManager *albumManager = [SGQRCodeAlbumManager sharedManager];
//    [albumManager readQRCodeFromAlbumWithCurrentController:self];
//    albumManager.delegate = self;
    
}

- (void)setupQRCodeScanning {
    self.manager = [SGQRCodeScanManager sharedManager];
    NSArray *arr = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    // AVCaptureSessionPreset1920x1080 推荐使用，对于小型的二维码读取率较高
    [_manager setupSessionPreset:AVCaptureSessionPreset1920x1080 metadataObjectTypes:arr currentController:self];
    [_manager cancelSampleBufferDelegate];
    _manager.delegate = self;
}

- (SGQRCodeScanningView *)scanningView {
    if (!_scanningView) {
        _scanningView = [[SGQRCodeScanningView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _scanningView.scanningImageName = @"SGQRCode.bundle/QRCodeScanningLineGrid";
        _scanningView.scanningAnimationStyle = ScanningAnimationStyleGrid;
        _scanningView.cornerColor = [UIColor orangeColor];
    }
    return _scanningView;
}

#pragma mark 二维码扫描获取数据的回调方法
- (void)QRCodeScanManager:(SGQRCodeScanManager *)scanManager didOutputMetadataObjects:(NSArray *)metadataObjects {
    NSLog(@"metadataObjects - - %@", metadataObjects);
    if (metadataObjects != nil && metadataObjects.count > 0) {
        [scanManager playSoundName:@"SGQRCode.bundle/sound.caf"];
        [scanManager stopRunning];

//        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
//        ScanSuccessJumpVC *jumpVC = [[ScanSuccessJumpVC alloc] init];
//        jumpVC.comeFromVC = ScanSuccessJumpComeFromWB;
//        jumpVC.jump_URL = [obj stringValue];
//        [self.navigationController pushViewController:jumpVC animated:YES];
    } else {
        NSLog(@"暂未识别出扫描的二维码");
    }
}

- (UILabel *)promptLabel {
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.backgroundColor = [UIColor clearColor];
        CGFloat promptLabelX = 0;
        CGFloat promptLabelY = 0.73 * self.view.frame.size.height;
        CGFloat promptLabelW = self.view.frame.size.width;
        CGFloat promptLabelH = 25;
        _promptLabel.frame = CGRectMake(promptLabelX, promptLabelY, promptLabelW, promptLabelH);
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        _promptLabel.font = [UIFont boldSystemFontOfSize:13.0];
        _promptLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
        _promptLabel.text = @"将二维码/条码放入框内, 即可自动扫描";
    }
    return _promptLabel;
}

#pragma mark 根据光线强弱值打开手电筒的回调方法
- (void)QRCodeScanManager:(SGQRCodeScanManager *)scanManager brightnessValue:(CGFloat)brightnessValue {
    
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
