//
//  Scenes_ViewController.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/6/19.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "Scenes_ViewController.h"
#import "Scenes_CollectionViewCell.h"
#import "ScenesType_ViewController.h"
#import "Scenes_Request.h"
#import "ScenesType_Request.h"
#import "BindingDevice_Request.h"
#import "ScenesType_TableViewCell.h"
#import "Macro.h"
#import <Masonry.h>
#import "MusicMode_ViewController.h"

#define numberRow  3
#define screenWidth [UIScreen mainScreen].bounds.size.width

@interface Scenes_ViewController () <UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
{
    UILabel *circleLabel;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *data_array;

@property (nonatomic, strong) UIScrollView *scenes_scroll;
@property (nonatomic, strong) UIButton *image_button;
@property (nonatomic, strong) NSMutableArray *select_data_array;

@property (nonatomic, strong) NSArray *scenes_data_array;
@property (nonatomic, strong) NSArray *device_data_array;
@property (nonatomic, strong) NSDictionary *dictionary;
@property (nonatomic, strong) UIButton *beginSpeedSedBtn;
@property (nonatomic, strong) NSString *tsc_id_str;
@end

@implementation Scenes_ViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.mm_drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeNone;
    self.mm_drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeNone;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.select_data_array = [NSMutableArray array];
    self.scenes_data_array = [NSArray array];
    self.device_data_array = [NSArray array];
    self.data_array = [NSArray array];
    self.beginSpeedSedBtn = nil;
    
    self.title = @"场景";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame=CGRectMake(0, 0, 44, 44);
    [leftBtn setImage:[UIImage imageNamed:@"music"] forState:UIControlStateNormal];
    leftBtn.imageEdgeInsets = UIEdgeInsetsMake(12, 0, 12, 24);
    [leftBtn  addTarget:self action:@selector(openDrawer:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftBackButtonItem = [[UIBarButtonItem  alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBackButtonItem;
    
//    [self datadevice];
//    [self header_equipment];
//    [self CollectionView_layout];
    [self dataforscenes];
}

#pragma mark 场景
- (void)header_equipment{
    if (KIsiPhoneX) {
         self.scenes_scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 89, WIDTH, 70)];
    } else {
        self.scenes_scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 74, WIDTH, 70)];
    }

    self.scenes_scroll.backgroundColor = [UIColor whiteColor];
    self.scenes_scroll.contentOffset = CGPointMake(self.scenes_data_array.count * 155 + (self.scenes_data_array.count - 1) * 20, 0);
    [self.view addSubview:self.scenes_scroll];
    self.scenes_scroll.delegate = self;
    self.scenes_scroll.showsHorizontalScrollIndicator = NO;
    self.scenes_scroll.contentSize = CGSizeMake(self.scenes_data_array.count * 155 + (self.scenes_data_array.count - 1) * 20, 0);

    for (int i = 0; i < self.scenes_data_array.count; i++) {
        NSDictionary *dictionary = self.scenes_data_array[i];
        NSLog(@"dictionary = %@",dictionary);
        self.image_button = [UIButton new];
        [self.image_button setTitle:[NSString stringIsEmpty:dictionary[@"tsc_name"]] forState:UIControlStateNormal];
        [self.image_button addTarget:self action:@selector(select_device:) forControlEvents:UIControlEventTouchUpInside];
        [self.scenes_scroll addSubview:self.image_button];
        [self.image_button setBackgroundColor:[UIColor colorWithRed:226/255.0 green:242/255.0 blue:255/255.0 alpha:1]];
        self.image_button.tag = i;
        [self.image_button.layer setCornerRadius:3];
        self.image_button.layer.masksToBounds = YES;
        [self.image_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.scenes_scroll);
            make.left.equalTo(self.scenes_scroll).offset(i*155 + 10 * (i + 1));
            make.size.mas_equalTo(CGSizeMake(155, 70));
        }];
    }
    
    self.tableView = [[UITableView alloc] init];
    [self.tableView registerClass:[ScenesType_TableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scenes_scroll.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.bottom.equalTo(self.view);
    }];
    [self setExtraCellLineHidden:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;// 去掉分割线
}

#pragma mark 选择场景
- (void)select_device:(UIButton *)sender {
    NSDictionary *dictionary = self.scenes_data_array[sender.tag];
    self.tsc_id_str = [NSString stringIsEmpty:dictionary[@"tsc_id"]];
    if (self.beginSpeedSedBtn == nil) {
        sender.selected = YES;
        self.beginSpeedSedBtn = sender;
        [self.beginSpeedSedBtn.layer setBorderWidth:1];
        [self.beginSpeedSedBtn.layer setBorderColor:[Default_Blue_Color CGColor]];
        [self.beginSpeedSedBtn setBackgroundImage:[UIImage imageNamed:@"圆角矩形2"] forState:UIControlStateNormal];
    } else if (self.beginSpeedSedBtn == sender) {
        sender.selected = NO;
        self.beginSpeedSedBtn = nil;
        [sender.layer setBorderWidth:1];
        [sender.layer setBorderColor:[[UIColor whiteColor] CGColor]];
        [self.beginSpeedSedBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [sender setBackgroundColor:[UIColor colorWithRed:226/255.0 green:242/255.0 blue:255/255.0 alpha:1]];
    } else {
        self.beginSpeedSedBtn.selected = NO;
        [self.beginSpeedSedBtn.layer setBorderWidth:1];
        [self.beginSpeedSedBtn.layer setBorderColor:[[UIColor whiteColor] CGColor]];
        [self.beginSpeedSedBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [sender setBackgroundColor:[UIColor colorWithRed:226/255.0 green:242/255.0 blue:255/255.0 alpha:1]];
        sender.selected = YES;
        self.beginSpeedSedBtn = sender;
        [self.beginSpeedSedBtn.layer setBorderWidth:1];
        [self.beginSpeedSedBtn.layer setBorderColor:[Default_Blue_Color CGColor]];
        [sender setBackgroundImage:[UIImage imageNamed:@"圆角矩形2"] forState:UIControlStateNormal];
    }
    [self getdata];
}

#pragma mark 场景列表
- (void)getdata{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = NSLocalizedString(@"正在加载...", @"HUD preparing title");
    hud.minSize = CGSizeMake(150.f, 100.f);
    self.data_array = [NSArray array];
    if (![[NSString stringIsEmpty:self.tsc_id_str] isEqualToString:@""]) {
        ScenesType_Request *scenesType_Request = [[ScenesType_Request alloc] init];
        scenesType_Request.requestArgument = @{@"tscId":self.tsc_id_str};
        [scenesType_Request startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
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
                self.data_array = request.responseJSONObject[@"tbSceneCatalogList"];
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
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"缺少必要参数!", @"HUD message title");;
        [hud mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.view);
        }];
        [hud hideAnimated:YES afterDelay:2.f];
    }
}

#pragma mark 无内容显示白色
-(void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


/**
#pragma mark UICollectionView
- (void)CollectionView_layout {
    CGFloat labelWidth = (WIDTH - 20)/numberRow;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(50, 50);
    layout.minimumLineSpacing = 2;
    layout.minimumInteritemSpacing = 2;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 94 + labelWidth, WIDTH - 20, 300)  collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView.layer setCornerRadius:5];
    self.collectionView.layer.masksToBounds = YES;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[Scenes_CollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:self.collectionView ];
}

#pragma mark 获取绑定设备
- (void)datadevice {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = NSLocalizedString(@"Preparing...", @"HUD preparing title");
    hud.minSize = CGSizeMake(150.f, 100.f);
    
    BindingDevice_Request *bindingDevice_Request = [[BindingDevice_Request alloc] init];
    bindingDevice_Request.requestArgument = @{@"tmiId":TMI_Id};
    [bindingDevice_Request startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
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
            self.device_data_array = request.responseJSONObject[@"tbMemberDeviceList"];

        }
        [self.collectionView reloadData];
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
**/

#pragma mark 获取场景
- (void)dataforscenes {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = NSLocalizedString(@"Preparing...", @"HUD preparing title");
    hud.minSize = CGSizeMake(150.f, 100.f);

    Scenes_Request *scenes_request = [[Scenes_Request alloc] init];
    scenes_request.requestArgument = nil;
    [scenes_request startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
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
            self.scenes_data_array = request.responseJSONObject[@"tbSceneCatalogList"];
            [self header_equipment];
        }
        [self.collectionView reloadData];
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

#pragma mark 侧边栏
- (void)openDrawer:(UIButton *)sender {
    MusicMode_ViewController * musicVC = [[MusicMode_ViewController  alloc]init];
    [self.navigationController pushViewController:musicVC animated:YES];

  //  [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

// 滚动到最近的item
- (void)snapToNearestItem{
    CGFloat pageSize = (WIDTH - 20)/numberRow;
    CGPoint targetOffset = [self nearestTargetOffsetForOffset:self.scenes_scroll.contentOffset];
    [self.scenes_scroll setContentOffset:targetOffset animated:YES];
    UIButton *button = (UIButton *)[self.scenes_scroll viewWithTag:3+targetOffset.x/pageSize+100];
    button.backgroundColor = [UIColor redColor];
}

// 找到最近目标点
- (CGPoint)nearestTargetOffsetForOffset:(CGPoint)offset{
    CGFloat pageSize = (WIDTH - 20)/numberRow;
    NSInteger page = roundf(offset.x / pageSize);
    CGFloat targetX = pageSize * page;
    return CGPointMake(targetX, 0);
}
// 即将拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    circleLabel.textColor = [UIColor clearColor];
    circleLabel.backgroundColor = [UIColor clearColor];
}

// 结束减速
- (void)scrollViewDidEndDecelerating:(nonnull UIScrollView *)scrollView{
    if (scrollView == self.scenes_scroll) {
        [self snapToNearestItem];
    }
}

// 结束拖拽
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView == self.scenes_scroll) {
        if (!decelerate) {
            [self snapToNearestItem];
        }
    }
}


#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data_array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ScenesType_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary *dictionary = self.data_array[indexPath.row];
    cell.textLabel.text = [NSString stringIsEmpty:dictionary[@"ts_name"]];
    NSLog(@"输出一下这个数的结果 = %@",dictionary[@"tsc_remarks"]);
    cell.textLabel.textColor = Default_Blue_Color;
    [cell.layer setCornerRadius:10];
    cell.layer.masksToBounds = YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ScenesType_TableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = Default_Blue_Color;
    cell.textLabel.textColor = [UIColor whiteColor];
    NSDictionary *dictionary = self.data_array[indexPath.row];
    NSString * contentColor =  dictionary[@"ts_para"];
    NSArray * colors = [contentColor  componentsSeparatedByString:@","];
    NSString * recommend = [RecommedManager  toSetLightAmountAaa:colors[0] bbb:colors[1] ccc:colors[2]];
    [[AyncSocketManager  shareAyncManager] postRecommed:recommend result:^(NSString *task) {
        if ([task  isEqualToString:@"DMX5OK"]) {
            [ManagerTool  alert:@"设置颜色成功!"];
        }else
        {
            [ManagerTool  alert:@"设置颜色失败！"];
        }
    }];
    

}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    ScenesType_TableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
    cell.textLabel.textColor = Default_Blue_Color;
}



/**
#pragma mark 左侧滑出视图
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

#pragma mark UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.scenes_data_array.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    Scenes_CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];

    NSDictionary *scenes_inf_dic = self.scenes_data_array[indexPath.row];
    
    cell.tag = indexPath.row;
    cell.title_label.text = [NSString stringIsEmpty:scenes_inf_dic[@"tsc_remarks"]];
    [cell.imageview sd_setImageWithURL:[NSURL URLWithString:PHOTO_URL([NSString stringIsEmpty:scenes_inf_dic[@"tsc_icon_file"]])] placeholderImage:[UIImage imageNamed:@"55"]];

    return cell;
}

#pragma mark  定义每个UICollectionView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return  CGSizeMake(120, 120);
}

#pragma mark  定义整个CollectionViewCell与整个View的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20, (WIDTH - 240) / 3, 0 , (WIDTH - 240) / 3);//（上、左、下、右）
}

#pragma mark UICollectionView 设置是否允许选中
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark UICollectionView 选中操作
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    Scenes_CollectionViewCell *cell =(Scenes_CollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSDictionary *dictionary = self.scenes_data_array[indexPath.row];
    if (self.select_data_array.count == 2) {
        [self.select_data_array removeObjectAtIndex:1];
    }

    if (self.beginSpeedSedBtn != nil) {
        ScenesType_ViewController *scenesType = [[ScenesType_ViewController alloc] init];
        scenesType.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        
        [self.select_data_array insertObject:[NSString stringWithFormat:@"%@",[NSString stringIsEmpty:dictionary[@"tsc_id"]]] atIndex:1];
        NSLog(@"select_data_array = %@",self.select_data_array);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"select_data" object:self.select_data_array];
    
        [self presentViewController:scenesType animated:YES completion:nil];
    } else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"请选择设备!", @"HUD message title");;
        [hud mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.view);
        }];
        [hud hideAnimated:YES afterDelay:2.f];
    }
}
**/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark DZNEmptyDataSetDelegate----------------
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"无设备"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"暂无相应场景列表";
    return [[NSAttributedString alloc] initWithString:text attributes:nil];
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
