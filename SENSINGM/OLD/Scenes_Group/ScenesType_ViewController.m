//
//  ScenesType_ViewController.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/6/27.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "ScenesType_ViewController.h"
#import "ScenesType_TableViewCell.h"
#import "ScenesType_Request.h"

@interface ScenesType_ViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *close_botton;
@property (nonatomic, strong) UIButton *submit_botton;

@property (nonatomic, strong) NSArray *data_array;

@end

@implementation ScenesType_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.modalPresentationStyle = UIModalPresentationCustom;
    
    self.data_array = [NSArray array];
    
    self.tableView = [[UITableView alloc] init];
    [self.tableView.layer setCornerRadius:5];
    self.tableView.layer.masksToBounds = YES;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerClass:[ScenesType_TableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView  setLayoutMargins:UIEdgeInsetsZero]; // 分割线满屏
    [self.tableView  setSeparatorInset:UIEdgeInsetsZero]; // 分割线满屏
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(220);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(select_data:) name:@"select_data" object:nil];
}

- (void)select_data:(NSNotification *)notif {
    NSArray *array = notif.object;
    self.tmd_id = [array objectAtIndex:0];
    self.tsc_id = [array objectAtIndex:1];
    [self getdata];
    [self.tableView reloadData];
}

#pragma mark 获取数据源
- (void)getdata{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = NSLocalizedString(@"Preparing...", @"HUD preparing title");
    hud.minSize = CGSizeMake(150.f, 100.f);

    if (![[NSString stringIsEmpty:self.tsc_id] isEqualToString:@""] && ![[NSString stringIsEmpty:self.tmd_id] isEqualToString:@""]) {
        ScenesType_Request *scenesType_Request = [[ScenesType_Request alloc] init];
        scenesType_Request.requestArgument = @{@"tscId":self.tsc_id,@"tsDeviceId":self.tmd_id};
        [scenesType_Request startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
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
                self.data_array = request.responseJSONObject[@"tbSceneCatalogList"];
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
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"缺少必要参数!", @"HUD message title");;
        [hud mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.view);
        }];
        [hud hideAnimated:YES afterDelay:2.f];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data_array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ScenesType_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary *dictionary = self.data_array[indexPath.row];
    cell.textLabel.text = [NSString stringIsEmpty:dictionary[@"ts_name"]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerview = [UIView new];
    
    self.close_botton = [UIButton new];
    [self.close_botton setTitle:@"关闭" forState:UIControlStateNormal];
    self.close_botton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.close_botton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.close_botton addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    [headerview addSubview:self.close_botton];
    [self.close_botton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(headerview);
        make.left.equalTo(headerview).offset(20);
        make.size.mas_equalTo(CGSizeMake(40, 19.5));
    }];
    
    self.submit_botton = [UIButton new];
    [self.submit_botton setTitle:@"确定" forState:UIControlStateNormal];
    self.submit_botton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.submit_botton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.close_botton addTarget:self action:@selector(determine:) forControlEvents:UIControlEventTouchUpInside];
    [headerview addSubview:self.submit_botton];
    [self.submit_botton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(headerview);
        make.right.equalTo(headerview).offset(-20);
        make.size.mas_equalTo(CGSizeMake(40, 19.5));
    }];

    UIImageView *lineimage = [UIImageView new];
    lineimage.backgroundColor = Line_Color;
    [headerview addSubview:lineimage];
    [lineimage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(headerview);
        make.height.mas_equalTo(1);
    }];
    
    return headerview;
}

#pragma mark 关闭
- (void)close:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 确定
- (void)determine:(UIButton *)sender {
    
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
