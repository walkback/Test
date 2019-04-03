//
//  PersonalInf_ViewController.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/6/16.
//  Copyright © 2018 吴志刚. All rights reserved.
//


#import "PersonalInf_ViewController.h"
#import "PersonalInf_TableViewCell.h"
#import "Address_TableViewCell.h"
#import "HeadPortrait_ViewController.h"
#import "UserName_ViewController.h"
#import "NickName_ViewController.h"
#import "Province_TableViewController.h"
#import "Member_Info_Request.h"
#import "Change_UesrName_Adress_Request.h"
#import "Macro.h"
#import <Masonry.h>

@interface PersonalInf_ViewController () <UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSString *Province;
@property (nonatomic, copy) NSString *City;
@property (nonatomic, copy) NSString *Area;

@property (nonatomic, copy) NSString * provinceName;
@property (nonatomic, copy) NSString * cityName;
@property (nonatomic, copy) NSString * areaName;

@property (nonatomic, copy) NSString *address_text;
@property (nonatomic, strong) NSDictionary *dictionary;
@property (nonatomic) CGFloat cell_height;
@end

@implementation PersonalInf_ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Province:) name:@"AreaChange" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh:) name:@"refresh" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"个人信息";
    self.view.backgroundColor = Line_Color;
    self.navigationController.navigationBar.hidden = NO;
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap1.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap1];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44;
    [self.tableView.layer setCornerRadius:5];
    self.tableView.layer.masksToBounds = YES;
    self.tableView.scrollEnabled = NO;
    [self.tableView registerClass:[PersonalInf_TableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerClass:[Address_TableViewCell class] forCellReuseIdentifier:@"addresscell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    if (KIsiPhoneX) {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(44 + 44 + 10);
            make.left.equalTo(self.view).offset(10);
            make.right.equalTo(self.view).offset(-10);
            make.height.mas_equalTo(293);
        }];
    } else {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(74);
            make.left.equalTo(self.view).offset(10);
            make.right.equalTo(self.view).offset(-10);
            make.height.mas_equalTo(293);
        }];
    }
    [self get_member_info];
}

#pragma mark 刷新
- (void)refresh:(NSNotification *)notif {
    [self get_member_info];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refresh" object:nil];
}

#pragma mark 省 市 区
- (void)Province:(NSNotification *)notif {
    NSDictionary * notifiDic = notif.userInfo;
    self.Province = [NSString stringIsEmpty:notifiDic[@"pid"]];
    self.provinceName = [NSString stringIsEmpty:notifiDic[@"pName"]];
    self.City = [NSString  stringIsEmpty:notifiDic[@"cid"]];
    self.cityName =  [NSString  stringIsEmpty:notifiDic[@"cName"]];
    self.Area = [NSString  stringIsEmpty:notifiDic[@"oid"]];
    self.areaName = [NSString  stringIsEmpty:notifiDic[@"oName"]];
    [self.tableView reloadData];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AreaChange" object:nil];
}


#pragma mark 获取个人信息
- (void)get_member_info {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = NSLocalizedString(@"Preparing...", @"HUD preparing title");
    hud.minSize = CGSizeMake(150.f, 100.f);
    
    Member_Info_Request *member_Info_Request = [[Member_Info_Request alloc] init];
    member_Info_Request.requestArgument = @{@"tmiId":TMI_Id};
    [member_Info_Request startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
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
            self.dictionary = request.responseJSONObject[@"tbMemberInfo"];
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PersonalInf_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.header_label.text = @"头像";
        cell.detail_inf_lab.hidden = YES;
        [cell.headportrait_image sd_setImageWithURL:[NSURL URLWithString:PHOTO_URL([NSString stringIsEmpty:self.dictionary[@"tmi_head_img"]])] placeholderImage:[UIImage imageNamed:@"sleep_back"]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.row == 1) {
        cell.header_label.text = @"昵称";
        cell.headportrait_image.hidden = YES;
        cell.detail_inf_lab.text = [NSString stringIsEmpty:self.dictionary[@"tmi_name"]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.row == 2) {
        cell.header_label.text = @"用户名";
        cell.detail_inf_lab.text = [NSString stringIsEmpty:self.dictionary[@"tmi_contact_name"]];
        cell.headportrait_image.hidden = YES;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.row == 3) {
        cell.header_label.text = @"手机号码";
        cell.detail_inf_lab.text = [NSString stringIsEmpty:self.dictionary[@"tmi_contact_phone"]];
        cell.headportrait_image.hidden = YES;
    }
    if (indexPath.row == 4) {
        Address_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addresscell" forIndexPath:indexPath];
        cell.header_label.text = @"我的地址";
        
        if ([[NSString  stringIsEmpty:self.Province] isEqualToString:@""]) {
            cell.address_lab.text = [NSString stringWithFormat:@"%@%@%@",
                                     [NSString stringIsEmpty:self.dictionary[@"pname"]],
                                     [NSString stringIsEmpty:self.dictionary[@"cname"]],
                                     [NSString stringIsEmpty:self.dictionary[@"oname"]]];
        }else
        {
            cell.address_lab.text = [NSString stringWithFormat:@"%@%@%@",
                                     [NSString stringIsEmpty:self.provinceName],
                                     [NSString stringIsEmpty:self.cityName],
                                     [NSString stringIsEmpty:self.areaName]];
        }
     
        cell.address_detail.delegate = self;
        cell.address_detail.returnKeyType = UIReturnKeyDone;
        if ([[NSString stringIsEmpty:self.dictionary[@"tmi_address"]] isEqualToString:@""]) {
            cell.address_detail.text = @"请输入详细地址";
            cell.address_detail.textColor = [UIColor lightGrayColor];
        } else {
            cell.address_detail.text = [NSString stringIsEmpty:self.dictionary[@"tmi_address"]];
            cell.address_detail.textColor = [UIColor blackColor];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UIBarButtonItem * backButtonItem = [[UIBarButtonItem alloc] init];
        backButtonItem.title = @"";
        self.navigationItem.backBarButtonItem = backButtonItem;
        HeadPortrait_ViewController *headPortrait = [[HeadPortrait_ViewController alloc] init];
        headPortrait.url_photo_st = [NSString stringIsEmpty:self.dictionary[@"tmi_head_img"]];
        [self.navigationController pushViewController:headPortrait animated:YES];
    }
    if (indexPath.row == 1) {
        UIBarButtonItem * backButtonItem = [[UIBarButtonItem alloc] init];
        backButtonItem.title = @"";
        self.navigationItem.backBarButtonItem = backButtonItem;
        NickName_ViewController *nickName = [[NickName_ViewController alloc] init];
        nickName.original_nickname_str = [NSString stringIsEmpty:self.dictionary[@"tmi_name"]];
        [self.navigationController pushViewController:nickName animated:YES];
    }
    if (indexPath.row == 2) {
        UIBarButtonItem * backButtonItem = [[UIBarButtonItem alloc] init];
        backButtonItem.title = @"";
        self.navigationItem.backBarButtonItem = backButtonItem;
        UserName_ViewController *userName = [[UserName_ViewController alloc] init];
        userName.original_username_str = [NSString stringIsEmpty:self.dictionary[@"tmi_contact_name"]];
        [self.navigationController pushViewController:userName animated:YES];
    }
    if (indexPath.row == 4) {
        UIBarButtonItem * backButtonItem = [[UIBarButtonItem alloc] init];
        backButtonItem.title = @"";
        self.navigationItem.backBarButtonItem = backButtonItem;
        Province_TableViewController *province = [[Province_TableViewController alloc] init];
        [self.navigationController pushViewController:province animated:YES];
    }
}

#pragma mark UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"请输入详细地址"]) {
        textView.text = @"";
        self.address_text = textView.text;
        textView.textColor = [UIColor blackColor];
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"请输入地址";
        textView.textColor = [UIColor lightGrayColor];
    } else {
        self.address_text = textView.text;
    }
    return YES;
}

//实现UITextField代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];//取消第一响应者
    [self changeAddress];
    return YES;
}

#pragma mark 更改地址
- (void)changeAddress {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = NSLocalizedString(@"Preparing...", @"HUD preparing title");
    hud.minSize = CGSizeMake(150.f, 100.f);
    if (![self.address_text isEqualToString:@""] &&
        ![self.Province isEqualToString:@""] &&
        ![self.City isEqualToString:@""] &&
        ![self.Area isEqualToString:@""]) {
        Change_UesrName_Adress_Request *change_UesrName_Adress_Request = [[Change_UesrName_Adress_Request alloc] init];
        change_UesrName_Adress_Request.requestArgument = @{@"memberId":TMI_Id,
                                                           @"pid":[NSString stringIsEmpty:self.Province],
                                                           @"cid":[NSString stringIsEmpty:self.City],
                                                           @"oid":[NSString stringIsEmpty:self.Area],
                                                           @"address":self.address_text
                                                           };
        NSLog(@"requestArgument = %@",change_UesrName_Adress_Request.requestArgument);
        [change_UesrName_Adress_Request startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
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
            }
            [self get_member_info];
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
        hud.label.text = NSLocalizedString(@"请求失败!", @"HUD message title");;
        [hud mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.view);
        }];
        [hud hideAnimated:YES afterDelay:2.f];
    }
}

- (float)heightForTextView:(UITextView *)textView WithText:(NSString *) strText{
    CGSize constraint = CGSizeMake(textView.contentSize.width , CGFLOAT_MAX);
    CGRect size = [strText boundingRectWithSize:constraint
                                        options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                     attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}
                                        context:nil];
    float textHeight = size.size.height + 22.0;
    self.cell_height = textHeight;
//    NSLog(@"textHeight = %f",textHeight);
    return textHeight;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSLog(@"----当前的数 = %@",text);
    if ([[NSString  stringIsEmpty:text] isEqualToString:@""]) {
        //此时应该是删除
        NSLog(@"---删除");
        return YES;
    }
    if (![[NSString  stringIsEmpty:text] isEqualToString:@""] && ! [text isEqualToString:@"\n"]) {
        //此时应该是输入
        return YES;
    }
        [textView resignFirstResponder];
        [self changeAddress];
        return NO;

//    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
//        //在这里做你响应return键的代码
//        [textView resignFirstResponder];
//        [self changeAddress];
//        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
//    }
//
//    CGRect frame = textView.frame;
//    float  height = [ self heightForTextView:textView WithText:textView.text];
//    frame.size.height = height;
//    [UIView animateWithDuration:0.5 animations:^{
//        textView.frame = frame;
//    } completion:nil];
//    return YES;
}

#pragma mark 关闭键盘
-(void)viewTapped:(UITapGestureRecognizer*)tap1 {
    [self.view endEditing:YES];
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
