//
//  UserInfo_ViewController.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/12/12.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "UserInfo_ViewController.h"
#import "UserInfo_Cell.h"
#import "Sex_Cell.h"
#import "UIView+MLCore.h"
#import "UIPickData_ViewController.h"

@interface UserInfo_ViewController () <UITableViewDelegate,UITableViewDataSource,PGDatePickerDelegate>
{
    UITableView *tableView;
}

@property (nonatomic, strong) NSArray *title_array;

@property (nonatomic, copy) NSString *name_string;

@property (nonatomic, assign) BOOL boy_bool;
@property (nonatomic, assign) BOOL girl_bool;

@property (nonatomic, copy) NSString *birthday_string;
@property (nonatomic, copy) NSString *height_string;
@property (nonatomic, copy) NSString *bodyWeight_string;
@property (nonatomic, copy) NSString *character_string;
@end

@implementation UserInfo_ViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[self createImageWithColor:Nav_BG_Color] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(character:) name:@"character" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"角色信息";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor],NSFontAttributeName: [UIFont systemFontOfSize:17]}];
    self.navigationController.navigationBar.tintColor = TEXTCOLOR;
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.title_array = @[@"姓名",@"性别",@"出生年月",@"身高",@"体重",@"性格",@"所在房间"];
    
    _boy_bool = false;
    _girl_bool = false;
    
    UIButton *save_but = [UIButton new];
    [save_but setBackgroundColor:Nav_BG_Color];
    [save_but setTitle:@"保存" forState:UIControlStateNormal];
    [save_but setTitleColor:TEXTCOLOR forState:UIControlStateNormal];
    [self.view addSubview:save_but];
    [save_but mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    
    tableView = [[UITableView alloc] init];
    tableView.backgroundColor = [UIColor colorWithRed:239/255.0 green:242/255.0 blue:245/255.0 alpha:1.0];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [tableView registerClass:[UserInfo_Cell class] forCellReuseIdentifier:@"UserInfo"];
    [tableView registerClass:[Sex_Cell class] forCellReuseIdentifier:@"Sex"];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorInset=UIEdgeInsetsMake(0,15, 0, 15);           //top left bottom right 左右边距相同
    tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 200;
    tableView.tableFooterView = [UIView new];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(save_but.mas_top);
    }];
}

#pragma mark 性格
- (void)character:(NSNotification *)notif {
    self.character_string = notif.object;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:5 inSection:0];
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserInfo_Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfo" forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        cell.title_lab.text = self.title_array[indexPath.row];
        cell.content_lab.text = [NSString stringIsEmpty:self.name_string];
    } else if (indexPath.row == 1) {
        Sex_Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"Sex" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.title_lab.text = self.title_array[indexPath.row];
        
        [[[cell.boy_but rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
            self->_boy_bool = true;
            self->_girl_bool = false;
            [cell.boy_but setBackgroundColor:UIColor.greenColor];
            [cell.girl_but setBackgroundColor:UIColor.whiteColor];
        }];
        
        [[[cell.girl_but rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
            self->_boy_bool = false;
            self->_girl_bool = true;
            [cell.boy_but setBackgroundColor:UIColor.whiteColor];
            [cell.girl_but setBackgroundColor:UIColor.greenColor];
            
        }];
        
        return cell;
    } else if (indexPath.row == 2) {
        cell.title_lab.text = self.title_array[indexPath.row];
        cell.content_lab.text = [NSString stringIsEmpty:self.birthday_string];
    } else if (indexPath.row == 3) {
        cell.title_lab.text = self.title_array[indexPath.row];
        cell.content_lab.text = [NSString stringWithFormat:@"%@cm",[NSString stringIsEmpty:self.height_string]];
    } else if (indexPath.row == 4) {
        cell.title_lab.text = self.title_array[indexPath.row];
        cell.content_lab.text = [NSString stringWithFormat:@"%@kg",[NSString stringIsEmpty:self.bodyWeight_string]];
    } else if (indexPath.row == 5) {
        cell.title_lab.text = self.title_array[indexPath.row];
        cell.content_lab.text = [NSString stringIsEmpty:self.character_string];
    } else if (indexPath.row == 6) {
        cell.title_lab.text = self.title_array[indexPath.row];
        cell.content_lab.text = @"卧室";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"输入姓名" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertactin = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *name = alertcontroller.textFields.firstObject;
            self.name_string = name.text;
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        }];
        [alertcontroller addAction:alertactin];
        [alertcontroller addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"输入姓名";
        }];
        [self presentViewController:alertcontroller animated:true completion:nil];
    }
    if (indexPath.row == 2) {
        PGDatePickManager *datePickManager = [[PGDatePickManager alloc] init];
        PGDatePicker *datePicker = datePickManager.datePicker;
        datePicker.datePickerMode = PGDatePickerModeDate;
        datePicker.delegate = self;
        [self presentViewController:datePickManager animated:true completion:nil];
    }
    if (indexPath.row == 3) {
        UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"输入身高" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertactin = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *height = alertcontroller.textFields.firstObject;
            self.height_string = height.text;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        }];
        [alertcontroller addAction:alertactin];
        [alertcontroller addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.keyboardType = UIKeyboardTypeNumberPad;
            textField.placeholder = @"输入身高";
        }];
        [self presentViewController:alertcontroller animated:true completion:nil];
    }
    if (indexPath.row == 4) {
        UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"输入体重" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertactin = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *bodyWeight = alertcontroller.textFields.firstObject;
            self.bodyWeight_string = bodyWeight.text;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        }];
        [alertcontroller addAction:alertactin];
        [alertcontroller addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.keyboardType = UIKeyboardTypeNumberPad;
            textField.placeholder = @"输入体重";
        }];
        [self presentViewController:alertcontroller animated:true completion:nil];
    }
    if (indexPath.row == 5) {
        UIPickData_ViewController *pickData = [[UIPickData_ViewController alloc] init];
        pickData.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [self presentViewController:pickData animated:YES completion:nil];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
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

#pragma mark PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    self.birthday_string = [NSString stringWithFormat:@"%ld/%ld/%ld",
                            (long)dateComponents.year,
                            (long)dateComponents.month,
                            (long)dateComponents.day];
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:2 inSection:0];
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
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
