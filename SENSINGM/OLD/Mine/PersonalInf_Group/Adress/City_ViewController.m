//
//  City_ViewController.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/7/4.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "City_ViewController.h"
#import "City_Request.h"
#import "Area_ViewController.h"

@interface City_ViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *data_array;

@end

@implementation City_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"选择市";
    
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
    if (![self.pid isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = NSLocalizedString(@"Preparing...", @"HUD preparing title");
        hud.minSize = CGSizeMake(150.f, 100.f);
        
        City_Request *city_Request = [[City_Request alloc] init];
        city_Request.requestArgument = @{@"pid":self.pid};
        [city_Request startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
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
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data_array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSDictionary *dictionary = self.data_array[indexPath.row];
    cell.textLabel.text = [NSString stringIsEmpty:dictionary[@"cname"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dictionary = self.data_array[indexPath.row];

    Area_ViewController *area = [[Area_ViewController alloc] init];
    area.pid = [NSString  stringIsEmpty:self.pid];
    area.pName = [NSString stringIsEmpty:self.pName];
    //区要用的id
    area.cid = [NSString stringIsEmpty:[NSString stringWithFormat:@"%@",dictionary[@"cid"]]];
    area.cName = [NSString  stringIsEmpty:[NSString stringWithFormat:@"%@",dictionary[@"cname"]]];
    [self.navigationController pushViewController:area animated:YES];
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
