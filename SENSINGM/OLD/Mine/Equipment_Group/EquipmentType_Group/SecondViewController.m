
//
//  SecondViewController.m
//  CollectionView-nib
//
//  Created by chenyufeng on 15/10/30.
//  Copyright © 2015年 chenyufengweb. All rights reserved.
//

#import "SecondViewController.h"
#import "CollectionViewCell.h"
#import "AppDelegate.h"
#import "EquipmentType_Request.h"
#import "AddScene_ViewController.h"
#import "DeleteScene_Request.h"
#import "Equipment_ViewController.h"

#import "SectionModel.h"
#import "CellModel.h"

#define UISCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)

NS_ENUM(NSInteger,CellState){
  
  //右上角编辑按钮的两种状态；
  //正常的状态，按钮显示“编辑”;
  NormalState,
  //正在删除时候的状态，按钮显示“完成”；
  DeleteState
  
};


@interface SecondViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource>

//@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSDictionary *dictionary;

@property(nonatomic,assign) enum CellState;
//@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (nonatomic,strong) SectionModel *section;
//里面存放section对象，也就是section模型，模型由SectionModel定义；
@property (nonatomic,strong) NSMutableArray *dataSectionArray;
//里面存放cell对象，也就是cell模型，模型由CellModel定义；
@property (nonatomic,strong) NSMutableArray *dataCellArray;
@property(nonatomic,strong) NSMutableArray *cellImageArr;
@property(nonatomic,strong) NSMutableArray *cellDescArr;
//@property(nonatomic,strong) CollectionReusableView *reusableView;
@property (nonatomic, strong) NSArray *data_array;
@property (nonatomic, strong) UIView *allselect_view;
@property (nonatomic, strong) UIButton *delete_but;
@property (nonatomic, strong) NSMutableArray *allselect_array;
@property (nonatomic) BOOL if_edit;
@property (nonatomic) BOOL if_allselect;
@property (nonatomic) BOOL if_select;
@property (nonatomic, strong) NSMutableArray *senderTag_array;
@property (nonatomic, strong) UIButton * allSelectedButton;//全选按钮
@end

@implementation SecondViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh:) name:@"Refresh" object:nil];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设备分类";
    self.view.backgroundColor = [UIColor whiteColor];
    self.senderTag_array = [NSMutableArray array];
    self.data_array = [NSArray array];
    self.cellDescArr = [NSMutableArray array];
    self.if_edit = NO;
    self.if_allselect = NO;
    self.if_select = NO;
    self.allselect_array = [NSMutableArray array];
    //一开始是正常状态；
    CellState = NormalState;

    [self get_collectioncell_data];
    [self deleteView];
}

#pragma mark 刷新
- (void)refresh:(NSNotification *)notif {
    [self get_collectioncell_data];
}

#pragma mark 获取设备分类数据
- (void)get_collectioncell_data {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = NSLocalizedString(@"正在加载...", @"HUD preparing title");
    hud.minSize = CGSizeMake(150.f, 100.f);
    
    EquipmentType_Request *equipmentType_Request = [[EquipmentType_Request alloc] init];
    equipmentType_Request.requestArgument = @{@"tmiId":TMI_Id};
    [equipmentType_Request startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        NSLog(@"request = %@",request.responseJSONObject);
        int code = [request.responseJSONObject[@"code"] intValue];
        NSString *message = request.responseJSONObject[@"message"];
        if (code != 100) {
            [hud hideAnimated:YES];
            [self.collectionView.mj_header endRefreshing];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = message;
            [hud mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(self.view);
            }];
            [hud hideAnimated:YES afterDelay:2.f];
        } else {
            [hud hideAnimated:YES];
            [self.collectionView.mj_header endRefreshing];
            self.data_array = [NSArray array];
            self.data_array = request.responseJSONObject[@"tbMemberGroupList"];
            //防止下拉刷新，选择的消失
            if (self.senderTag_array.count == 0) {
                [self.senderTag_array   removeAllObjects];
                for (int k = 0; k <  self.data_array.count ; k ++) {
                    [self.senderTag_array  addObject:@"NO"];
                }
            }
         
            for (int i = 0; i < self.data_array.count; i++) {
                self.dictionary = [self.data_array objectAtIndex:i];
                [self.cellDescArr addObject:[NSString stringIsEmpty:self.dictionary[@"tmg_name"]]];
            }
            
            if (self.data_array.count == 0) {
                [self initTableView];
                
                UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
                [rightButton addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
                [rightButton setImage:[UIImage imageNamed:@"添加"] forState:UIControlStateNormal];
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
                
                [self.tableView reloadData];
            } else {
                [self initCollection];
                
                UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
                [rightButton addTarget:self action:@selector(editButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                [rightButton setTitleColor:Default_Blue_Color forState:UIControlStateNormal];
                [rightButton setTitle:@"编辑" forState:UIControlStateNormal];
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
                
                [self.collectionView reloadData];
            }
        }
        [self.collectionView reloadData];
        [self.tableView reloadData];
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [hud hideAnimated:YES];
        [self.collectionView.mj_header endRefreshing];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"请求失败!", @"HUD message title");;
        [hud mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.view);
        }];
        [hud hideAnimated:YES afterDelay:2.f];
    }];
}

#pragma mark 初始化 collectionView
- (void)initCollection {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 10;     // 设置最小行间距
    flowLayout.minimumInteritemSpacing = 0; // 最小列间距
    flowLayout.itemSize = CGSizeMake(WIDTH / 2 - 15, WIDTH / 2 - 80);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    [self.collectionView registerClass:[CollectionViewCell class]  forCellWithReuseIdentifier:@"CollectionCell"];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-50);
    }];
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(get_collectioncell_data)];
}

#pragma mark 初始化 tableView
- (void)initTableView {
    self.tableView = [[UITableView alloc] init];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64);
        make.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.data_array.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];

    if (indexPath.row < self.data_array.count){
        NSDictionary * dict = [self.data_array objectAtIndex:indexPath.row];
        cell.descLabel.text = [NSString stringIsEmpty:dict[@"tmg_name"]];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringIsEmpty:dict[@"tmg_photo"]]] placeholderImage:[UIImage imageNamed:@"2"]];
        
        if (self.if_edit == YES) {
            cell.deleteButton.hidden = NO;
            cell.deleteButton.tag = indexPath.item;
            [cell.deleteButton setImage:[UIImage imageNamed:@"圆圈"] forState:UIControlStateNormal];

             [cell.deleteButton addTarget:self action:@selector(select_delete:) forControlEvents:UIControlEventTouchUpInside];
            if (self.if_allselect == YES) {
                [cell.deleteButton setImage:[UIImage imageNamed:@"圆圈中"] forState:UIControlStateNormal];

            }else
            {
                if (self.senderTag_array.count > 0) {
                    NSString * statusStr = self.senderTag_array[indexPath.item];
                    if ([statusStr isEqualToString:@"YES"]) {
                        [cell.deleteButton setImage:[UIImage imageNamed:@"圆圈中"] forState:UIControlStateNormal];
                    }
                    if ([statusStr isEqualToString:@"NO"]) {
                        [cell.deleteButton setImage:[UIImage imageNamed:@"圆圈"] forState:UIControlStateNormal];
                    }
                }
            }
       }else
        {
            cell.deleteButton.hidden = YES;
        }
    } else {
        cell.backgroundColor = Line_Color;
        cell.descLabel.text = @"";
        cell.imageView.image = [UIImage imageNamed:@"添加 (2)"];
        cell.deleteButton.hidden = YES;
    }
    return cell;
}


#pragma mark - UICollectionViewDelegateFlowLayout

#pragma mark -- Lazy Load 懒加载
//要添加的图片从这里面选；
//这里进行的是懒加载，要先去判断，没有的话才去进行实例化;

- (NSMutableArray *)dataSectionArray{
    if (!_dataSectionArray){
        //CollectionView有一个Section数组；
        _dataSectionArray = [[NSMutableArray alloc] initWithCapacity:1];//1个；
        for (int i = 0; i < 1; i++) {
            //默认初始有两个Section；
            _dataCellArray = [[NSMutableArray alloc] initWithCapacity:self.data_array.count + 1];//2个；
            for (int j = 0; j < self.data_array.count + 1; j++) {
                //默认一个section中有6个cell；
                //初始化每一个cell；
                CellModel *cellModel = [[CellModel alloc] init];
                cellModel.cellImage = self.cellImageArr[j];
                //添加到cell数组中；
                [_dataCellArray addObject:cellModel];
    
            }//for;
            //初始化section；
            SectionModel *sectionModel = [[SectionModel alloc] init];
            //把上面生成的cell数组加入到section数组中；
            sectionModel.cellArray = _dataCellArray;
            //增加一个section；
            [_dataSectionArray addObject:sectionModel];
        }//for;
    }
    return _dataSectionArray;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.if_edit == YES) {
        return;
    }else
    {
        if ((indexPath.row == self.data_array.count)) {
            NSLog(@"点击最后一个cell，执行添加操作");
            UIBarButtonItem * backButtonItem = [[UIBarButtonItem alloc] init];
            backButtonItem.title = @"";
            self.navigationItem.backBarButtonItem = backButtonItem;
            AddScene_ViewController *addScene = [[AddScene_ViewController alloc] init];
            addScene.view.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
            [self presentViewController:addScene animated:YES completion:nil];
        } else {
            UIBarButtonItem * backButtonItem = [[UIBarButtonItem alloc] init];
            backButtonItem.title = @"";
            self.navigationItem.backBarButtonItem = backButtonItem;
            NSDictionary *dictionary = [self.data_array objectAtIndex:indexPath.row];
            NSLog(@"第%ld个section,点击图片%ld",indexPath.section,indexPath.row);
            
            Equipment_ViewController *equipment = [[Equipment_ViewController alloc] init];
            equipment.tmgId = [NSString stringIsEmpty:[NSString stringWithFormat:@"%@",dictionary[@"tmg_id"]]];
            [self.navigationController pushViewController:equipment animated:YES];
        }
    }
  
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data_array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    return cell;
}

#pragma mark 编辑
- (void)editButtonPressed:(UIButton *)sender {
//    //从正常状态变为可删除状态；
//    if (CellState == NormalState) {
//        CellState = DeleteState;
//        [sender setTitle:@"完成" forState:UIControlStateNormal];
//        //循环遍历整个CollectionView；
//        for(CollectionViewCell *cell in self.collectionView.visibleCells){
//            cell.deleteButton.hidden = NO;
//            [cell.deleteButton addTarget:self action:@selector(deleteCellButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//        }
//    } else if (CellState == DeleteState){
//        CellState = NormalState;
//        [sender setTitle:@"编辑" forState:UIControlStateNormal];
//
//        for(CollectionViewCell *cell in self.collectionView.visibleCells){
//            cell.deleteButton.hidden = YES;
//        }
//    }
    sender.selected = !sender.selected;
    if (sender.selected) {
        if (self.if_edit == NO) {
            self.if_edit = YES;
            [sender setTitle:@"完成" forState:UIControlStateNormal];
            self.allselect_view.hidden = NO;
            self.delete_but.hidden = NO;
        }
    } else {
        if (self.if_edit == YES) {
            self.if_edit = NO;
            [sender setTitle:@"编辑" forState:UIControlStateNormal];
            self.allselect_view.hidden = YES;
            self.delete_but.hidden = YES;
        }
    }
    
    [self.collectionView reloadData];
}

#pragma mark 删除视图
- (void)deleteView {
    self.allselect_view = [UIView new];
    self.allselect_view.hidden = YES;
    self.allselect_view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.allselect_view];
    [self.allselect_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(WIDTH / 3 * 2, 44));
    }];
    
    UIButton *imageview_but = [UIButton new];
    [imageview_but addTarget:self action:@selector(allselect:) forControlEvents:UIControlEventTouchUpInside];
    [imageview_but setBackgroundImage:[UIImage imageNamed:@"圆圈"] forState:UIControlStateNormal];
    //圆圈中
    [self.allselect_view addSubview:imageview_but];
    [imageview_but mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.allselect_view);
        make.left.equalTo(self.allselect_view).offset(40);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    self.allSelectedButton = imageview_but;

    
    UILabel *all_label = [UILabel new];
    all_label.font = [UIFont systemFontOfSize:16];
    all_label.text = @"全选";
    all_label.textColor = Default_Blue_Color;
    [self.allselect_view addSubview:all_label];
    [all_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(imageview_but);
        make.left.equalTo(imageview_but.mas_right).offset(5);
    }];
    
    self.delete_but = [UIButton new];
    self.delete_but.hidden = YES;
    [self.delete_but.layer setCornerRadius:5];
    [self.delete_but addTarget:self action:@selector(alldelete:) forControlEvents:UIControlEventTouchUpInside];
    self.delete_but.layer.masksToBounds = YES;
    [self.delete_but setTitle:@"删除" forState:UIControlStateNormal];
    [self.delete_but setBackgroundColor:Default_Blue_Color];
    [self.view addSubview:self.delete_but];
    [self.delete_but mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.view);
        make.left.equalTo(self.allselect_view.mas_right).offset(-5);
        make.height.mas_equalTo(44);
    }];
}

#pragma mark 全选
- (void)allselect:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.if_allselect = sender.selected;
    if (sender.selected == YES) {
        [sender setImage:[UIImage imageNamed:@"圆圈中"] forState:UIControlStateNormal];
        [self.allselect_array  removeAllObjects];
        for (NSDictionary * dataDic in self.data_array) {
            [self.allselect_array addObject:dataDic];
        }
        [self.senderTag_array  replaceObjectAtIndex:sender.tag withObject:@"NO"];

    }else
    {
        [sender setImage:[UIImage imageNamed:@"圆圈"] forState:UIControlStateNormal];
        [self.allselect_array  removeAllObjects];
        for (int k = 0; k <  self.data_array.count ; k ++) {
            //全部取消
            [self.senderTag_array  replaceObjectAtIndex:k withObject:@"NO"];
        }
    }
     [self.collectionView reloadData];

}

#pragma mark 多选删除
- (void)select_delete:(UIButton *)sender {
    sender.selected = !sender.selected;
    NSString * status = self.senderTag_array[sender.tag];
    if ([status isEqualToString:@"YES"]) {
        [self.allselect_array removeObject:self.data_array[sender.tag]];
        [self.senderTag_array  replaceObjectAtIndex:sender.tag withObject:@"NO"];
    }else
    {
        [self.allselect_array addObject:self.data_array[sender.tag]];
        [self.senderTag_array  replaceObjectAtIndex:sender.tag withObject:@"YES"];
    }
    BOOL  checkAll = [self  checkAllSelect];
    if (checkAll == YES) {
        self.if_allselect = YES;
        self.allSelectedButton.selected = YES;
        [self.allSelectedButton  setImage:[UIImage imageNamed:@"圆圈中"] forState:UIControlStateNormal];
    }else
    {
        self.if_allselect = NO;
        self.allSelectedButton.selected = NO;
        [self.allSelectedButton  setImage:[UIImage imageNamed:@"圆圈"] forState:UIControlStateNormal];
    }
    [self.collectionView  reloadData];
}

-(BOOL)checkAllSelect
{
    if (self.allselect_array.count == self.data_array.count) {
        return YES;
    }else
    {
        return NO;
    }
}
#pragma mark 删除
- (void)alldelete:(UIButton *)sender{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = NSLocalizedString(@"正在加载...", @"HUD preparing title");
    hud.minSize = CGSizeMake(150.f, 100.f);
    NSMutableArray *tmg_id_array = [NSMutableArray array];
    for (int i = 0; i < self.allselect_array.count; i++) {
        NSDictionary *dic = self.allselect_array[i];
        [tmg_id_array addObject:[NSString stringIsEmpty:[NSString stringWithFormat:@"%@",dic[@"tmg_id"]]]];
    }
    NSString *tmg_id_str = [tmg_id_array componentsJoinedByString:@","];
    
    if (![[NSString stringIsEmpty:tmg_id_str] isEqualToString:@""]) {
        DeleteScene_Request *deleteScene_Request = [[DeleteScene_Request alloc] init];
        deleteScene_Request.requestArgument = @{@"tmgrdGroupId":tmg_id_str};
        NSLog(@"requestArgument = %@",deleteScene_Request.requestArgument );
        [deleteScene_Request startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
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
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = message;
                [hud mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.mas_equalTo(self.view);
                }];
                self.allselect_array = [NSMutableArray array];
                [self get_collectioncell_data];
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
    } else {
        [hud hideAnimated:YES];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"参数错误!", @"HUD message title");;
        [hud mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.view);
        }];
        [hud hideAnimated:YES afterDelay:2.f];
    }
}


@end
