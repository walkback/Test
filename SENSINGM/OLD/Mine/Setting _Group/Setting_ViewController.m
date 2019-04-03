//
//  Setting_ViewController.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/6/16.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "Setting_ViewController.h"
#import "AboutApp_ViewController.h"
#import "CleanApp_ViewController.h"
#import "ContactUs_ViewController.h"
#import "LogIn_ViewController.h"
#import "Macro.h"
#import <Masonry.h>

@interface Setting_ViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *signOut_button;
@end

@implementation Setting_ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"设置";
    self.navigationController.navigationBar.hidden = NO;
    self.view.backgroundColor = Line_Color;
    
    self.tableView = [[UITableView alloc] init];
    [self.tableView.layer setCornerRadius:5];
    self.tableView.layer.masksToBounds = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
    if (KIsiPhoneX) {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(98);
            make.left.equalTo(self.view).offset(10);
            make.right.equalTo(self.view).offset(-10);
            make.height.mas_equalTo(132);
        }];
    } else {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(74);
            make.left.equalTo(self.view).offset(10);
            make.right.equalTo(self.view).offset(-10);
            make.height.mas_equalTo(132);
        }];
    }

    self.signOut_button = [UIButton new];
    [self.signOut_button.layer setCornerRadius:5];
    self.signOut_button.layer.masksToBounds = YES;
    [self.signOut_button setBackgroundColor:Default_Blue_Color];
    [self.signOut_button addTarget:self action:@selector(signOut:) forControlEvents:UIControlEventTouchUpInside];
    [self.signOut_button setTitle:@"退出登录" forState:UIControlStateNormal];
    [self.view addSubview:self.signOut_button];
    [self.signOut_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-40);
        make.left.equalTo(self.view).offset(40);
        make.right.equalTo(self.view).offset(-40);
        make.height.mas_equalTo(44);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"关于软件";
    }
    if (indexPath.row == 1) {
        cell.textLabel.text = @"清除缓存";
    }
    if (indexPath.row == 2) {
        cell.textLabel.text = @"联系我们";
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        AboutApp_ViewController *aboutApp = [[AboutApp_ViewController alloc] init];
        [self.navigationController pushViewController:aboutApp animated:YES];
    }
    if (indexPath.row == 1) {
        CleanApp_ViewController *cleanApp = [[CleanApp_ViewController alloc] init];
        [self.navigationController pushViewController:cleanApp animated:YES];
    }
    if (indexPath.row == 2) {
        ContactUs_ViewController *contactUs = [[ContactUs_ViewController alloc] init];
        [self.navigationController pushViewController:contactUs animated:YES];
    }
}


#pragma mark 退出登入
- (void)signOut:(UIButton *)sender {
    LogIn_ViewController *logIn = [[LogIn_ViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:logIn];
    [UIApplication sharedApplication].keyWindow.rootViewController = nav;
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
