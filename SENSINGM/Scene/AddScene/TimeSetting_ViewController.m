//
//  TimeSetting_ViewController.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/12/17.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "TimeSetting_ViewController.h"
#import "TimeSetting_Cell.h"
#import "CycleTime_ViewController.h"

@interface TimeSetting_ViewController () <UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tableView;
}

@end

@implementation TimeSetting_ViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = false;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage createImageWithColor:Nav_BG_Color] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"时间设定";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : TEXTCOLOR,NSFontAttributeName: [UIFont systemFontOfSize:17]}];
    self.navigationController.navigationBar.tintColor = TEXTCOLOR;
    
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:242/255.0 blue:245/255.0 alpha:1.0];
    
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
    [tableView registerClass:[TimeSetting_Cell class] forCellReuseIdentifier:@"TimeSetting"];
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
        make.height.mas_equalTo(417);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TimeSetting_Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimeSetting" forIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 27;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header_view = [UIView new];
    
    header_view.backgroundColor = UIColor.whiteColor;
    
    UILabel *title_lab = [UILabel new];
    title_lab.font = [UIFont systemFontOfSize:14];
    title_lab.textColor = TEXTCOLOR;
    [header_view addSubview:title_lab];
    [title_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(header_view);
        make.left.equalTo(header_view.mas_left).offset(16);
        make.right.equalTo(header_view);
    }];
    
    if (section == 0) {
        title_lab.text = @"开启时间设定";
    }
    if (section == 1) {
        title_lab.text = @"关闭时间设定";
    }
    
    UIImageView *line_imageview = [UIImageView new];
    line_imageview.backgroundColor = Line_Color;
    [header_view addSubview:line_imageview];
    [line_imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(header_view);
        make.height.mas_equalTo(1);
    }];
    
    return header_view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return 44;
    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer_view = [UIView new];
    
    footer_view.backgroundColor = UIColor.whiteColor;
    
    if (section == 1) {
        UIImageView *line_imageview = [UIImageView new];
        line_imageview.backgroundColor = Line_Color;
        [footer_view addSubview:line_imageview];
        [line_imageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(footer_view);
            make.height.mas_equalTo(1);
        }];
        
        UILabel *title_lab = [UILabel new];
        title_lab.font = [UIFont systemFontOfSize:14];
        title_lab.text = @"重复";
        title_lab.textColor = TEXTCOLOR;
        [footer_view addSubview:title_lab];
        [title_lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(footer_view);
            make.left.equalTo(footer_view).offset(15);
            make.width.mas_equalTo(38);
        }];
        
        UIButton *push_but = [UIButton new];
        [footer_view addSubview:push_but];
        [push_but mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(footer_view);
        }];
        
        [[push_but rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            UIBarButtonItem * backButtonItem = [[UIBarButtonItem alloc] init];
            backButtonItem.title = @"";
            self.navigationItem.backBarButtonItem = backButtonItem;
            CycleTime_ViewController *cycleTime = [[CycleTime_ViewController alloc] init];
            [self.navigationController pushViewController:cycleTime animated:true];
        }];
        
        UIImageView *push_imagev = [UIImageView new];
        push_imagev.image = [UIImage imageNamed:@"右-箭头"];
        [footer_view addSubview:push_imagev];
        [push_imagev mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(footer_view);
            make.right.equalTo(footer_view).offset(-15);
            make.size.mas_equalTo(CGSizeMake(17, 17));
        }];
        
        UILabel *content_lab = [UILabel new];
        content_lab.font = [UIFont systemFontOfSize:14];
        content_lab.textColor = TEXTCOLOR;
        [footer_view addSubview:content_lab];
        [content_lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(footer_view);
            make.left.equalTo(footer_view).offset(15);
            make.width.mas_equalTo(38);
        }];
    }

    return footer_view;
}

- (void)startPickerChanged:(UIDatePicker *)datepicker {
    NSLog(@"start = %@",datepicker.date);
}

- (void)endPickerChanged:(UIDatePicker *)datepicker {
    NSLog(@"end = %@",datepicker.date);
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
