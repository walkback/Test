//
//  AccountSafe_ViewController.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/6/15.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "AccountSafe_ViewController.h"
#import "AccountSafe_TableViewCell.h"
#import "ChangePhone_ViewController.h"
#import "ChangePassWord_ViewController.h"
#import "Macro.h"
#import <Masonry.h>

@interface AccountSafe_ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation AccountSafe_ViewController

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
    
    self.title = @"账号与安全";
    self.navigationController.navigationBar.hidden = NO;
    self.view.backgroundColor = Line_Color;
    
    self.tableView = [[UITableView alloc] init];
    [self.tableView.layer setCornerRadius:5];
    self.tableView.layer.masksToBounds = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[AccountSafe_TableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
    if (KIsiPhoneX) {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(98);
            make.left.equalTo(self.view).offset(10);
            make.right.equalTo(self.view).offset(-10);
            make.height.mas_equalTo(88);
        }];
    } else {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(74);
            make.left.equalTo(self.view).offset(10);
            make.right.equalTo(self.view).offset(-10);
            make.height.mas_equalTo(88);
        }];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AccountSafe_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        cell.change_lab.text = @"更改手机号";
    }
    if (indexPath.row == 1) {
        cell.change_lab.text = @"更改密码";
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        ChangePhone_ViewController *ChangePhone = [[ChangePhone_ViewController alloc] init];
        [self.navigationController pushViewController:ChangePhone animated:YES];
    }
    if (indexPath.row == 1) {
        ChangePassWord_ViewController *ChangePassWord = [[ChangePassWord_ViewController alloc] init];
        [self.navigationController pushViewController:ChangePassWord animated:YES];
    }
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
