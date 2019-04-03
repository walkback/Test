//
//  Equipment_ViewController.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/6/15.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "Equipment_ViewController.h"
#import "Equipment_TableViewCell.h"
#import "AddDevice_ViewController.h"
#import "Device_Request.h"
#import "DeleteMemberDevice_Request.h"

#import "Macro.h"
#import <Masonry.h>
#import <MJRefresh.h>

@interface Equipment_ViewController () <UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *data_array;

@end

@implementation Equipment_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的设备";
    
    self.data_array = [NSArray array];
    
    self.navigationController.navigationBar.hidden = NO;
    self.view.backgroundColor = Line_Color;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    UIBarButtonItem *rightbaritem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"添加"] style:UIBarButtonItemStyleDone target:self action:@selector(adddevice)];
    self.navigationItem.rightBarButtonItem = rightbaritem;
    
    self.tableView = [[UITableView alloc] init];
    [self.tableView registerClass:[Equipment_TableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView.layer setCornerRadius:5];
    self.tableView.layer.masksToBounds = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
    if (KIsiPhoneX) {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(98);
            make.left.equalTo(self.view).offset(10);
            make.right.bottom.equalTo(self.view).offset(-10);
        }];
    } else {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(74);
            make.left.equalTo(self.view).offset(10);
            make.right.bottom.equalTo(self.view).offset(-10);
        }];
    }
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark 数据加载
- (void)loadNewData {
    [self.tableView.mj_header endRefreshing];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = NSLocalizedString(@"Preparing...", @"HUD preparing title");
    hud.minSize = CGSizeMake(150.f, 100.f);
    
    if (![self.tmgId isEqualToString:@""]) {
        Device_Request *device_Request = [[Device_Request alloc] init];
        device_Request.requestArgument = @{@"tmiId":TMI_Id,
                                           @"tmgId":self.tmgId};
        [device_Request startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
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
                self.data_array = request.responseJSONObject[@"tbMemberGroupDeviceList"];
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
        hud.label.text = NSLocalizedString(@"参数缺失!", @"HUD message title");;
        [hud mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.view);
        }];
        [hud hideAnimated:YES afterDelay:2.f];
    }
}

#pragma mark 添加设备
- (void)adddevice {
    AddDevice_ViewController *adddevice = [[AddDevice_ViewController alloc] init];
    UIBarButtonItem * backButtonItem = [[UIBarButtonItem alloc] init];
    backButtonItem.title = @"";
    self.navigationItem.backBarButtonItem = backButtonItem;
    [self.navigationController pushViewController:adddevice animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data_array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Equipment_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.photo_image.image = [UIImage imageNamed:@"2"];
    cell.equipment_typename_lab.text = @"设备类型1";
    cell.equipment_location_lab.text = @"卧室大灯";
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark 侧滑
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        NSDictionary *dictionary = self.data_array[indexPath.row];
        NSString *tdi_id_str = [NSString stringIsEmpty:[NSString stringWithFormat:@"%@",dictionary[@"tdi_id"]]];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = NSLocalizedString(@"正在加载...", @"HUD preparing title");
        hud.minSize = CGSizeMake(150.f, 100.f);
        
        if (![[NSString stringIsEmpty:self.tmgId]isEqualToString:@""] &&
            ![[NSString stringIsEmpty:tdi_id_str]isEqualToString:@""]) {
            DeleteMemberDevice_Request *deleteMemberDevice_Request = [[DeleteMemberDevice_Request alloc] init];
            deleteMemberDevice_Request.requestArgument = @{@"tmgrdGroupId":self.tmgId,
                                                           @"tmgrdDeviceId":tdi_id_str
                                                           };
            [deleteMemberDevice_Request startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
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
                    [self.tableView.mj_header beginRefreshing];
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

    }];
    action1.backgroundColor = Default_Blue_Color;
    
    UITableViewRowAction *action2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
    }];
    action2.backgroundColor = Default_Blue_Color;
    
    return @[action1,action2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark DZNEmptyDataSetDelegate----------------
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"无设备"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"暂无设备";
    return [[NSAttributedString alloc] initWithString:text attributes:nil];
}

@end
