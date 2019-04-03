//
//  AddAlarmClock_ViewController.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/7/9.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "AddAlarmClock_ViewController.h"
#import "AddAlarmClock_TableViewCell.h"

#import "RepeatTime_TableViewController.h"
#import "Advance_TableViewController.h"
#import "MusicSelect_TableViewController.h"
#import "ClockName_ViewController.h"

#import "Modify_Request.h"
#import "AddAlarmClock_Request.h"

@interface AddAlarmClock_ViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *repeat_arr;

//@property (nonatomic, strong) NSString *pick_date_str;
@end

@implementation AddAlarmClock_ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(repeattime:) name:@"repeattime" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(advance:) name:@"advance" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(music:) name:@"music" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(text_string:) name:@"text_string" object:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(save:)];
    
    self.title = @"添加闹钟";
    self.view.backgroundColor = Line_Color;
    
    self.repeat_arr = [NSArray array];
    
    self.datePicker = [[UIDatePicker alloc] init];
    [self.datePicker addTarget:self action:@selector(datePickerChange:) forControlEvents:UIControlEventValueChanged];
    self.datePicker.datePickerMode = UIDatePickerModeTime;
    [self.view addSubview:self.datePicker];
    if (KIsiPhoneX) {
        [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(88);
            make.left.right.equalTo(self.view);
            make.height.mas_equalTo(200);
        }];
    } else {
        [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(64);
            make.left.right.equalTo(self.view);
            make.height.mas_equalTo(200);
        }];
    }
    
    if (self.select_tag == 1) {
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        format.dateFormat = @"HH:mm";
        NSDate *date = [format dateFromString:self.time_string];
        NSLog(@"date = %@",date);
        self.datePicker.date = date;
    }
    
    self.tableView = [[UITableView alloc] init];
    [self.tableView registerClass:[AddAlarmClock_TableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.datePicker.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(176);
    }];
}

#pragma mark 保存时间
- (void)save:(UIButton *)sender {
    if (self.select_tag == 1) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = NSLocalizedString(@"Preparing...", @"HUD preparing title");
        hud.minSize = CGSizeMake(150.f, 100.f);
        if (![[NSString stringIsEmpty:TMI_Id] isEqualToString:@""] &&
            ![[NSString stringIsEmpty:self.time_string] isEqualToString:@""] &&
            ![[NSString stringIsEmpty:self.repeat_time_string] isEqualToString:@""]) {
            Modify_Request *modify_Request = [[Modify_Request alloc] init];
            modify_Request.requestArgument = @{@"tacId":self.tacId,
                                               @"tacName":[NSString stringIsEmpty:self.tacName],
                                               @"tacMusicName":[NSString stringIsEmpty:self.music_name],
                                               @"tacSwitch":@"1",
                                               @"tacAlarmTime":[NSString stringIsEmpty:self.time_string],
                                               @"tacAdvanceTime":[NSString stringIsEmpty:self.advanceTime_str],
                                               @"tacCycleTime":[NSString stringIsEmpty:self.repeat_time_string]
                                               };
            NSLog(@"requestArgument = %@",modify_Request.requestArgument);
            [modify_Request startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
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
                    [self.navigationController popViewControllerAnimated:YES];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh" object:nil];
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
            [hud hideAnimated:YES];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"缺少必要参数!", @"HUD message title");;
            [hud mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(self.view);
            }];
            [hud hideAnimated:YES afterDelay:2.f];
        }
    } else if (self.select_tag == 2) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = NSLocalizedString(@"Preparing...", @"HUD preparing title");
        hud.minSize = CGSizeMake(150.f, 100.f);
        
        if (![[NSString stringIsEmpty:TMI_Id] isEqualToString:@""] &&
            ![[NSString stringIsEmpty:self.time_string] isEqualToString:@""] &&
            ![[NSString stringIsEmpty:self.repeat_time_string] isEqualToString:@""]) {
            AddAlarmClock_Request *addAlarmClock_Request = [[AddAlarmClock_Request alloc] init];
            addAlarmClock_Request.requestArgument = @{@"tacMemberId":TMI_Id,
                                                      @"tacName":[NSString stringIsEmpty:self.tacName],
                                                      @"tacMusicName":[NSString stringIsEmpty:self.music_name],
                                                      @"tacSwitch":@"1",
                                                      @"tacAlarmTime":[NSString stringIsEmpty:self.time_string],
                                                      @"tacAdvanceTime":[NSString stringIsEmpty:self.advanceTime_str],
                                                      @"tacCycleTime":[NSString stringIsEmpty:self.repeat_time_string]
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
                    [self.navigationController popViewControllerAnimated:YES];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh" object:nil];
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
            [hud hideAnimated:YES];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"缺少必要参数!", @"HUD message title");;
            [hud mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(self.view);
            }];
            [hud hideAnimated:YES afterDelay:2.f];
        }
    }
}

#pragma mark 时间选取
- (void)datePickerChange:(UIDatePicker *)paramPicker{
    NSLog(@"Selected date = %@", paramPicker.date);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    self.time_string = [dateFormatter stringFromDate:paramPicker.date];
}

#pragma mark 重复时间
- (void)repeattime:(NSNotification *)notif {
    self.repeat_arr = notif.object;
    self.repeat_time_string = [self.repeat_arr componentsJoinedByString:@","];
    if (self.select_tag == 2) {
        [USER_DEF setObject:self.repeat_time_string  forKey:@"repeat_time_string"];
        [USER_DEF synchronize];
    }
    [self.tableView reloadData];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"repeattime" object:nil];
}

#pragma mark 闹钟名称
- (void)text_string:(NSNotification *)notif {
    self.tacName = notif.object;
    if (self.select_tag == 2) {
        [USER_DEF setObject:self.tacName  forKey:@"tacName"];
        [USER_DEF synchronize];
    }
    [self.tableView reloadData];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"text_string" object:nil];
}

#pragma mark 音乐
- (void)music:(NSNotification *)notif {
    self.music_name = notif.object;
    if (self.select_tag == 2) {
        [USER_DEF setObject:self.music_name  forKey:@"music_name"];
        [USER_DEF synchronize];
    }
    [self.tableView reloadData];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"music" object:nil];
}


#pragma mark 提前时间
- (void)advance:(NSNotification *)notif {
    NSString *time = notif.object;
    if ([time isEqualToString:@"不提前"]) {
        self.advanceTime_str = @"";
    }
    if ([time isEqualToString:@"5分钟"]) {
        self.advanceTime_str = @"5";
    }
    if ([time isEqualToString:@"10分钟"]) {
        self.advanceTime_str = @"10";
    }
    if ([time isEqualToString:@"20分钟"]) {
        self.advanceTime_str = @"20";
    }
    if ([time isEqualToString:@"30分钟"]) {
        self.advanceTime_str = @"30";
    }
    if (self.select_tag == 2) {
        [USER_DEF setObject:self.advanceTime_str  forKey:@"advanceTime_str"];
        [USER_DEF synchronize];
    }
    [self.tableView reloadData];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"advance" object:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddAlarmClock_TableViewCell *addAlarmClock = [[AddAlarmClock_TableViewCell alloc] init];
    
    if (indexPath.row == 0) {
        addAlarmClock.name_label.text = @"重复";
        if (self.select_tag == 1) {
            if ([[NSString stringIsEmpty:self.repeat_time_string] isEqualToString:@""]) {
                addAlarmClock.detail_label.text = @"永不";
            } else {
                NSArray *array = [self.repeat_time_string componentsSeparatedByString:@","];
                NSMutableArray *date_array = [NSMutableArray array];
                if ([array containsObject:@"每周日"] &&
                    [array containsObject:@"每周一"] &&
                    [array containsObject:@"每周二"] &&
                    [array containsObject:@"每周三"] &&
                    [array containsObject:@"每周四"] &&
                    [array containsObject:@"每周五"] &&
                    [array containsObject:@"每周六"] ) {
                    addAlarmClock.detail_label.text = @"每周";
                } else {
                    if ([array containsObject:@"7"] || [array containsObject:@"每周日"]) {
                        [date_array addObject:@"周日"];
                    }
                    if ([array containsObject:@"1"] || [array containsObject:@"每周一"]) {
                        [date_array addObject:@"周一"];
                    }
                    if ([array containsObject:@"2"] || [array containsObject:@"每周二"]) {
                        [date_array addObject:@"周二"];
                    }
                    if ([array containsObject:@"3"] || [array containsObject:@"每周三"]) {
                        [date_array addObject:@"周三"];
                    }
                    if ([array containsObject:@"4"] || [array containsObject:@"每周四"]) {
                        [date_array addObject:@"周四"];
                    }
                    if ([array containsObject:@"5"] || [array containsObject:@"每周五"]) {
                        [date_array addObject:@"周五"];
                    }
                    if ([array containsObject:@"6"] || [array containsObject:@"每周六"]) {
                        [date_array addObject:@"周六"];
                    }
                    NSString *date_string = [date_array componentsJoinedByString:@","];
                    addAlarmClock.detail_label.text = [NSString stringIsEmpty:date_string];
                }
            }
        } else if (self.select_tag == 2) {
            if ([[NSString stringIsEmpty:[USER_DEF objectForKey:@"repeat_time_string"]] isEqualToString:@""]) {
                addAlarmClock.detail_label.text = @"永不";
            } else {
                NSArray *array = [[NSString stringIsEmpty:[USER_DEF objectForKey:@"repeat_time_string"]] componentsSeparatedByString:@","];
                NSMutableArray *date_array = [NSMutableArray array];
                if ([array containsObject:@"每周日"] &&
                    [array containsObject:@"每周一"] &&
                    [array containsObject:@"每周二"] &&
                    [array containsObject:@"每周三"] &&
                    [array containsObject:@"每周四"] &&
                    [array containsObject:@"每周五"] &&
                    [array containsObject:@"每周六"] ) {
                    addAlarmClock.detail_label.text = @"每周";
                } else {
                    if ([array containsObject:@"7"] || [array containsObject:@"每周日"]) {
                        [date_array addObject:@"周日"];
                    }
                    if ([array containsObject:@"1"] || [array containsObject:@"每周一"]) {
                        [date_array addObject:@"周一"];
                    }
                    if ([array containsObject:@"2"] || [array containsObject:@"每周二"]) {
                        [date_array addObject:@"周二"];
                    }
                    if ([array containsObject:@"3"] || [array containsObject:@"每周三"]) {
                        [date_array addObject:@"周三"];
                    }
                    if ([array containsObject:@"4"] || [array containsObject:@"每周四"]) {
                        [date_array addObject:@"周四"];
                    }
                    if ([array containsObject:@"5"] || [array containsObject:@"每周五"]) {
                        [date_array addObject:@"周五"];
                    }
                    if ([array containsObject:@"6"] || [array containsObject:@"每周六"]) {
                        [date_array addObject:@"周六"];
                    }
                    NSString *date_string = [date_array componentsJoinedByString:@","];
                    addAlarmClock.detail_label.text = [NSString stringIsEmpty:date_string];
                }
            }
        }
    }
    if (indexPath.row == 1) {
        addAlarmClock.name_label.text = @"唤醒模式";
        if (self.select_tag == 1) {
            addAlarmClock.detail_label.text = [NSString stringIsEmpty:self.tacName];
        } else if (self.select_tag == 2) {
            addAlarmClock.detail_label.text = [NSString stringIsEmpty:[USER_DEF objectForKey:@"tacName"]];
        }
    }
    if (indexPath.row == 2) {
        addAlarmClock.name_label.text = @"音乐";
        if (self.select_tag == 1) {
            addAlarmClock.detail_label.text = [NSString stringIsEmpty:self.music_name];
        } else if (self.select_tag == 2) {
            addAlarmClock.detail_label.text = [NSString stringIsEmpty:[USER_DEF objectForKey:@"music_name"]];
        }
    }
    if (indexPath.row == 3) {
        addAlarmClock.name_label.text = @"提前时间";
        if (self.select_tag == 1) {
            if (![[NSString stringIsEmpty:self.advanceTime_str] isEqualToString:@""]) {
                addAlarmClock.detail_label.text = [NSString stringWithFormat:@"%@分钟",[NSString stringIsEmpty:self.advanceTime_str]];
            } else {
                addAlarmClock.detail_label.text = @"";
            }
        } else if (self.select_tag == 2) {
            if (![[NSString stringIsEmpty:[USER_DEF objectForKey:@"advanceTime_str"]] isEqualToString:@""]){
                addAlarmClock.detail_label.text = [NSString stringWithFormat:@"%@分钟",[NSString stringIsEmpty:[USER_DEF objectForKey:@"advanceTime_str"]]];
            } else {
                addAlarmClock.detail_label.text = @"";
            }
        }
    }
    
    addAlarmClock.selectionStyle = UITableViewCellSelectionStyleNone;
    addAlarmClock.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return addAlarmClock;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        RepeatTime_TableViewController *repeatTime = [[RepeatTime_TableViewController alloc] init];
        repeatTime.select_tag = self.select_tag;
        if (self.select_tag == 1) {
            repeatTime.repeat_time_string = [NSString stringIsEmpty:self.repeat_time_string];
        } else if (self.select_tag == 2) {
            repeatTime.repeat_time_string = [NSString stringIsEmpty:[USER_DEF objectForKey:@"repeat_time_string"]];
        }
        UIBarButtonItem * backButtonItem = [[UIBarButtonItem alloc] init];
        backButtonItem.title = @"";
        self.navigationItem.backBarButtonItem = backButtonItem;
        [self.navigationController pushViewController:repeatTime animated:YES];
    }
    if (indexPath.row == 1) {
        ClockName_ViewController *clockName = [[ClockName_ViewController alloc] init];
        clockName.select_tag = self.select_tag;
        if (self.select_tag == 1) {
            clockName.tacName = [NSString stringIsEmpty:self.tacName];
        } else if (self.select_tag == 2) {
            clockName.tacName = [NSString stringIsEmpty:[USER_DEF objectForKey:@"tacName"]];
        }
        UIBarButtonItem * backButtonItem = [[UIBarButtonItem alloc] init];
        backButtonItem.title = @"";
        self.navigationItem.backBarButtonItem = backButtonItem;
        [self.navigationController pushViewController:clockName animated:YES];
    }
    if (indexPath.row == 2) {
        MusicSelect_TableViewController *musicSelect = [[MusicSelect_TableViewController alloc] init];
        musicSelect.select_tag = self.select_tag;
        if (self.select_tag == 1) {
            musicSelect.music_name = [NSString stringIsEmpty:self.music_name];
        } else if (self.select_tag == 2) {
            musicSelect.music_name = [NSString stringIsEmpty:[USER_DEF objectForKey:@"music_name"]];
        }
        UIBarButtonItem * backButtonItem = [[UIBarButtonItem alloc] init];
        backButtonItem.title = @"";
        self.navigationItem.backBarButtonItem = backButtonItem;
        [self.navigationController pushViewController:musicSelect animated:YES];
    }
    if (indexPath.row == 3) {
        Advance_TableViewController *advance = [[Advance_TableViewController alloc] init];
        advance.select_tag = self.select_tag;
        if (self.select_tag == 1) {
            advance.advance_str = [NSString stringIsEmpty:self.advanceTime_str];
        } else if (self.select_tag == 2) {
            advance.advance_str = [NSString stringIsEmpty:[USER_DEF objectForKey:@"advanceTime_str"]];
        }
        UIBarButtonItem * backButtonItem = [[UIBarButtonItem alloc] init];
        backButtonItem.title = @"";
        self.navigationItem.backBarButtonItem = backButtonItem;
        [self.navigationController pushViewController:advance animated:YES];
    }
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
