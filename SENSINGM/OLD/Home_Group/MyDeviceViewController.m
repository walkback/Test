//
//  MyDeviceViewController.m
//  SENSINGM
//
//  Created by apple on 2018/7/2.
//  Copyright © 2018年 吴志刚. All rights reserved.
//

#import "MyDeviceViewController.h"
#import "GroupTableViewCell.h"
#import "DeviceViewController.h"
#import "Group_Request.h"
#import "AddGroup_Request.h"
#import "Delete_Request.h"
#import "AddPicture_Request.h"
#import "ManagerTool.h"

@interface MyDeviceViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIButton * remarkEditButton;
    BOOL  isEdit;
}
@property (nonatomic, strong) UITableView * classTableView;
@property (nonatomic, strong) NSMutableArray * classGroupArray;
@property (nonatomic, strong) UITextField * groupTF;
@property (nonatomic, strong) UIImage * pictureImage;
@property (nonatomic, strong) NSString * groupName;

@property (nonatomic, strong) NSString * requestGroupID;
@property (nonatomic, strong) NSString * groupUploadUrl;


@end

@implementation MyDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor  colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1];
    self.title = @"我的设备";
    self.groupName = @"";
    self.requestGroupID = @"";
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
    rightBarBtn.frame=CGRectMake(0, 0, 60, 44);
    [rightBarBtn setTitle:@"编辑" forState:UIControlStateNormal];
    rightBarBtn.titleLabel.font = [UIFont  systemFontOfSize:13];
    [rightBarBtn setTitleColor:[UIColor  colorWithRed:81/255.0 green:81/255.0 blue:81/255.0 alpha:1] forState:UIControlStateNormal];
    [rightBarBtn  addTarget:self action:@selector(rightBarBtnEditClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightBarItem = [[UIBarButtonItem  alloc]initWithCustomView:rightBarBtn];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    self.classGroupArray = [NSMutableArray  array];
    _classTableView = [[UITableView  alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGT) style:UITableViewStylePlain];
    _classTableView.delegate = self;
    _classTableView.dataSource = self;
    [_classTableView registerClass:[GroupTableViewCell class] forCellReuseIdentifier:@"GroupCellID"];
    [self.view  addSubview:_classTableView];
    
    [self  toGetGroupRequest];
}

#pragma mark----获取组的接口请求---
-(void)toGetGroupRequest
{
    NSString * tmiID = [USER_DEF  objectForKey:@"tmiId"];
    NSLog(@"---输出一下会员id = %@",tmiID);
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = NSLocalizedString(@"Preparing...", @"HUD preparing title");
    hud.minSize = CGSizeMake(150.f, 100.f);
    Group_Request * groupRequest = [[Group_Request alloc]init];
    groupRequest.requestArgument = @{@"tmiId":tmiID};
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
        } else {
            [hud hideAnimated:YES];
            NSArray * tbMemberGroupList = request.responseJSONObject[@"tbMemberGroupList"];
            [self.classGroupArray removeAllObjects];
            for (NSDictionary * memberList in tbMemberGroupList) {
                [self.classGroupArray addObject:memberList];
            }
        }
        [self.classTableView  reloadData];

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
#pragma mark ----导航条右边的按钮-----
-(void)rightBarBtnEditClick:(UIButton *)sender
{
    isEdit = !isEdit;
    if (isEdit == NO && [sender.titleLabel.text isEqualToString:@"完成"]) {
        //此时要调完成的接口
        if ([self.requestGroupID isEqualToString:@""]) {
            [sender setTitle:@"编辑" forState:UIControlStateNormal];
            [self.classTableView  reloadData];

            return;
        }
         //确定删除
        UIAlertController *  deleteAlert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您确定要删除？组里有设备的话是不能删除的" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * deleteSureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.label.text = NSLocalizedString(@"Preparing...", @"HUD preparing title");
            hud.minSize = CGSizeMake(150.f, 100.f);

            Delete_Request * delete_request = [[Delete_Request  alloc]init];
            delete_request.requestArgument = @{@"tmgrdGroupId":self.requestGroupID};
            [delete_request  startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
                NSLog(@"delete_request = %@",request.responseJSONObject);
                int  code = [request.responseJSONObject[@"code"] intValue];
                NSString * message = request.responseJSONObject[@"message"];
                if (code != 100) {
                    [hud  hideAnimated:YES];
                    MBProgressHUD * hud = [MBProgressHUD  showHUDAddedTo:self.view animated:YES];
                    hud.mode = MBProgressHUDModeText;
                    hud.label.text = message;
                    [hud mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.center.mas_equalTo(self.view);
                    }];
                    [hud hideAnimated:YES afterDelay:2.f];

                }else
                {
                    [ManagerTool  alert:message];
                    [sender setTitle:@"编辑" forState:UIControlStateNormal];
                    [self  toGetGroupRequest];
                }
            } failure:^(__kindof LCBaseRequest *request, NSError *error) {
                [hud hideAnimated:YES];
                [hud hideAnimated:YES];
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = NSLocalizedString(@"请求失败!", @"HUD message title");;
                [hud mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.mas_equalTo(self.view);
                }];
                [hud hideAnimated:YES afterDelay:2.f];
            }];

        }];
       UIAlertAction * cancleAction = [UIAlertAction  actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
           [self  dismissViewControllerAnimated:YES completion:nil];
        }];
        [deleteAlert  addAction:deleteSureAction];
        [deleteAlert addAction:cancleAction];
        [self  presentViewController:deleteAlert animated:YES completion:nil];

    }
    if ([sender.titleLabel.text isEqualToString:@"编辑"] && isEdit == YES) {
        [sender setTitle:@"完成" forState:UIControlStateNormal];
    }
    [_classTableView reloadData];
    
}

#pragma mark ---导航条返回的问题-----
-(void)backButtonClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 210;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ((self.classGroupArray.count + 1)%2 == 1) {
        return (self.classGroupArray.count + 1)/2 + 1;
    }
    return (self.classGroupArray.count + 1)/2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupTableViewCell * cell = [tableView  dequeueReusableCellWithIdentifier:@"GroupCellID" forIndexPath:indexPath];
    
    if (indexPath.row  < self.classGroupArray.count/2) {
        NSDictionary * memberLeftList = self.classGroupArray[indexPath.row * 2];
        NSDictionary * memberRightList = self.classGroupArray[indexPath.row * 2 + 1];
        cell.leftTitleLabel.text = memberLeftList[@"tmg_name"] ;
        cell.rightTitleLabel.text = memberRightList[@"tmg_name"];
//        cell.rightImageView.image = [UIImage  imageNamed:@"group_class.png"];
        //        cell.leftImageView.image = [UIImage  imageNamed:@"group_class.png"];

        [cell.rightImageView sd_setImageWithURL:[NSURL  URLWithString:memberRightList[@"tmg_photo"]] placeholderImage: [UIImage  imageNamed:@"group_class.png"]];
        [cell.leftImageView sd_setImageWithURL:[NSURL  URLWithString:memberLeftList[@"tmg_photo"]] placeholderImage:[UIImage  imageNamed:@"group_class.png"]];
        [cell  reloadLeftEdit:isEdit rightEdit:isEdit];
       
    }
    if ((self.classGroupArray.count + 1)%2 == 1)
    {
        if (indexPath.row == self.classGroupArray.count/2) {
            cell.editLeftImageView.hidden = YES;
            cell.leftImageView.image = [UIImage  imageNamed:@"add_image.png"];
            cell.rightImageView.image = [UIImage imageNamed:@""];
           [cell  reloadLeftEdit:NO rightEdit:NO];
        }
        
    }else
    {
        if (indexPath.row == self.classGroupArray.count/2) {
              NSDictionary * memberLeftList = self.classGroupArray[indexPath.row * 2];
            cell.leftTitleLabel.text =  memberLeftList[@"tmg_name"];
//            cell.leftImageView.image = [UIImage  imageNamed:@"group_class.png"];
            
            [cell.leftImageView sd_setImageWithURL:[NSURL  URLWithString:memberLeftList[@"tmg_photo"]] placeholderImage:[UIImage  imageNamed:@"group_class.png"]];
            cell.rightImageView.image = [UIImage imageNamed:@"add_image.png"];
             [cell  reloadLeftEdit:isEdit rightEdit:NO];

        }
        
    }
    cell.leftCellButton.tag = indexPath.row ;
    [cell.leftCellButton addTarget:self action:@selector(leftCellButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.rightCellButton.tag = indexPath.row;
    [cell.rightCellButton addTarget:self action:@selector(rightCellButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}
#pragma mark --cellz左右按钮的点击响应的方式 -----
-(void)leftCellButtonClick:(UIButton *)sender
{
//tmg_member_id
    if (isEdit == YES) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
        GroupTableViewCell * groupCell = [self.classTableView  cellForRowAtIndexPath:indexPath];
        NSDictionary * leftGroupDic = self.classGroupArray[sender.tag * 2];
        NSString * goupId = [NSString  stringWithFormat:@"%@",leftGroupDic[@"tmg_id"]];
        sender.selected = ! sender.selected;
        if (sender.selected == YES) {
            groupCell.editLeftImageView.image = [UIImage  imageNamed:@"圆圈中"];
            self.requestGroupID = [ManagerTool  toGetAllSelectedIdWithAllContent: self.requestGroupID addID:goupId];
        }else
        {
            groupCell.editLeftImageView.image = [UIImage  imageNamed:@"圆圈"];
            self.requestGroupID = [ManagerTool  toGetAllWithAllContent:self.requestGroupID deleteID:goupId];
        }
           NSLog(@"--111111left--输出此时 = %@",self.requestGroupID);
        return;
    }
    if ((self.classGroupArray.count + 1)%2 == 0)
    {
        NSDictionary * leftGroupDic = self.classGroupArray[sender.tag * 2];
        NSString * title = leftGroupDic[@"tmg_name"];
        DeviceViewController * leftVC = [[DeviceViewController  alloc]init];
        leftVC.title = title;
        leftVC.groupId = leftGroupDic[@"tmg_id"];
        [self.navigationController pushViewController:leftVC animated:YES];
    }else
    {
        NSLog(@"添加一个新的Group");
        [self  addGroupNameWindow];
        
    }
}
-(void)rightCellButtonClick:(UIButton *)sender
{
    if (isEdit == YES) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
        GroupTableViewCell * groupCell = [self.classTableView  cellForRowAtIndexPath:indexPath];
        NSDictionary *rightGroupDic = self.classGroupArray[sender.tag * 2 + 1];
        NSString * goupId =[NSString  stringWithFormat:@"%@",rightGroupDic[@"tmg_id"]];
        sender.selected = ! sender.selected;
        if (sender.selected == YES) {
            groupCell.editRightImageView.image = [UIImage  imageNamed:@"圆圈中"];
            self.requestGroupID = [ManagerTool  toGetAllSelectedIdWithAllContent:self.requestGroupID addID:goupId];
        }else
        {
            groupCell.editRightImageView.image = [UIImage  imageNamed:@"圆圈"];
            self.requestGroupID = [ManagerTool  toGetAllWithAllContent: self.requestGroupID deleteID:goupId];
        }
        NSLog(@"--222222222  rifht--输出此时 = %@",self.requestGroupID);
        return;
    }
    if (sender.tag == self.classGroupArray.count/2) {
        NSLog(@"添加一个新的groupYou");
        [self  addGroupNameWindow];
       
    }else
    {
        NSDictionary *rightGroupDic = self.classGroupArray[sender.tag * 2 + 1];
        NSString * title = rightGroupDic[@"tmg_name"];
        DeviceViewController * rightVC = [[DeviceViewController  alloc]init];
        rightVC.title = title;
        rightVC.groupId = rightGroupDic[@"tmg_id"];
        [self.navigationController pushViewController:rightVC animated:YES];
    }
}

-(void)addGroupNameWindow
{
    UIWindow * boardWindow = [UIApplication  sharedApplication].keyWindow;
    UIView * backView = [[UIView  alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGT)];
    backView.alpha = 0.3;
    backView.tag = 30;
    backView.backgroundColor = [UIColor  blackColor];
    [boardWindow addSubview:backView];
    
    UIView * whiteBoardView = [[UIView alloc]initWithFrame:CGRectMake(20, 100, SCREEN_WIDTH - 40, SCREEN_HEIGT - 200)];
    whiteBoardView.backgroundColor = [UIColor whiteColor];
    whiteBoardView.layer.masksToBounds = YES;
    whiteBoardView.layer.cornerRadius = 20;
    whiteBoardView.tag = 16;
    [boardWindow  addSubview:whiteBoardView];
    UITapGestureRecognizer * tapGesture  = [[UITapGestureRecognizer  alloc]initWithTarget:self action:@selector(tapGestureClick)];
    whiteBoardView.userInteractionEnabled = YES;
    [whiteBoardView  addGestureRecognizer:tapGesture];
    //取消按钮
    UIButton * cancleAddBtn = [UIButton  buttonWithType:UIButtonTypeCustom];
    [cancleAddBtn setImage:[UIImage  imageNamed:@"close_add.png"] forState:UIControlStateNormal];
    cancleAddBtn.frame = CGRectMake(whiteBoardView.frame.size.width - 50, 10, 44, 44);
    [cancleAddBtn  addTarget:self action:@selector(cancleAddBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [whiteBoardView  addSubview:cancleAddBtn];
    //设备分组名称
    UILabel * groupName = [[UILabel  alloc]initWithFrame:CGRectMake(10, 60 , 120, 44)];
    groupName.text = @"设备分组名称:";
    groupName.textColor = [UIColor  blackColor];
    groupName.font = [UIFont  systemFontOfSize:16];
    groupName.textAlignment = NSTextAlignmentLeft;
    [groupName sizeToFit];
    [whiteBoardView  addSubview:groupName];
    
    UITextField * groupTF = [[UITextField  alloc]initWithFrame:CGRectMake(130, groupName.frame.origin.y, whiteBoardView.frame.size.width - 170, 44)];
    groupTF.borderStyle = UITextBorderStyleRoundedRect;
    [whiteBoardView  addSubview:groupTF];
    self.groupTF = groupTF;
    
//    //添加分组的图片
//    UILabel * groupPicture = [[UILabel  alloc]initWithFrame:CGRectMake(groupName.frame.origin.x, CGRectGetMaxY(groupName.frame) + 10, 120, 44)];
//    groupPicture.text = @"添加分组的图片:";
//    groupPicture.textColor = [UIColor  blackColor];
//    groupPicture.font = [UIFont  systemFontOfSize:16];
//    groupPicture.textAlignment = NSTextAlignmentLeft;
//    [whiteBoardView  addSubview:groupPicture];
//
//    UIButton * addImageBtn = [UIButton  buttonWithType:UIButtonTypeCustom];
//    addImageBtn.layer.masksToBounds = YES;
//    addImageBtn.layer.cornerRadius = 8;
//    addImageBtn.layer.borderWidth = 1;
//    addImageBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    [addImageBtn setImage:[UIImage  imageNamed:@"add_image.png"] forState:UIControlStateNormal];
//    addImageBtn.frame = CGRectMake((whiteBoardView.frame.size.width - 150)/2, CGRectGetMaxY(groupPicture.frame) + 10, 150, 150);
//    [addImageBtn  addTarget:self action:@selector(addImageClick:) forControlEvents:UIControlEventTouchUpInside];
//    [whiteBoardView  addSubview:addImageBtn];
    
    UIButton * addGroupButton = [UIButton buttonWithType:UIButtonTypeCustom];
     addGroupButton.frame = CGRectMake(10,140, whiteBoardView.frame.size.width - 20,40);
//    if (( whiteBoardView.frame.size.height - CGRectGetMaxY(addImageBtn.frame))/2 > 60 ) {
//         addGroupButton.frame = CGRectMake(10,CGRectGetMaxY(addImageBtn.frame) +( whiteBoardView.frame.size.height - CGRectGetMaxY(addImageBtn.frame))/2, whiteBoardView.frame.size.width - 20, 40);
//    }else
//    {
//         addGroupButton.frame = CGRectMake(10,CGRectGetMaxY(addImageBtn.frame) +10, whiteBoardView.frame.size.width - 20, 40);
//    }
//
    addGroupButton.backgroundColor = BLUE_COLOR;
    [addGroupButton  setTitle:@"添加" forState:UIControlStateNormal];
    [addGroupButton setTitleColor:[UIColor  whiteColor] forState:UIControlStateNormal];
    addGroupButton.layer.masksToBounds = YES;
    addGroupButton.layer.cornerRadius = 15;
    [addGroupButton  addTarget:self action:@selector(addGroupButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [whiteBoardView  addSubview:addGroupButton];
    
}
-(void)removeWindow
{
     UIWindow * boardWindow = [UIApplication  sharedApplication].keyWindow;
    UIView * backView  = [boardWindow  viewWithTag:30];
    [backView  removeFromSuperview];
    UIView * whiteBoardView  = [boardWindow  viewWithTag:16];
    [whiteBoardView removeFromSuperview];
}

-(void)addGroupPictureWindow
{
    if (self.groupTF.text.length == 0) {
        [ManagerTool alert:@"请填写组名称"];
        return;
    }

   UIWindow * boardWindow = [UIApplication  sharedApplication].keyWindow;
    UIView * backView = [[UIView  alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGT)];
    backView.alpha = 0.3;
    backView.tag = 30;
    backView.backgroundColor = [UIColor  blackColor];
    [boardWindow addSubview:backView];
    
    UIView * whiteBoardView = [[UIView alloc]initWithFrame:CGRectMake(20, 100, SCREEN_WIDTH - 40, SCREEN_HEIGT - 200)];
    whiteBoardView.backgroundColor = [UIColor whiteColor];
    whiteBoardView.layer.masksToBounds = YES;
    whiteBoardView.layer.cornerRadius = 20;
    whiteBoardView.tag = 16;
    [boardWindow  addSubview:whiteBoardView];
    UITapGestureRecognizer * tapGesture  = [[UITapGestureRecognizer  alloc]initWithTarget:self action:@selector(tapGestureClick)];
    whiteBoardView.userInteractionEnabled = YES;
    [whiteBoardView  addGestureRecognizer:tapGesture];
    //取消按钮
    UIButton * cancleAddBtn = [UIButton  buttonWithType:UIButtonTypeCustom];
    [cancleAddBtn setImage:[UIImage  imageNamed:@"close_add.png"] forState:UIControlStateNormal];
    cancleAddBtn.frame = CGRectMake(whiteBoardView.frame.size.width - 50, 10, 44, 44);
    [cancleAddBtn  addTarget:self action:@selector(cancleAddBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [whiteBoardView  addSubview:cancleAddBtn];
    //设备分组名称
    UILabel * groupName = [[UILabel  alloc]initWithFrame:CGRectMake(10, 60 , 120, 44)];
    groupName.text = @"设备分组名称:";
    groupName.textColor = [UIColor  blackColor];
    groupName.font = [UIFont  systemFontOfSize:16];
    groupName.textAlignment = NSTextAlignmentLeft;
    [groupName sizeToFit];
    [whiteBoardView  addSubview:groupName];
    
    UITextField * groupTF = [[UITextField  alloc]initWithFrame:CGRectMake(130, groupName.frame.origin.y, whiteBoardView.frame.size.width - 170, 44)];
    groupTF.borderStyle = UITextBorderStyleRoundedRect;
    [whiteBoardView  addSubview:groupTF];
    self.groupTF = groupTF;
    if (![self.groupName isEqualToString:@""])
    {
        groupTF.text = self.groupName;
    }

    
        //添加分组的图片
        UILabel * groupPicture = [[UILabel  alloc]initWithFrame:CGRectMake(groupName.frame.origin.x, CGRectGetMaxY(groupName.frame) + 10, 120, 44)];
        groupPicture.text = @"添加分组的图片:";
        groupPicture.textColor = [UIColor  blackColor];
        groupPicture.font = [UIFont  systemFontOfSize:16];
        groupPicture.textAlignment = NSTextAlignmentLeft;
        [whiteBoardView  addSubview:groupPicture];
    
        UIButton * addImageBtn = [UIButton  buttonWithType:UIButtonTypeCustom];
        addImageBtn.layer.masksToBounds = YES;
        addImageBtn.layer.cornerRadius = 8;
        addImageBtn.layer.borderWidth = 1;
        addImageBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        [addImageBtn setImage:[UIImage  imageNamed:@"add_image.png"] forState:UIControlStateNormal];
    [addImageBtn  setImage:_pictureImage forState:UIControlStateNormal];
        addImageBtn.frame = CGRectMake((whiteBoardView.frame.size.width - 150)/2, CGRectGetMaxY(groupPicture.frame) + 10, 150, 150);
        [addImageBtn  addTarget:self action:@selector(addImageClick:) forControlEvents:UIControlEventTouchUpInside];
        [whiteBoardView  addSubview:addImageBtn];
    
    UIButton * addGroupButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addGroupButton.frame = CGRectMake(10,140, whiteBoardView.frame.size.width - 20,40);
        if (( whiteBoardView.frame.size.height - CGRectGetMaxY(addImageBtn.frame))/2 > 60 ) {
             addGroupButton.frame = CGRectMake(10,CGRectGetMaxY(addImageBtn.frame) +( whiteBoardView.frame.size.height - CGRectGetMaxY(addImageBtn.frame))/2, whiteBoardView.frame.size.width - 20, 40);
        }else
        {
             addGroupButton.frame = CGRectMake(10,CGRectGetMaxY(addImageBtn.frame) +10, whiteBoardView.frame.size.width - 20, 40);
        }
    
    addGroupButton.backgroundColor = BLUE_COLOR;
    [addGroupButton  setTitle:@"添加" forState:UIControlStateNormal];
    [addGroupButton setTitleColor:[UIColor  whiteColor] forState:UIControlStateNormal];
    addGroupButton.layer.masksToBounds = YES;
    addGroupButton.layer.cornerRadius = 15;
    [addGroupButton  addTarget:self action:@selector(addGroupButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [whiteBoardView  addSubview:addGroupButton];
    
}
#pragma mark ----添加分组的请求----
-(void)addGroupButtonClick:(UIButton *)sender
{
    
    NSLog(@"分组的名称 = %@",self.groupName);
    if ([self.groupName isEqualToString:@""]) {
        if ([self.groupTF.text  isEqualToString:@""]) {
            [ManagerTool  alert:@"请填写分组的名称"];
            return;
        }
        self.groupName = self.groupTF.text;
        [self  removeWindow];
        [self  choosePopImageAlertView];
    }else
    {
//        //添加会员设备分组
//        AddGroup_Request * group_request = [[AddGroup_Request  alloc]init];
//        NSString * tmiId = [USER_DEF objectForKey:@"tmiId"];
//        group_request.requestArgument = @{@"tmiId":tmiId,@"tmgName": self.groupName,@"tmgPhoto":@"pic/name"};

        if (self.groupTF.text.length == 0) {
            [ManagerTool alert:@"请填写组名称"];
            return;
        }
        [self  removeWindow];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = NSLocalizedString(@"Preparing...", @"HUD preparing title");
        hud.minSize = CGSizeMake(150.f, 100.f);
        NSString * tmiId = [USER_DEF objectForKey:@"tmiId"];
        AddGroup_Request * group_request = [[AddGroup_Request alloc]init];
        group_request.requestArgument = @{@"tmiId":tmiId,@"tmgName":self.groupTF.text,@"tmgPhoto":self.groupUploadUrl};
        [group_request  startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
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
                [ManagerTool alert:message];
                [self  toGetGroupRequest];
            }
            
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
#pragma mark ----取消添加group----
-(void)cancleAddBtnClick:(UIButton *)sender
{
    [self  removeWindow];
}

#pragma mark ---让键盘下去----
-(void)tapGestureClick
{
    [self.groupTF resignFirstResponder];
}
#pragma mark -----添加图片的按钮-----
-(void)addImageClick:(UIButton *)sender
{
    [self choosePopImageAlertView];
}
#pragma mark ----弹出选择图片的弹框------
-(void)choosePopImageAlertView
{
    //@"选择图片方式"
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction * photographAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *  action) {
        //禁用退出登录按钮交互性
        UIImagePickerController *imagePickerView=[[UIImagePickerController alloc]init];
        imagePickerView.delegate=self;
        imagePickerView.allowsEditing=YES;
        imagePickerView.sourceType=UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePickerView animated:YES completion:nil];
        
    }];
    UIAlertAction * albumAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *  action) {
        //图片获取器
        UIImagePickerController *imagePickerView = [[UIImagePickerController alloc] init];
        //设置代理
        imagePickerView.delegate=self;
        if ([imagePickerView.navigationBar respondsToSelector:@selector(setBarTintColor:)]) {
            [imagePickerView.navigationBar setBarTintColor:BLUE_COLOR];
            [imagePickerView.navigationBar setTranslucent:YES];
            [imagePickerView.navigationBar setTintColor:[UIColor whiteColor]];
        }else{
            [imagePickerView.navigationBar setBackgroundColor:BLUE_COLOR];
        }
        imagePickerView.allowsEditing = YES;
        
        imagePickerView.sourceType =UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickerView animated:YES completion:nil];
    }];
    UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *  action) {
        [self  dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertController  addAction:photographAction];
    [alertController  addAction:albumAction];
    [alertController  addAction:cancleAction];
    [self  presentViewController:alertController animated:YES completion:nil];
    
}

#pragma mark -----获取相片------
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info
{
    [self dismissViewControllerAnimated:YES  completion:nil];
    NSLog(@"搞什么 ==%@",info);
    UIImage * image = info[@"UIImagePickerControllerOriginalImage"];
    //在这里进行上传图片的请求
    [ManagerTool  uploadImage:image completeBlock:^(NSDictionary *dic) {
        NSLog(@"----输出一次啊上传 = %@",dic);
        int code = [dic[@"code"] intValue];
        NSString * messge = [NSString  stringWithFormat:@"%@",dic[@"message"]];
        if (code != 100) {
            [ManagerTool alert:messge];
            return ;
        }else
        {
            NSString * url = [NSString stringWithFormat:@"%@%@",RootUrl,dic[@"url"]];
            self.groupUploadUrl = url;
            self.pictureImage =image;
            [self  addGroupPictureWindow];
        }

    }];

    

    
    
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
