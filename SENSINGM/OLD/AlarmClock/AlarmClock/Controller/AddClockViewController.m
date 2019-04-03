//
//  AddClockViewController.m
//  Alarm_Clock_UserNotifications
//
//  Created by 欧阳荣 on 2017/5/23.
//  Copyright © 2017年 欧阳荣. All rights reserved.
//

#import "AddClockViewController.h"
#import "BaseTableViewController.h"
#import "AddAlarmClock_Request.h"
#import "Advance_TableViewController.h"
#import "Macro.h"

@interface AddClockViewController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *dataPicker;
@property (weak, nonatomic) IBOutlet UILabel *repeatLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UILabel *musicLabel;
@property (weak, nonatomic) IBOutlet UISwitch *laterSwitch;

@property (nonatomic, strong) NSMutableArray *date_array;
@property (nonatomic, copy) NSString *advance_time_str;
@end

@implementation AddClockViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(advance:) name:@"advance" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.date_array = [NSMutableArray array];
    
    self.view.backgroundColor = Line_Color;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    self.tableView.tableFooterView = [UIView new];
    
    [self.dataPicker setValue:[UIColor blackColor] forKey:@"textColor"];
    self.dataPicker.backgroundColor = [UIColor whiteColor];
    self.musicLabel.textColor = [UIColor blackColor];
    self.tagLabel.textColor = [UIColor blackColor];
    self.repeatLabel.textColor = [UIColor blackColor];
    
    if (_model) {
        self.dataPicker.date = _model.date;
        self.repeatLabel.text = _model.repeatStr;
        self.tagLabel.text = _model.tagStr;
        self.musicLabel.text = _model.music;
        self.laterSwitch.on = _model.isLater;
    }
    
}

- (void)advance:(NSNotification *)notif {
    self.advance_time_str = notif.object;
    [USER_DEF setObject:self.advance_time_str forKey:@"advance_time_str"];
    [USER_DEF synchronize];
    [self.tableView reloadData];
}

- (IBAction)action_backBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 保存按钮
- (IBAction)action_saveBtn:(id)sender {
    NSLog(@"repeatLabel = %@",self.repeatLabel.text);
    if([self.repeatLabel.text containsString:@"周日"]){
        [self.date_array addObject:@"7"];
        NSLog(@"date_array = %@",self.date_array);
    }

    if([self.repeatLabel.text containsString:@"周一"]){
        [self.date_array addObject:@"1"];
    }
    if([self.repeatLabel.text containsString:@"周二"]){
        [self.date_array addObject:@"2"];
    }
    if([self.repeatLabel.text containsString:@"周三"]){
        [self.date_array addObject:@"3"];
    }
    if([self.repeatLabel.text containsString:@"周四"]){
        [self.date_array addObject:@"4"];
    }
    if([self.repeatLabel.text containsString:@"周五"]){
        [self.date_array addObject:@"5"];
    }
    if([self.repeatLabel.text containsString:@"周六"]){
        [self.date_array addObject:@"6"];
    }
    if ([self.repeatLabel.text isEqualToString:@"每天"]) {
        self.date_array = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7", nil];
    }
    NSString *date_string = [self.date_array componentsJoinedByString:@","];
    NSLog(@"date_string = %@",date_string);
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = NSLocalizedString(@"Preparing...", @"HUD preparing title");
    hud.minSize = CGSizeMake(150.f, 100.f);

    AddAlarmClock_Request *addAlarmClock_Request = [[AddAlarmClock_Request alloc] init];
    addAlarmClock_Request.requestArgument = @{@"tmiId":TMI_Id,
                                              @"tacName":self.tagLabel.text,
                                              @"tacMusicName":self.musicLabel.text,
                                              @"tacAlarmTime":_dataPicker.date,
                                              @"tacAdvanceTime":self.advance_time_str,
                                              @"tacSwitch":@"1",
                                              @"tacCycleTime":date_string,
                                              };
    NSLog(@"requestArgument = %@",addAlarmClock_Request.requestArgument);
    [addAlarmClock_Request startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
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
            [self dismissViewControllerAnimated:YES completion:nil];
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

    
    
    self.model.date = _dataPicker.date;

    _model.music = _musicLabel.text;
    _model.tagStr = _tagLabel.text;
    _model.isLater = _laterSwitch.isOn;
//    _model.repeatStr = _repeatLabel.text;
    _model.isOn = YES;
    _model.isLater = self.laterSwitch.isOn;
    if (self.block) {
        self.block(_model);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    BaseTableViewController *baseVC = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"musicListVC"]) {
        baseVC.block = ^(NSString *text) {
            self.model.music = text;
            self.musicLabel.text = text;
        };
        baseVC.data = self.model.music;
    }else if ([segue.identifier isEqualToString:@"repeatVC"]) {
        baseVC.block = ^(NSArray *repeats) {
            self.model.repeatStrs = repeats;
            self.repeatLabel.text = self.model.repeatStr;
        };
        baseVC.data = self.model.repeatStrs;
    }else if ([segue.identifier isEqualToString:@"labelVC"]) {
        baseVC.block = ^(NSString *text) {
            self.model.tagStr = text;
            self.tagLabel.text = text;
        };
        baseVC.data = self.model.tagStr;
    } else if ([segue.identifier isEqualToString:@"AdvanceVC"]) {

    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (ClockModel *)model {
    if (!_model) {
        _model = [ClockModel new];
    }
    return _model;
}

@end
