//
//  UserDevice_ViewController.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/12/12.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "UserDevice_ViewController.h"
#import "WristBandDevice_Cell.h"
#import "ChestHanging_Cell.h"
#import "WristBandHome_PageController.h"
#import "ChestHangingHome_PageController.h"

@interface UserDevice_ViewController () <UITableViewDelegate,UITableViewDataSource>
{
    UITableView *tableView;
}

@end

@implementation UserDevice_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    tableView = [[UITableView alloc] init];
    tableView.backgroundColor = [UIColor colorWithRed:239/255.0 green:242/255.0 blue:245/255.0 alpha:1.0];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [tableView registerClass:[WristBandDevice_Cell class] forCellReuseIdentifier:@"WristBandDevice"];
    [tableView registerClass:[ChestHanging_Cell class] forCellReuseIdentifier:@"ChestHanging"];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 200;
    tableView.tableFooterView = [UIView new];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        WristBandDevice_Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"WristBandDevice" forIndexPath:indexPath];
        
        cell.device_imagev.image = [UIImage imageNamed:@"手环"];
        cell.device_name_lab.text = @"智能手环";
        cell.device_data_lab.text = @"数据更新: 2";
        cell.electricity_lab.text = @"电量: 10%";
        
        cell.stepcount_lab.text = @"10K步";
        cell.sleeptime_lab.text = @"12小时30分";
        cell.heartbeat_num_lab.text = @"72次/分";
        
        cell.stepcount_update_lab.text = @"12:30更新";
        cell.sleeptime_update_lab.text = @"12:30更新";
        cell.heartbeat_update_lab.text = @"12:30更新";
        
        return cell;
    }
    
    if (indexPath.section == 1) {
        ChestHanging_Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChestHanging" forIndexPath:indexPath];
        
        cell.device_imagev.image = [UIImage imageNamed:@"手环"];
        cell.device_name_lab.text = @"智能胸挂";
        cell.device_data_lab.text = @"数据更新: 2";
        cell.electricity_lab.text = @"电量: 10%";
        
        cell.suncount_lab.text = @"500LX";
        cell.healthvalue_lab.text = @"0.8";
        cell.evcount_lab.text = @"0.74eV";
        cell.stepcount_lab.text = @"10K步";
        
        cell.suncount_update_lab.text = @"12:30更新";
        cell.healthvalue_update_lab.text = @"12:30更新";
        cell.evcount_update_lab.text = @"12:30更新";
        cell.stepcount_update_lab.text = @"12:30更新";
        
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UIBarButtonItem * backButtonItem = [[UIBarButtonItem alloc] init];
        backButtonItem.title = @"";
        self.navigationItem.backBarButtonItem = backButtonItem;
        WristBandHome_PageController *wristBand = [[WristBandHome_PageController alloc] init];
        wristBand.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:wristBand animated:true];
    }
    if (indexPath.section == 1) {
        UIBarButtonItem * backButtonItem = [[UIBarButtonItem alloc] init];
        backButtonItem.title = @"";
        self.navigationItem.backBarButtonItem = backButtonItem;
        ChestHangingHome_PageController *chestHanging = [[ChestHangingHome_PageController alloc] init];
        chestHanging.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:chestHanging animated:true];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 12;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header_view = [UIView new];
    header_view.backgroundColor = [UIColor colorWithRed:239/255.0 green:242/255.0 blue:245/255.0 alpha:1.0];
    return header_view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer_view = [UIView new];
    return footer_view;
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
