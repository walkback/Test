//
//  Area_ViewController.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/7/4.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "Area_ViewController.h"
#import "PersonalInf_ViewController.h"
#import "Area_Request.h"

@interface Area_ViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *data_array;

@end

@implementation Area_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"选择区";
    
    self.data_array = [NSArray array];
    self.view.backgroundColor = Line_Color;
    
    self.tableView = [[UITableView alloc] init];
    [self.tableView.layer setCornerRadius:5];
    self.tableView.layer.masksToBounds = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
    if (KIsiPhoneX) {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(44 + 44 + 10);
            make.left.equalTo(self.view).offset(10);
            make.right.equalTo(self.view).offset(-10);
            make.bottom.equalTo(self.view).offset(-10);
        }];
    } else {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(74);
            make.left.equalTo(self.view).offset(10);
            make.right.equalTo(self.view).offset(-10);
            make.bottom.equalTo(self.view).offset(-10);
        }];
    }

    [self getData];
}

- (void)getData {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = NSLocalizedString(@"Preparing...", @"HUD preparing title");
    hud.minSize = CGSizeMake(150.f, 100.f);
    if (![self.cid isEqualToString:@""]) {
        Area_Request *area_Request = [[Area_Request alloc] init];
        area_Request.requestArgument = @{@"cid":self.cid};
        [area_Request startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
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
                
                self.data_array = request.responseJSONObject[@"list"];
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
        hud.label.text = NSLocalizedString(@"缺少参数!", @"HUD message title");;
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSDictionary *dictionary = self.data_array[indexPath.row];
    cell.textLabel.text = [NSString stringIsEmpty:dictionary[@"oname"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dictionary = self.data_array[indexPath.row];
    NSString * oid = [NSString stringIsEmpty:[NSString stringWithFormat:@"%@",dictionary[@"oid"]]];
    NSString * oName = [NSString  stringIsEmpty:dictionary[@"oname"]];
    NSDictionary * areaDic = @{@"pid":[NSString  stringIsEmpty:self.pid],@"pName":[NSString  stringIsEmpty:self.pName],@"cid":[NSString  stringIsEmpty:self.cid],@"cName":[NSString  stringIsEmpty:self.cName],@"oid":oid,@"oName":oName};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AreaChange"
                                                        object:nil
                                                      userInfo:areaDic];
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[PersonalInf_ViewController class]]) {
            PersonalInf_ViewController *personalInf =(PersonalInf_ViewController *)controller;
            [self.navigationController popToViewController:personalInf animated:YES];
        }
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
