//
//  Timing_ViewController.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/12/17.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "Timing_ViewController.h"
#import "TimeSetting_ViewController.h"

@interface Timing_ViewController () <UITableViewDelegate,UITableViewDataSource>
{
    UITableView *tableView;
}

@end

@implementation Timing_ViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = false;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage createImageWithColor:Nav_BG_Color] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"定时";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : TEXTCOLOR,NSFontAttributeName: [UIFont systemFontOfSize:17]}];
    self.navigationController.navigationBar.tintColor = TEXTCOLOR;
    
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:242/255.0 blue:245/255.0 alpha:1.0];
    
    UIButton *delete_but = [UIButton new];
    [delete_but setTitle:@"+ 添加" forState:UIControlStateNormal];
    [delete_but setTitleColor:[UIColor colorWithRed:247/255.0 green:98/255.0 blue:92/255.0 alpha:1.0] forState:UIControlStateNormal];
    delete_but.titleLabel.font = [UIFont systemFontOfSize:16];
    [delete_but setBackgroundColor:UIColor.whiteColor];
    [self.view addSubview:delete_but];
    [delete_but mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    [[delete_but rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        UIBarButtonItem * backButtonItem = [[UIBarButtonItem alloc] init];
        backButtonItem.title = @"";
        self.navigationItem.backBarButtonItem = backButtonItem;
        TimeSetting_ViewController *timeSetting = [[TimeSetting_ViewController alloc] init];
        [self.navigationController pushViewController:timeSetting animated:true];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    return cell;
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
