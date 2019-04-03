
//
//  AddDeviceViewController.m
//  SENSINGM
//
//  Created by apple on 2018/7/2.
//  Copyright © 2018年 吴志刚. All rights reserved.
//

#import "AddDeviceViewController.h"
#import "ScanViewController.h"


@interface AddDeviceViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView * addDeviceTableView;


@end

@implementation AddDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BGCOLOR;
    
    [self  addNavigationBarWithTitle:@"添加设备" backButton:@selector(navigationBarBack:) rightImage:[UIImage  imageNamed:@"scan_image.png"] rightButton:@selector(navigationBarRightScan:)];
    _addDeviceTableView = [[UITableView  alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGT) style:UITableViewStylePlain];
    _addDeviceTableView.tableFooterView = [[UIView  alloc]init];
    _addDeviceTableView.delegate = self;
    _addDeviceTableView.dataSource = self;
    [self.view  addSubview:_addDeviceTableView];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 210;
    }
    
    if (indexPath.row == 1) {
        return 300;
    }
    
    return 33;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView  dequeueReusableCellWithIdentifier:@"addDeviceCellID"];
    if (!cell) {
        cell = [[UITableViewCell  alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"addDeviceCellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = BGCOLOR;
        
        if (indexPath.row < 2) {
            UIView * contentView = [[UIView  alloc]init];
            contentView.backgroundColor = [UIColor  whiteColor];
            contentView.layer.masksToBounds = YES;
            contentView.layer.cornerRadius = 10;
            contentView.tag = 300;
            [cell  addSubview:contentView];
            
            if (indexPath.row == 0) {
                contentView.frame = CGRectMake(10, 10, SCREEN_WIDTH - 20, 210 - 15);
            }
            if (indexPath.row == 1) {
                contentView.frame = CGRectMake(10, 10, SCREEN_WIDTH - 20, 300 - 15);
            }
        }
        
        //WithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 300 - 15)
    }
    
    UIView * contentView = (UIView *)[cell  viewWithTag:300];
    
    return cell;
}

#pragma mark ---添加设备扫一扫---
-(void)navigationBarRightScan:(UIButton *)sender
{
    //进入扫一扫界面
    ScanViewController * scanVC = [[ScanViewController  alloc]init];
    [self.navigationController pushViewController:scanVC animated:YES];
    
}

#pragma mark ---导航条返回按钮----
-(void)navigationBarBack:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark ----设置导航条-----
-(void)addNavigationBarWithTitle:(NSString *)navTitle  backButton:(SEL)backAction   rightImage:(UIImage *)image   rightButton:(SEL)rightItemAction
{
    self.title = navTitle;
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor colorWithRed:81/255.0 green:81/255.0 blue:81/255.0 alpha:1]}];
    self.navigationController.navigationBar.barTintColor = [UIColor  whiteColor];
    
    
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame=CGRectMake(0, 0, 44, 44);
    [leftBtn setImage:[UIImage imageNamed:@"top_back.png"] forState:UIControlStateNormal];
    leftBtn.imageEdgeInsets = UIEdgeInsetsMake(12, 0, 12, 24);
    [leftBtn  addTarget:self action:backAction forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftBackButtonItem = [[UIBarButtonItem  alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBackButtonItem;
    
    UIButton *rightBarBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    rightBarBtn.frame=CGRectMake(0, 0, 44, 44);
    [rightBarBtn  setImage:image forState:UIControlStateNormal];
    [rightBarBtn  addTarget:self action:rightItemAction forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightBarItem = [[UIBarButtonItem  alloc]initWithCustomView:rightBarBtn];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
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
