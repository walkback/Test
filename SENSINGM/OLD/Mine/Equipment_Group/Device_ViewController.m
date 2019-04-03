//
//  Device_ViewController.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/7/11.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "Device_ViewController.h"
#import "BindingDevice_Request.h"
#import "Equipment_TableViewCell.h"
#import "AddDevice_ViewController.h"
#import "DeleteDevice_Request.h"

@interface Device_ViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *data_array;

@property (nonatomic, strong) UIButton *addDevice_but;
@property (nonatomic) BOOL switch_on_off;
@property (nonatomic) NSInteger integer;
@property (nonatomic, strong) UISwitch  * remarkSwitch;
@property (nonatomic) BOOL is_select;
@property (nonatomic) BOOL all_select;
@property (nonatomic, strong) UIView *allselect_view;
@property (nonatomic, strong) UIButton *delete_but;
@property (nonatomic, strong) NSMutableArray *allselect_array;
@end

@implementation Device_ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh:) name:@"refresh" object:nil];
}

- (void)refresh:(NSNotification *)notif {
    [self getdata];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的设备";
    self.view.backgroundColor = Line_Color;
    self.switch_on_off = NO;
    self.all_select = NO;
    self.allselect_array = [NSMutableArray array];
    
    UIButton *rightbutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [rightbutton setBackgroundImage:[UIImage imageNamed:@"编辑"] forState:UIControlStateNormal];
    [rightbutton addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightbutton];
    
    self.data_array = [NSArray array];
    self.is_select = NO;
    
    [self tableviewinit];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getdata)];
    [self.tableView.mj_header beginRefreshing];
    [self getdata];
    [self deleteView];
}

#pragma mark 获取设备
- (void)getdata {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = NSLocalizedString(@"正在加载...", @"HUD preparing title");
    hud.minSize = CGSizeMake(150.f, 100.f);
    if (![TMI_Id isEqualToString:@""]) {
        BindingDevice_Request *bindingDevice_Request = [[BindingDevice_Request alloc] init];
        bindingDevice_Request.requestArgument = @{@"tmiId":TMI_Id};
        [bindingDevice_Request startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
            NSLog(@"request = %@",request.responseJSONObject);
            int code = [request.responseJSONObject[@"code"] intValue];
            NSString *message = request.responseJSONObject[@"message"];
            if (code != 100) {
                [hud hideAnimated:YES];
                [self.tableView.mj_header endRefreshing];
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = message;
                [hud mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.mas_equalTo(self.view);
                }];
                [hud hideAnimated:YES afterDelay:2.f];
            } else {
                [hud hideAnimated:YES];
                [self.tableView.mj_header endRefreshing];
                self.data_array = request.responseJSONObject[@"tbMemberDeviceList"];
            }
            [self.tableView reloadData];
        } failure:^(__kindof LCBaseRequest *request, NSError *error) {
            [hud hideAnimated:YES];
            [self.tableView.mj_header endRefreshing];
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
        [self.tableView.mj_header endRefreshing];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"缺少参数!", @"HUD message title");;
        [hud mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.view);
        }];
        [hud hideAnimated:YES afterDelay:2.f];
    }
}

#pragma mark tableview初始化
- (void)tableviewinit {
    
    self.tableView = [[UITableView alloc] init];
    [self.tableView registerClass:[Equipment_TableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView.layer setCornerRadius:5];
    self.tableView.layer.masksToBounds = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    if (KIsiPhoneX) {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(89);
            make.left.equalTo(self.view).offset(10);
            make.right.equalTo(self.view).offset(-10);
            make.bottom.equalTo(self.view).offset(-50);
        }];
    } else {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(74);
            make.left.equalTo(self.view).offset(10);
            make.right.equalTo(self.view).offset(-10);
            make.bottom.equalTo(self.view).offset(-80);
        }];
    }
    [self setExtraCellLineHidden:_tableView];
}

#pragma mark 删除视图
- (void)deleteView {
    self.allselect_view = [UIView new];
    self.allselect_view.hidden = YES;
    self.allselect_view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.allselect_view];
    [self.allselect_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(WIDTH / 3 * 2, 44));
    }];
    
    UIButton *imageview_but = [UIButton new];
    [imageview_but addTarget:self action:@selector(allselect:) forControlEvents:UIControlEventTouchUpInside];
    [imageview_but setBackgroundImage:[UIImage imageNamed:@"圆圈"] forState:UIControlStateNormal];
    [self.allselect_view addSubview:imageview_but];
    [imageview_but mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.allselect_view);
        make.left.equalTo(self.allselect_view).offset(40);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    UILabel *all_label = [UILabel new];
    all_label.font = [UIFont systemFontOfSize:16];
    all_label.text = @"全选";
    all_label.textColor = Default_Blue_Color;
    [self.allselect_view addSubview:all_label];
    [all_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(imageview_but);
        make.left.equalTo(imageview_but.mas_right).offset(5);
    }];
    
    self.delete_but = [UIButton new];
    self.delete_but.hidden = YES;
    [self.delete_but.layer setCornerRadius:5];
    [self.delete_but addTarget:self action:@selector(alldelete:) forControlEvents:UIControlEventTouchUpInside];
    self.delete_but.layer.masksToBounds = YES;
    [self.delete_but setTitle:@"删除" forState:UIControlStateNormal];
    [self.delete_but setBackgroundColor:Default_Blue_Color];
    [self.view addSubview:self.delete_but];
    [self.delete_but mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.view);
        make.left.equalTo(self.allselect_view.mas_right).offset(-5);
        make.height.mas_equalTo(44);
    }];
}

#pragma mark 全选
- (void)allselect:(UIButton *)sender {
    self.allselect_array = [NSMutableArray array];
    sender.selected = !sender.selected;
    if (sender.selected) {
        if (self.all_select == NO) {
            self.all_select = YES;
            [sender setImage:[UIImage imageNamed:@"圆圈中"] forState:UIControlStateNormal];
            for (int i = 0; i < self.data_array.count; i++) {
                [self.allselect_array addObject:self.data_array[i]];
            }
        } else {
            self.all_select = NO;
            [sender setImage:[UIImage imageNamed:@"圆圈"] forState:UIControlStateNormal];
            [self.allselect_array removeAllObjects];
        }
    } else {
        if (self.all_select == NO) {
            self.all_select = YES;
            [sender setImage:[UIImage imageNamed:@"圆圈中"] forState:UIControlStateNormal];
            for (int i = 0; i < self.data_array.count; i++) {
                [self.allselect_array addObject:self.data_array[i]];
            }
        } else {
            self.all_select = NO;
            [sender setImage:[UIImage imageNamed:@"圆圈"] forState:UIControlStateNormal];
            [self.allselect_array removeAllObjects];
        }
    }
    [self.tableView reloadData];
}

#pragma mark 删除
- (void)alldelete:(UIButton *)sender {
    // 全部删除
    if (self.allselect_array.count != 0) {
        NSMutableArray *tmd_id_array = [NSMutableArray array];
        for (int i = 0; i < self.allselect_array.count; i++) {
            NSDictionary *dictionary = self.allselect_array[i];
            [tmd_id_array addObject:[NSString stringIsEmpty:[NSString stringWithFormat:@"%@",dictionary[@"tdi_id"]]]];
        }
        NSString *tmd_id_str = [tmd_id_array componentsJoinedByString:@","];

        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = NSLocalizedString(@"正在加载...", @"HUD preparing title");
        hud.minSize = CGSizeMake(150.f, 100.f);
        if (![[NSString stringIsEmpty:TMI_Id] isEqualToString:@""] &&
            ![[NSString stringIsEmpty:tmd_id_str] isEqualToString:@""]) {
            DeleteDevice_Request *deleteDevice_Request = [[DeleteDevice_Request alloc] init];
            deleteDevice_Request.requestArgument = @{@"tmdMemberId":TMI_Id,
                                                     @"tmdDeviceId":tmd_id_str
                                                     };
            NSLog(@"requestArgument = %@",deleteDevice_Request.requestArgument);
            [deleteDevice_Request startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
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
                    [self getdata];
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
    } else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"请先勾选设备!", @"HUD message title");;
        [hud mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.view);
        }];
        [hud hideAnimated:YES afterDelay:2.f];
    }
}

#pragma mark 编辑
- (void)edit:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        if (self.is_select == NO) {
            self.is_select = YES;
            [sender setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [sender setTitle:@"完成" forState:UIControlStateNormal];
            [sender setTitleColor:Default_Blue_Color forState:UIControlStateNormal];
            self.allselect_view.hidden = NO;
            self.delete_but.hidden = NO;
        } else {
            self.is_select = NO;
            [sender setBackgroundImage:[UIImage imageNamed:@"编辑"] forState:UIControlStateNormal];
            [sender setTitle:@"" forState:UIControlStateNormal];
            [sender setTitleColor:Default_Blue_Color forState:UIControlStateNormal];
            self.allselect_view.hidden = YES;
            self.delete_but.hidden = YES;
        }
    } else {
        if (self.is_select == NO) {
            self.is_select = YES;
            [sender setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [sender setTitle:@"完成" forState:UIControlStateNormal];
            [sender setTitleColor:Default_Blue_Color forState:UIControlStateNormal];
            self.allselect_view.hidden = NO;
            self.delete_but.hidden = NO;
        } else {
            self.is_select = NO;
            [sender setBackgroundImage:[UIImage imageNamed:@"编辑"] forState:UIControlStateNormal];
            [sender setTitle:@"" forState:UIControlStateNormal];
            [sender setTitleColor:Default_Blue_Color forState:UIControlStateNormal];
            self.allselect_view.hidden = YES;
            self.delete_but.hidden = YES;
        }
    }
    [self.tableView reloadData];
//    BOOL edit = !self.tableView.editing;
//    [self.tableView setEditing:edit animated:YES];
}

#pragma mark 无内容显示影藏
-(void)setExtraCellLineHidden: (UITableView *)tableView {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

#pragma mark 添加设备
- (void)adddevice:(UIButton *)sender {
    AddDevice_ViewController *addDevice = [[AddDevice_ViewController alloc] init];
    UIBarButtonItem * backButtonItem = [[UIBarButtonItem alloc] init];
    backButtonItem.title = @"";
    self.navigationItem.backBarButtonItem = backButtonItem;
    [self.navigationController pushViewController:addDevice animated:YES];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data_array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Equipment_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSDictionary *dictionary = self.data_array[indexPath.row];
    
    if (self.is_select == YES) {
        cell.imageView.hidden = NO;
        cell.imageView.image = [UIImage imageNamed:@"圆圈"];
        if (self.all_select == YES) {
           cell.imageView.image = [UIImage imageNamed:@"圆圈中"];
        } else {
            cell.imageView.image = [UIImage imageNamed:@"圆圈"];
        }
    } else {
        cell.imageView.hidden = YES;
    }
    
    [cell.photo_image sd_setImageWithURL:[NSURL URLWithString:PHOTO_URL([NSString stringIsEmpty:dictionary[@"tdi_icon"]])] placeholderImage:[UIImage imageNamed:@"图层1_18"]];
    cell.equipment_typename_lab.text = [NSString stringIsEmpty:dictionary[@"tdi_name"]];
    cell.equipment_location_lab.text = [NSString stringIsEmpty:dictionary[@"tdc_name"]];
    
    cell.tag = indexPath.row;
    [cell.switch_but addTarget:self action:@selector(on_off:) forControlEvents:UIControlEventValueChanged];
    
    if ([dictionary[@"tmd_is_default"] boolValue] == true) {
        [cell.defaut_device_but setTitleColor:Default_Blue_Color forState:UIControlStateNormal];
    } else {
        [cell.defaut_device_but setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Equipment_TableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (![self.allselect_array containsObject:self.data_array[indexPath.row]]) {
        [self.allselect_array addObject:self.data_array[indexPath.row]];
        cell.imageView.image = [UIImage imageNamed:@"圆圈中"];
    } else {
        [self.allselect_array removeObject:self.data_array[indexPath.row]];
        cell.imageView.image = [UIImage imageNamed:@"圆圈"];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerview = [UIView new];
    footerview.backgroundColor = [UIColor whiteColor];
    self.addDevice_but = [UIButton new];
    [self.addDevice_but addTarget:self action:@selector(adddevice:) forControlEvents:UIControlEventTouchUpInside];
    [self.addDevice_but setTitleColor:Default_Blue_Color forState:UIControlStateNormal];
    [self.addDevice_but setTitle:@"+添加设备" forState:UIControlStateNormal];
    self.addDevice_but.titleLabel.font = [UIFont systemFontOfSize:16];
    [footerview addSubview:self.addDevice_but];
    [self.addDevice_but mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(footerview);
        make.size.mas_equalTo(CGSizeMake(90, 20));
    }];
    return footerview;
}

#pragma mark switch开关
- (void)on_off:(UISwitch *)sender {
    UITableViewCell * cell = (UITableViewCell *)[[sender superview] superview];
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    self.integer = indexPath.row;
    if (sender.on == YES) {
        NSLog(@"当前设备是开");
    }else
    {
        NSLog(@"当前设备是关");
    }
    
    [self.tableView reloadData];
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
