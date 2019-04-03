//
//  UserManagement_ViewController.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/12/12.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "UserManagement_ViewController.h"
#import "UserManagement_Cell.h"
#import "UserInfo_ViewController.h"

@interface UserManagement_ViewController () <UITableViewDelegate,UITableViewDataSource>
{
    UITableView *tableView;
}

@property (nonatomic, strong) NSArray *data_array;

@end

@implementation UserManagement_ViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[self createImageWithColor:Nav_BG_Color] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"角色管理";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor],NSFontAttributeName: [UIFont systemFontOfSize:17]}];
    self.navigationController.navigationBar.tintColor = TEXTCOLOR;
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.data_array = @[@"个人",@"小王",@"老王",@"王老吉"];
    
    tableView = [[UITableView alloc] init];
    tableView.backgroundColor = [UIColor colorWithRed:239/255.0 green:242/255.0 blue:245/255.0 alpha:1.0];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [tableView registerClass:[UserManagement_Cell class] forCellReuseIdentifier:@"UserManagement"];
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
    return self.data_array.count + 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UserManagement_Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserManagement" forIndexPath:indexPath];
        
        cell.user_name_lab.text = @"个人";
        cell.delete_but.hidden = true;
        
        return cell;
    }
    if (indexPath.section > 0 && indexPath.section < self.data_array.count + 1) {
        UserManagement_Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserManagement" forIndexPath:indexPath];
        
        cell.user_name_lab.text = self.data_array[indexPath.section - 1];
        
        return cell;
    }
    if (indexPath.section == self.data_array.count + 1) {
        UserManagement_Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserManagement" forIndexPath:indexPath];
        
        cell.user_name_lab.text = @"+新增";
        cell.delete_but.hidden = true;
        
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == self.data_array.count + 1) {
        UIBarButtonItem * backButtonItem = [[UIBarButtonItem alloc] init];
        backButtonItem.title = @"";
        self.navigationItem.backBarButtonItem = backButtonItem;
        UserInfo_ViewController *userInfo = [[UserInfo_ViewController alloc] init];
        [self.navigationController pushViewController:userInfo animated:true];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
