//
//  AddScene_TableViewController.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/12/17.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "AddScene_TableViewController.h"
#import "Timing_ViewController.h"

@interface AddScene_TableViewController () <UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
{
    UITableView *tableView;
}

@property (nonatomic, strong) NSString *scenes_name;

@end

@implementation AddScene_TableViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = false;
    
    [self.navigationController.navigationBar setBackgroundImage:[self createImageWithColor:Nav_BG_Color] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"添加场景";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor],NSFontAttributeName: [UIFont systemFontOfSize:17]}];
    
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:242/255.0 blue:245/255.0 alpha:1.0];
    
    UIButton *back_but = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [back_but setBackgroundImage:[UIImage imageNamed:@"退出"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:back_but];
    [[back_but rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self.navigationController popViewControllerAnimated:true];
    }];
    
    UIButton *delete_but = [UIButton new];
    [delete_but setTitle:@"删除" forState:UIControlStateNormal];
    [delete_but setTitleColor:[UIColor colorWithRed:247/255.0 green:98/255.0 blue:92/255.0 alpha:1.0] forState:UIControlStateNormal];
    delete_but.titleLabel.font = [UIFont systemFontOfSize:16];
    [delete_but setBackgroundColor:UIColor.whiteColor];
    [self.view addSubview:delete_but];
    [delete_but mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    
    tableView = [[UITableView alloc] init];
    tableView.backgroundColor = [UIColor colorWithRed:239/255.0 green:242/255.0 blue:245/255.0 alpha:1.0];
    [tableView.layer setCornerRadius:5];
    tableView.layer.masksToBounds = true;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 200;
    tableView.tableFooterView = [UIView new];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(15);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.bottom.equalTo(self.view).offset(-45);
    }];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * cellID = @"cellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSArray *array = @[@"场景命名",@"场景背景",@"场景定时",@"场景设备"];
    cell.textLabel.text = array[indexPath.row];
    if (indexPath.row == 0) {
        cell.detailTextLabel.text = [NSString stringIsEmpty:self.scenes_name];
    } else if (indexPath.row == 3) {
        cell.detailTextLabel.text = @"5个设备";
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"输入场景名" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertactin = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *name = alertcontroller.textFields.firstObject;
            self.scenes_name = name.text;
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        }];
        [alertcontroller addAction:alertactin];
        [alertcontroller addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"输入姓名";
        }];
        [self presentViewController:alertcontroller animated:true completion:nil];
    }
    if (indexPath.row == 1) {
        LCActionSheet *actionSheet = [LCActionSheet sheetWithTitle:@"选择头像" cancelButtonTitle:@"取消" clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
            switch (buttonIndex) {
                    ///拍照
                case 1:{
                    [self readImageFromCamera];
                    break;
                }
                    ///相册
                case 2:{
                    [self readImageFromAlbum];
                    break;
                }
                default:
                    break;
            }
            NSLog(@"clickedButtonAtIndex: %d", (int)buttonIndex);
        } otherButtonTitles:@"拍照", @"从相册选择", nil];
        [actionSheet show];
    }
    if (indexPath.row == 2) {
        UIBarButtonItem * backButtonItem = [[UIBarButtonItem alloc] init];
        backButtonItem.title = @"";
        self.navigationItem.backBarButtonItem = backButtonItem;
        Timing_ViewController *timing = [[Timing_ViewController alloc] init];
        [self.navigationController pushViewController:timing animated:true];
    }
}

//从相册中读取
- (void)readImageFromAlbum {
    WPhotoViewController *WphotoVC = [[WPhotoViewController alloc] init];
    //选择图片的最大数
    WphotoVC.selectPhotoOfMax = 1;
    [WphotoVC setSelectPhotosBack:^(NSMutableArray *phostsArr) {
        NSLog(@"phostsArr = %@",phostsArr);
        NSMutableArray * dataImageArr = [NSMutableArray  array];
        for (int i = 0; i < phostsArr.count; i++) {
            NSDictionary * imageDic =  phostsArr[i];
            UIImage * image = imageDic[@"image"];
            NSLog(@"image = %@",image);
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.label.text = NSLocalizedString(@"正在加载...", @"HUD preparing title");
            hud.minSize = CGSizeMake(150.f, 100.f);
            [PPNetworkHelper uploadImagesWithURL:BASE_URL(@"add_file") parameters:NULL name:@"uploadFile" images:@[image] fileNames:@[@"image"] imageScale:0.0001 imageType:@"png" progress:^(NSProgress *progress) { } success:^(id responseObject) {
                [hud hideAnimated:YES];
                NSLog(@"responseObject = %@",responseObject);
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                int code = [responseObject[@"code"] intValue];
                NSString * message = responseObject[@"message"];
                if(code != 100){
                    hud.label.text = message;
                    [hud hideAnimated:YES afterDelay:2.f];
                } else {
                    [hud hideAnimated:YES];

                }
            } failure:^(NSError *error) {
                [hud hideAnimated:YES];
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = NSLocalizedString(@"请确保网络正常", @"HUD preparing title");
                [hud hideAnimated:YES afterDelay:2.f];
            }];
            //图片
            NSData *photoData = UIImageJPEGRepresentation(image,0.0001);
            [dataImageArr  addObject:photoData];
        }
    }];
    [self presentViewController:WphotoVC animated:YES completion:nil];
}

//拍照
- (void)readImageFromCamera {
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES; //允许用户编辑
        [self presentViewController:imagePicker animated:YES completion:nil];
    } else {
        //弹出窗口响应点击事件
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"警告" message:@"未检测到摄像头" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

//图片完成之后处理
- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    NSLog(@"%@",image);
    //image 就是修改后的照片
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = NSLocalizedString(@"正在加载...", @"HUD preparing title");
    hud.minSize = CGSizeMake(150.f, 100.f);
    [PPNetworkHelper uploadImagesWithURL:BASE_URL(@"add_file") parameters:NULL name:@"uploadFile" images:@[image] fileNames:@[@"image"] imageScale:0.0001 imageType:@"png" progress:^(NSProgress *progress) { } success:^(id responseObject) {
        [hud hideAnimated:YES];
        NSLog(@"responseObject = %@",responseObject);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        int code = [responseObject[@"code"] intValue];
        NSString * message = responseObject[@"message"];
        if(code != 100){
            hud.label.text = message;
            [hud hideAnimated:YES afterDelay:2.f];
        } else {
            [hud hideAnimated:YES];

        }
    } failure:^(NSError *error) {
        [hud hideAnimated:YES];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"请确保网络正常", @"HUD preparing title");
        [hud hideAnimated:YES afterDelay:2.f];
    }];
    //结束操作
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (UIImage*)createImageWithColor: (UIColor*) color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}


@end
