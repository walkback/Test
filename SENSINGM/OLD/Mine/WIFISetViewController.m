
//
//  WIFISetViewController.m
//  SENSINGM
//
//  Created by apple on 2018/7/13.
//  Copyright © 2018年 吴志刚. All rights reserved.
//

#import "WIFISetViewController.h"
#import "UDPManage.h"

@interface WIFISetViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView * wifiTableView;
@property (nonatomic, strong) NSArray * dataArray;
@property (nonatomic, strong) UITextField * nameTextField;//wifi名称
@property (nonatomic, strong) UITextField * mimaTextField;//wifi密码

@end

@implementation WIFISetViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =Line_Color;
    self.dataArray = [NSArray  arrayWithObjects:@"wifi名称:",@"wifi密码:", nil];
    UIImageView * backImageView = [[UIImageView  alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGT)];
    backImageView.image = [UIImage  imageNamed:@"music_back.png"];
    [self.view  addSubview:backImageView];
    
    [self  hadBackImageNavigationBar];
    
    _wifiTableView = [[UITableView  alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGT - 64) style:UITableViewStylePlain];
    _wifiTableView.delegate = self;
    _wifiTableView.dataSource = self;
    _wifiTableView.backgroundColor =[UIColor  clearColor];
    _wifiTableView.separatorStyle= UITableViewCellSeparatorStyleNone;
    _wifiTableView.tableFooterView = [[UIView alloc]init];
    [self.view  addSubview:_wifiTableView];
    [self setupRefresh];
}

#pragma mark - 集成刷新

-(void)setupRefresh {
    self.wifiTableView.mj_header=[YJSLoadingHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    [self.wifiTableView.mj_header beginRefreshing];
    
    self.wifiTableView.mj_footer = [YJSLoadingFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
}
-(void)headerRefresh {
    [self getdata_wifi];
    [self.wifiTableView.mj_header endRefreshing];
}
-(void)footerRefresh {
    
    [self getdata_wifi];
    [self.wifiTableView.mj_footer endRefreshing];
}
-(void)getdata_wifi
{
    [self.wifiTableView reloadData];
}

#pragma mark ----UITableViewDelegate,UITableViewDataSource----
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 || indexPath.row == 3) {
        return 80;
    }
    return 50;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * identifier = @"wifiCell";
    UITableViewCell * wifiCell = [tableView  dequeueReusableCellWithIdentifier:identifier];
    if (!wifiCell) {
        wifiCell = [[UITableViewCell  alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        wifiCell.selectionStyle =  UITableViewCellSelectionStyleNone;
        wifiCell.backgroundColor = [UIColor clearColor];
        if (indexPath.row == 0) {
            UIImageView * wifiHeadImageView = [[UIImageView  alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 40, 0, 80, 80)];
            wifiHeadImageView.image = [UIImage imageNamed:@"wifi_set.png"];
            [wifiCell.contentView  addSubview:wifiHeadImageView];
        }
        if (indexPath.row == 1 || indexPath.row == 2) {
            UILabel * leftTitleLabel = [[UILabel  alloc]initWithFrame:CGRectMake(20, 10, 70, 30)];
            leftTitleLabel.text = self.dataArray[indexPath.row - 1];
            leftTitleLabel.textAlignment = NSTextAlignmentLeft;
            leftTitleLabel.textColor = RGB(81, 81, 81);
            leftTitleLabel.font = [UIFont  systemFontOfSize:16];
            [wifiCell.contentView  addSubview:leftTitleLabel];
            
            UITextField *  contentTextField = [[UITextField  alloc]initWithFrame:CGRectMake(CGRectGetMaxX(leftTitleLabel.frame), 5, SCREEN_WIDTH - 110, 40)];
            contentTextField.borderStyle =UITextBorderStyleRoundedRect;
            contentTextField.tag = 40;
            [wifiCell.contentView  addSubview:contentTextField];

        }
        if (indexPath.row == 3) {
            UIButton * justSetWifiButton = [UIButton buttonWithType:UIButtonTypeCustom];
            justSetWifiButton.frame = CGRectMake(20, 30, [UIScreen mainScreen].bounds.size.width - 40, 35);
            justSetWifiButton.backgroundColor = RGB(141, 189, 202);
            [justSetWifiButton setTitle:@"一键配置网络" forState:UIControlStateNormal];
            [justSetWifiButton  setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            justSetWifiButton.layer.shadowColor = [UIColor lightGrayColor].CGColor;
            justSetWifiButton.layer.shadowOffset = CGSizeMake(5, 5);
            justSetWifiButton.layer.shadowOpacity = 1;
            justSetWifiButton.layer.shadowRadius = 9.0;
            justSetWifiButton.layer.cornerRadius = 9.0;
            justSetWifiButton.clipsToBounds = NO;
            [justSetWifiButton  addTarget:self action:@selector(justSetWifiButtonCLick:) forControlEvents:UIControlEventTouchUpInside];
            [wifiCell.contentView addSubview:justSetWifiButton];
        }
      
    }
      if (indexPath.row == 1 || indexPath.row == 2)
      {
          UITextField * contentTF =(UITextField *) [wifiCell.contentView viewWithTag:40];
          if (indexPath.row == 1) {
              contentTF.text = [ManagerTool getWifiName];
              self.nameTextField = contentTF;
          }else
          {
              contentTF.placeholder = @"请输入该WIFI的密码";
              self.mimaTextField =  contentTF;
          }
      }
    return wifiCell;
}

#pragma mark----一键配置网络----
-(void)justSetWifiButtonCLick:(UIButton *)sender
{
    NSString * mimaContent = self.mimaTextField.text;
    NSString * nameContent = self.nameTextField.text;
    if ( [nameContent  isEqualToString:@""] || nameContent == nil) {
        [ManagerTool  alert:@"请输入WIFI名称"];
        return;
    }
    if ( [mimaContent  isEqualToString:@""] || mimaContent == nil) {
        [ManagerTool  alert:@"请输入密码"];
        return;
    }
    [[UDPManage shareUDPManage] broadcastWithWifiName:nameContent passWord:mimaContent getInfo:^(NSString *UDPdata) {
        
    }];
}
#pragma mark ----设置导航条内容-------
-(void)hadBackImageNavigationBar
{
    UIView *navigationBar=[[UIView alloc]initWithFrame:CGRectMake(0, 0,WIDTH, 64)];
    [self.view addSubview:navigationBar];
    
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame=CGRectMake(0, 20, 44, 44);
    [leftBtn setImage:[UIImage imageNamed:@"top_back.png"] forState:UIControlStateNormal];
    [leftBtn  addTarget:self action:@selector(navigationBarBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftBtn];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake((WIDTH-230)/2,CGRectGetMinY(leftBtn.frame)+8, 230, 20)];
    titleLabel.text=@"WIFI设置";
    titleLabel.textColor = [UIColor colorWithRed:81/255.0 green:81/255.0 blue:81/255.0 alpha:1];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.font=[UIFont systemFontOfSize:16];
    [navigationBar addSubview:titleLabel];
}
-(void)addNavigationBarUI
{
    self.navigationItem.title = @"WIFI设置";
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSFontAttributeName:[UIFont boldSystemFontOfSize:17],NSForegroundColorAttributeName:[UIColor colorWithRed:81/255.0 green:81/255.0 blue:81/255.0 alpha:1]}];
    self.navigationController.navigationBar.barTintColor = [UIColor  whiteColor];
    
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame=CGRectMake(0, 0, 44, 44);
    [leftBtn setImage:[UIImage imageNamed:@"top_back.png"] forState:UIControlStateNormal];
    leftBtn.imageEdgeInsets = UIEdgeInsetsMake(12, 0, 12, 24);
    [leftBtn  addTarget:self action:@selector(navigationBarBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftBackButtonItem = [[UIBarButtonItem  alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBackButtonItem;
    
}
#pragma mark ----返回按钮---
-(void)navigationBarBack:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
