
//
//  DeviceViewController.m
//  SENSINGM
//
//  Created by apple on 2018/7/2.
//  Copyright © 2018年 吴志刚. All rights reserved.
//

#import "DeviceViewController.h"
#import "DeviceTableViewCell.h"
#import "AddDeviceViewController.h"
#import "GroupDevice_Request.h"

@interface DeviceViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView * deviceTableView;
@property (nonatomic, strong)NSMutableArray * deviceArray;

@property (nonatomic, strong) UIImageView * noContentImageView;
@property (nonatomic, strong) UILabel * noContentLabel;


@end

@implementation DeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor  whiteColor];
    self.deviceArray = [NSMutableArray  array];
    [self   addNavigationBar];
    _deviceTableView = [[UITableView  alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGT) style:UITableViewStylePlain];
    _deviceTableView.showsVerticalScrollIndicator = NO;
    _deviceTableView.delegate = self;
    _deviceTableView.dataSource = self;
    [_deviceTableView registerClass:[DeviceTableViewCell class] forCellReuseIdentifier:@"deviceCellID"];
    [self.view  addSubview:_deviceTableView];
    
    [self  toGetDeviceRequest];
}

#pragma mark----获取组的接口请求---
-(void)toGetDeviceRequest
{
    NSString * tmiID = [USER_DEF  objectForKey:@"tmiId"];
    NSLog(@"---输出一下会员id = %@",tmiID);
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = NSLocalizedString(@"Preparing...", @"HUD preparing title");
    hud.minSize = CGSizeMake(150.f, 100.f);
    GroupDevice_Request * groupRequest = [[GroupDevice_Request alloc]init];
    NSLog(@"---组id = %@",self.groupId);
    groupRequest.requestArgument = @{@"tmiId":tmiID,@"tmgId":self.groupId};
    [groupRequest  startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
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
            if (self.deviceArray.count == 0) {
                self.deviceTableView.hidden = YES;
                [self addNoContentUIWithMessgae:message];

            }
        } else {
            [hud hideAnimated:YES];
            NSArray * tbMemberGroupList = request.responseJSONObject[@"tbMemberGroupList"];
            [self.deviceArray removeAllObjects];
            for (NSDictionary * memberList in tbMemberGroupList) {
                [self.deviceArray addObject:memberList];
            }
        }
        [self.deviceTableView  reloadData];
        
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


#pragma mark ----添加没有数据的时候的内容----
-(void)addNoContentUIWithMessgae:(NSString *)messgae
{
    _noContentImageView = [[UIImageView  alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 75, SCREEN_HEIGT/2 - 75, 150, 150)];
    _noContentImageView.image = [UIImage  imageNamed:@"clock_noContent.png"];
    [self.view  addSubview:_noContentImageView];
    _noContentLabel = [[UILabel  alloc] initWithFrame:CGRectMake(_noContentImageView.frame.origin.x, CGRectGetMaxY(_noContentImageView.frame) + 10, _noContentImageView.frame.size.width, 20)];
    _noContentLabel.font = [UIFont systemFontOfSize:14];
    _noContentLabel.text = messgae;
    [self.view addSubview:_noContentLabel];
}
-(void)addNavigationBar
{
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor colorWithRed:81/255.0 green:81/255.0 blue:81/255.0 alpha:1]}];
    self.navigationController.navigationBar.barTintColor = [UIColor  whiteColor];
    
    
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame=CGRectMake(0, 0, 44, 44);
    [leftBtn setImage:[UIImage imageNamed:@"top_back.png"] forState:UIControlStateNormal];
    leftBtn.imageEdgeInsets = UIEdgeInsetsMake(12, 0, 12, 24);
    [leftBtn  addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftBackButtonItem = [[UIBarButtonItem  alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBackButtonItem;
    
    UIButton *rightBarBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    rightBarBtn.frame=CGRectMake(0, 0, 44, 44);
    [rightBarBtn  setImage:[UIImage imageNamed:@"add_itemBar.png"] forState:UIControlStateNormal];
    [rightBarBtn  addTarget:self action:@selector(rightBarBtnAddDeviceClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightBarItem = [[UIBarButtonItem  alloc]initWithCustomView:rightBarBtn];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
}
#pragma mark ---导航条添加设备按钮---
-(void)rightBarBtnAddDeviceClick:(UIButton *)sender
{
    AddDeviceViewController * addDeviceVC = [[AddDeviceViewController  alloc]init];
    [self.navigationController pushViewController:addDeviceVC animated:YES];
}

#pragma mark ---导航条返回按钮----
-(void)backButtonClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DeviceTableViewCell * cell = [tableView  dequeueReusableCellWithIdentifier:@"deviceCellID" forIndexPath:indexPath];
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
