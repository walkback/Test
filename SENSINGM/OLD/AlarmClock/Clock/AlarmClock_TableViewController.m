//
//  AlarmClock_TableViewController.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/7/9.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "AlarmClock_TableViewController.h"
#import "AddAlarmClock_ViewController.h"
#import "AlarmClock_TableViewCell.h"
#import <UserNotifications/UserNotifications.h>

#import "Clock_Request.h"
#import "DeleteClock_Request.h"
#import "Switch_Request.h"

#import "RecommedManager.h"
#import "ManagerTool.h"

@interface AlarmClock_TableViewController () <DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,UNUserNotificationCenterDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *week_arr;
    NSMutableArray *hour_arr;
    NSMutableArray *minte_arr;
    NSMutableArray *weekarray;
    NSMutableArray *time_array;
    dispatch_source_t _timer;
}

@property (nonatomic, strong) NSArray *data_array;
@property (nonatomic, copy) NSString *tacId;

@property (nonatomic, strong) NSString * changeRecommend;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSDictionary *dictionary;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *repeat_array;
@property (nonatomic) BOOL is_clock;

@property (nonatomic, strong) NSMutableArray * recommendArray;

@end

@implementation AlarmClock_TableViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh:) name:@"refresh" object:nil];
    [self  get_clock];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"闹钟";
    self.view.backgroundColor = [UIColor whiteColor];
    self.data_array = [NSArray array];
    self.repeat_array = [NSMutableArray array];
    self.is_clock = NO;

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(edit:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"添加"] style:UIBarButtonItemStyleDone target:self action:@selector(addAlarmClock:)];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, WIDTH - 20, HEIGHT - 50) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerClass:[AlarmClock_TableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(get_clock)];
    [self get_clock];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReciveNotification:) name:@"didReciveNotification" object:nil];
    
    [self startGCDTimer];
    
    UIApplication *app = [UIApplication sharedApplication];
    __block    UIBackgroundTaskIdentifier bgTask;
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid){
                bgTask = UIBackgroundTaskInvalid;
                [self startGCDTimer];
            }
        });
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid){
                bgTask = UIBackgroundTaskInvalid;
                [self startGCDTimer];
            }
        });
    });

}

-(void) startGCDTimer {
    // GCD定时器
//    static dispatch_source_t _timer;
    NSTimeInterval period = 11.0; //设置时间间隔
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0); //每秒执行
    // 事件回调
    dispatch_source_set_event_handler(_timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self clock_notif];
        });
    });

    // 开启定时器
    dispatch_resume(_timer);
    // 关闭定时器
    // dispatch_source_cancel(_timer);
}

#pragma mark 获取闹钟
- (void)get_clock {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = NSLocalizedString(@"Preparing...", @"HUD preparing title");
    hud.minSize = CGSizeMake(150.f, 100.f);
    
    if (![TMI_Id isEqualToString:@""]) {
        Clock_Request *clock_Request = [[Clock_Request alloc] init];
        clock_Request.requestArgument = @{@"tmiId":TMI_Id};
        [clock_Request startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
            NSLog(@"request = %@",request.responseJSONObject);
            int code = [request.responseJSONObject[@"code"] intValue];
            NSString *message = request.responseJSONObject[@"message"];
            if (code != 100) {
                [hud hideAnimated:YES];
                [self.tableView.mj_header endRefreshing];
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = message;
                [hud mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.mas_equalTo(self.view);
                }];
                [hud hideAnimated:YES afterDelay:2.f];
            } else {
                [hud hideAnimated:YES];
                [self.tableView.mj_header endRefreshing];
                self.data_array = request.responseJSONObject[@"tbAlarmClock"];
                [self clock_notif];
            }
            [self.tableView reloadData];
        } failure:^(__kindof LCBaseRequest *request, NSError *error) {
            [hud hideAnimated:YES];
            [self.tableView.mj_header endRefreshing];
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

- (void)clock_notif {
    week_arr = [NSMutableArray array];
    hour_arr = [NSMutableArray array];
    minte_arr = [NSMutableArray array];
    weekarray = [NSMutableArray array];
    time_array = [NSMutableArray array];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSDate *datenow = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |
    NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    comps = [calendar components:unitFlags fromDate:datenow];
    NSInteger week = [comps weekday];
    
    for (int i = 0; i < self.data_array.count; i++) {
        NSDictionary *dictionary = self.data_array[i];
        if ([dictionary[@"tacSwitch"] intValue] == 1) {
            if (![[NSString stringIsEmpty:dictionary[@"tacAdvanceTime"]] isEqualToString:@""]) {
                // 提前时间转成秒
                NSString *tacAdvanceTime_str = [NSString stringIsEmpty:dictionary[@"tacAdvanceTime"]];
                NSInteger seconds = [tacAdvanceTime_str intValue] * 60;
                // 闹钟时间戳
                NSString *alarmTime_str = [NSString stringWithFormat:@"%@",dictionary[@"tacAlarmTime"]];
                NSDate *alarmTime_date = [formatter dateFromString:alarmTime_str];
                NSDate *alarm = [alarmTime_date dateByAddingTimeInterval:-seconds];
                NSString *currentDateString = [formatter stringFromDate:alarm];
                [time_array addObject:[NSString stringIsEmpty:currentDateString]];
            } else {
                [time_array addObject:[NSString stringWithFormat:@"%@",dictionary[@"tacAlarmTime"]]];
            }
            [week_arr addObject:[NSString stringWithFormat:@"%@",dictionary[@"tacCycleTime"]]];
        }
    }
    NSString *week_str = [week_arr componentsJoinedByString:@","];
    NSArray *week_array = [week_str componentsSeparatedByString:@","];
    for (int i = 0; i < week_array.count; i++) {
        NSString *week_string = week_array[i];
        if ([[NSString stringIsEmpty:week_string] isEqualToString:@"每周日"]) {
            [weekarray addObject:@"1"];
        }
        if ([[NSString stringIsEmpty:week_string] isEqualToString:@"每周一"]) {
            [weekarray addObject:@"2"];
        }
        if ([[NSString stringIsEmpty:week_string] isEqualToString:@"每周二"]) {
            [weekarray addObject:@"3"];
        }
        if ([[NSString stringIsEmpty:week_string] isEqualToString:@"每周三"]) {
            [weekarray addObject:@"4"];
        }
        if ([[NSString stringIsEmpty:week_string] isEqualToString:@"每周四"]) {
            [weekarray addObject:@"5"];
        }
        if ([[NSString stringIsEmpty:week_string] isEqualToString:@"每周五"]) {
            [weekarray addObject:@"3"];
        }
        if ([[NSString stringIsEmpty:week_string] isEqualToString:@"每周六"]) {
            [weekarray addObject:@"7"];
        }
    }
    NSLog(@"time_array = %@",time_array);

    NSString *currentTimeString = [formatter stringFromDate:datenow];
    NSLog(@"currentTimeString = %@",currentTimeString);
    
    if (@available(iOS 10.0, *)) {
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        UNNotificationAction *action1 = [UNNotificationAction actionWithIdentifier:@"action1" title:@"需要解锁" options:UNNotificationActionOptionAuthenticationRequired];
        UNNotificationAction *action2 = [UNNotificationAction actionWithIdentifier:@"action2" title:@"启动app" options:UNNotificationActionOptionForeground];
        //intentIdentifiers，需要填写你想要添加到哪个推送消息的 id
        UNNotificationCategory *category1 = [UNNotificationCategory categoryWithIdentifier:@"category1" actions:@[action1, action2] intentIdentifiers:@[] options:UNNotificationCategoryOptionNone];
        
        UNNotificationAction *action3 = [UNNotificationAction actionWithIdentifier:@"action3" title:@"红色样式" options:UNNotificationActionOptionDestructive];
        UNNotificationAction *action4 = [UNNotificationAction actionWithIdentifier:@"action4" title:@"红色解锁启动" options:UNNotificationActionOptionAuthenticationRequired | UNNotificationActionOptionDestructive | UNNotificationActionOptionForeground];
        UNNotificationCategory *category2 = [UNNotificationCategory categoryWithIdentifier:@"category2" actions:@[action3, action4] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
        
        UNTextInputNotificationAction *action5 = [UNTextInputNotificationAction actionWithIdentifier:@"action5" title:@"" options:UNNotificationActionOptionForeground textInputButtonTitle:@"回复" textInputPlaceholder:@"写你想写的"];
        UNNotificationCategory *category3 = [UNNotificationCategory categoryWithIdentifier:@"category3" actions:@[action5] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
        
        [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:[NSSet setWithObjects:category1, category2, category3, nil]];
        content.categoryIdentifier = @"category2";
    } else {
        // Fallback on earlier versions
    }

    if ([weekarray containsObject:[NSString stringWithFormat:@"%ld",(long)week]] && [time_array containsObject:currentTimeString]) {
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = datenow;
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        if (@available(iOS 8.2, *)) {
            localNotification.alertTitle = @"闹钟";
        }
                
        localNotification.alertBody = [NSString stringWithFormat:@"%@",datenow];
        localNotification.userInfo = @{@"userkey":datenow};
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        
        dispatch_source_cancel(_timer);
        __weak typeof(self) weakSelf = self;
        int64_t delayInSeconds = 60.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [weakSelf startGCDTimer];
        });
    }

/**
    // 设备推送内容
    if (@available(iOS 10.0, *)) {
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        content.title = @"Clock";
        content.subtitle = @"subtitle";
        content.body = @"Copyright © 2016年 Hong. All rights reserved.";
        content.sound = [UNNotificationSound soundNamed:@"test.caf"];
        
        //每周三，13点触发
        NSDateComponents *components = [[NSDateComponents alloc] init];
//        if ([weekarray containsObject:[NSString stringWithFormat:@"%ld",(long)week]] && [time_array containsObject:currentTimeString]) {
            [components setWeekday:week];
//            [components setHour:minute];
            components.hour = 13;
            components.minute = 41;
//            NSLog(@"week = %ld,hour = %ld minute = %ld",(long)week,(long)hour,(long)minute);
            UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:YES];
            
            UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"request" content:content trigger:trigger];
            
            [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                NSLog(@"添加指定位置推送 ：%@", error ? [NSString stringWithFormat:@"error : %@", error] : @"success");
            }];
//        }
        [self.tableView reloadData];
    } else {
        
    }
**/
}

- (void)didReciveNotification:(NSNotification *)notif {
    NSMutableArray * allColorChangeArray = [NSMutableArray  array];
    NSArray * colorArray = @[@"000",@"015",@"015",@"005",@"040",@"000",@"065",@"005",@"000"];
    NSString * current = [ManagerTool  getCurrentHoursAndMinutesTimes];
    NSString * currentData = [current  stringByReplacingOccurrencesOfString:@":" withString:@""];
    NSLog(@"----输出当前的时间= %@",currentData);
    NSString * changeColor =  [RecommedManager  weakClockWithTime:currentData advanceTime:@"00" songNumber:@"4001" lould:@"5" colorArray:colorArray sleepTime:@"00" clockType:ClockWeeksPlayTypeWorkTime];
    [allColorChangeArray  addObject:changeColor];
    _changeRecommend = [RecommedManager weakClockRecommend:allColorChangeArray];
    NSLog(@"----唤醒配置导入的命令=%@", _changeRecommend);
    
//    [self.viewModel reciveNotificationWithIdentifer:notif.userInfo[@"idf"]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}


#pragma mark 刷新
- (void)refresh:(NSNotification *)notif {
    [self get_clock];
}

#pragma mark 编辑
- (void)edit:(UIBarButtonItem *)sender {
    sender.title = [sender.title isEqualToString:@"编辑"] ? @"完成" : @"编辑";
    BOOL edit = !self.tableView.editing;
    [self.tableView setEditing:edit animated:YES];
}

#pragma mark 添加闹钟
- (void)addAlarmClock:(UIButton *)sender {
    AddAlarmClock_ViewController *addAlarmClock = [[AddAlarmClock_ViewController alloc] init];
    addAlarmClock.select_tag = 2;
    [USER_DEF removeObjectForKey:@"repeat_time_string"];
    [USER_DEF removeObjectForKey:@"tacName"];
    [USER_DEF removeObjectForKey:@"music_name"];
    [USER_DEF removeObjectForKey:@"advanceTime_str"];
    UIBarButtonItem * backButtonItem = [[UIBarButtonItem alloc] init];
    backButtonItem.title = @"";
    self.navigationItem.backBarButtonItem = backButtonItem;
    [self.navigationController pushViewController:addAlarmClock animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.data_array.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AlarmClock_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    int R = (arc4random() % 256) ;
    int G = (arc4random() % 256) ;
    int B = (arc4random() % 256) ;

    cell.backgroundColor = [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1];
    [cell.layer setCornerRadius:10];
    cell.layer.masksToBounds = YES;
    
    NSDictionary *dictionary = self.data_array[indexPath.section];
    cell.time_Label.text = [NSString stringIsEmpty:dictionary[@"tacAlarmTime"]];
    cell.clockname_Label.text = [NSString stringIsEmpty:dictionary[@"tacName"]];
    


    
    NSString *tacCycleTime = [NSString stringIsEmpty:dictionary[@"tacCycleTime"]];
    NSArray *array = [tacCycleTime componentsSeparatedByString:@","];
    if ([array containsObject:@"每周日"] &&
        [array containsObject:@"每周一"] &&
        [array containsObject:@"每周二"] &&
        [array containsObject:@"每周三"] &&
        [array containsObject:@"每周四"] &&
        [array containsObject:@"每周五"] &&
        [array containsObject:@"每周六"] ) {
        cell.repeat_label.text = @"每周";
    } else {
        cell.repeat_label.text = [NSString stringIsEmpty:dictionary[@"tacCycleTime"]];
    }
    if ([[NSString stringIsEmpty:tacCycleTime] isEqualToString:@""]) {
        cell.repeat_label.text = @"永不";
    }
    
    NSString * time = [[NSString stringIsEmpty:dictionary[@"tacAlarmTime"]] stringByReplacingOccurrencesOfString:@":" withString:@""];
    if (indexPath.section == 0) {
        _recommendArray = [NSMutableArray array];
    }
    
    if ([[NSString stringIsEmpty:dictionary[@"tacSwitch"]] isEqualToString:@"1"]) {
        cell.switch_button.on = YES;
        if ([cell.repeat_label.text isEqualToString:@"每周"]) {
            //代表每一天
            //工作日
            NSString * contentRecommend = [RecommedManager  weakClockWithTime:[NSString  stringWithFormat:@"%@",time] advanceTime:@"05" songNumber:@"4001" lould:@"3" colorArray:@[@"001",@"001",@"010",@"010",@"100",@"100",@"110",@"110",@"111"] sleepTime:@"30" clockType:ClockWeeksPlayTypeWorkTime];
            NSLog(@"-----返回的数据1 = %@",contentRecommend);
            [_recommendArray  addObject:contentRecommend];
            //周六、周日
            NSString * contentWeekRecommend = [RecommedManager  weakClockWithTime:[NSString  stringWithFormat:@"%@",time] advanceTime:@"05" songNumber:@"4001" lould:@"3" colorArray:@[@"001",@"001",@"010",@"010",@"100",@"100",@"110",@"110",@"111"] sleepTime:@"30" clockType:ClockWeeksPlayTypeSundayTime];
            NSLog(@"-----返回的数据2 = %@",contentWeekRecommend);

            [_recommendArray  addObject:contentWeekRecommend];
        }else
        {
            NSString * cycleTime = cell.repeat_label.text ;
            if ([cycleTime  containsString:@"每周一"] && [cycleTime containsString:@"每周二"] &&[cycleTime containsString:@"每周三"] && [cycleTime containsString:@"每周四"] &&[cycleTime containsString:@"每周五"]) {
                NSString * contentRecommend = [RecommedManager  weakClockWithTime:[NSString  stringWithFormat:@"%@",time] advanceTime:@"05" songNumber:@"4001" lould:@"3" colorArray:@[@"001",@"001",@"010",@"010",@"100",@"100",@"110",@"110",@"111"] sleepTime:@"30" clockType:ClockWeeksPlayTypeWorkTime];
                [_recommendArray  addObject:contentRecommend];
            }else{
                if ([cycleTime containsString:@"每周六"] && [cycleTime containsString:@"每周日"]) {
                    NSString * contentRecommend = [RecommedManager  weakClockWithTime:[NSString  stringWithFormat:@"%@",time] advanceTime:@"05" songNumber:@"4001" lould:@"3" colorArray:@[@"001",@"001",@"010",@"010",@"100",@"100",@"110",@"110",@"111"] sleepTime:@"30" clockType:ClockWeeksPlayTypeSundayTime];
                    [_recommendArray  addObject:contentRecommend];
                }else
                {
                    if ([cycleTime containsString:@"每周一"]) {
                        NSString * contentRecommend = [RecommedManager  weakClockWithTime:[NSString  stringWithFormat:@"%@",time] advanceTime:@"05" songNumber:@"4001" lould:@"3" colorArray:@[@"001",@"001",@"010",@"010",@"100",@"100",@"110",@"110",@"111"] sleepTime:@"30" clockType:ClockWeeksPlayTypeMonday];
                        [_recommendArray  addObject:contentRecommend];
                    }
                    if ([cycleTime containsString:@"每周二"]) {
                        NSString * contentRecommend = [RecommedManager  weakClockWithTime:[NSString  stringWithFormat:@"%@",time] advanceTime:@"05" songNumber:@"4001" lould:@"3" colorArray:@[@"001",@"001",@"010",@"010",@"100",@"100",@"110",@"110",@"111"] sleepTime:@"30" clockType:ClockWeeksPlayTypeTuesday];
                        [_recommendArray  addObject:contentRecommend];
                    }
                    if ([cycleTime containsString:@"每周三"]) {
                        NSString * contentRecommend = [RecommedManager  weakClockWithTime:[NSString  stringWithFormat:@"%@",time] advanceTime:@"05" songNumber:@"4001" lould:@"3" colorArray:@[@"001",@"001",@"010",@"010",@"100",@"100",@"110",@"110",@"111"] sleepTime:@"30" clockType:ClockWeeksPlayTypeWednesday];
                        [_recommendArray  addObject:contentRecommend];
                    }
                    if ([cycleTime containsString:@"每周四"]) {
                        NSString * contentRecommend = [RecommedManager  weakClockWithTime:[NSString  stringWithFormat:@"%@",time] advanceTime:@"05" songNumber:@"4001" lould:@"3" colorArray:@[@"001",@"001",@"010",@"010",@"100",@"100",@"110",@"110",@"111"] sleepTime:@"30" clockType:ClockWeeksPlayTypeThursday];
                        [_recommendArray  addObject:contentRecommend];
                    }
                    if ([cycleTime containsString:@"每周五"]) {
                        NSString * contentRecommend = [RecommedManager  weakClockWithTime:[NSString  stringWithFormat:@"%@",time] advanceTime:@"05" songNumber:@"4001" lould:@"3" colorArray:@[@"001",@"001",@"010",@"010",@"100",@"100",@"110",@"110",@"111"] sleepTime:@"30" clockType:ClockWeeksPlayTypeFriday];
                        [_recommendArray  addObject:contentRecommend];
                    }
                    if ([cycleTime containsString:@"每周六"]) {
                        NSString * contentRecommend = [RecommedManager  weakClockWithTime:[NSString  stringWithFormat:@"%@",time] advanceTime:@"05" songNumber:@"4001" lould:@"3" colorArray:@[@"001",@"001",@"010",@"010",@"100",@"100",@"110",@"110",@"111"] sleepTime:@"30" clockType:ClockWeeksPlayTypeSaturday];
                        [_recommendArray  addObject:contentRecommend];
                    }
                    if ([cycleTime containsString:@"每周日"]) {
                        NSString * contentRecommend = [RecommedManager  weakClockWithTime:[NSString  stringWithFormat:@"%@",time] advanceTime:@"05" songNumber:@"4001" lould:@"3" colorArray:@[@"001",@"001",@"010",@"010",@"100",@"100",@"110",@"110",@"111"] sleepTime:@"30" clockType:ClockWeeksPlayTypeSunday];
                        [_recommendArray  addObject:contentRecommend];
                    }
                    
                }
            }
            
        }

    } else {
        cell.switch_button.on = NO;
        cell.backgroundColor = Line_Color;
    }
    cell.switch_button.tag = indexPath.section;
    [cell.switch_button addTarget:self action:@selector(alarmclock:) forControlEvents:UIControlEventValueChanged];
    
    if (indexPath.section == self.data_array.count - 1 &&  _recommendArray.count > 0) {
        NSString * clockRecommend = [RecommedManager  weakClockRecommend:_recommendArray];
        NSLog(@"发送前的命令 = %@",clockRecommend);
        [[AyncSocketManager  shareAyncManager] postRecommed:clockRecommend result:^(NSString *task) {
            NSLog(@"发送后的命令 结果= %@",task);
        }];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (self.tableView.editing) {
        NSDictionary *dictionary = self.data_array[indexPath.section];
    UIBarButtonItem * backButtonItem = [[UIBarButtonItem alloc] init];
    backButtonItem.title = @"";
    self.navigationItem.backBarButtonItem = backButtonItem;
        AddAlarmClock_ViewController *addAlarmClock = [[AddAlarmClock_ViewController alloc] init];
    addAlarmClock.tacId = [NSString stringIsEmpty:dictionary[@"tacId"]];
    addAlarmClock.music_name = [NSString stringIsEmpty:dictionary[@"tacMusicName"]];
    addAlarmClock.tacName = [NSString stringIsEmpty:dictionary[@"tacName"]];
        addAlarmClock.advanceTime_str = [NSString stringIsEmpty:dictionary[@"tacAdvanceTime"]];
        addAlarmClock.time_string = [NSString stringIsEmpty:dictionary[@"tacAlarmTime"]];
        addAlarmClock.select_tag = 1;
        addAlarmClock.repeat_time_string = [NSString stringIsEmpty:dictionary[@"tacCycleTime"]];
        [self.navigationController pushViewController:addAlarmClock animated:YES];
//    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerview = [UIView new];
    headerview.backgroundColor = [UIColor whiteColor];
    return headerview;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerview = [UIView new];
    footerview.backgroundColor = [UIColor whiteColor];
    return footerview;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dictionary = self.data_array[indexPath.section];
    self.tacId = [NSString stringIsEmpty:dictionary[@"tacId"]];
    [self deleteclcok];
}

#pragma mark 删除闹钟
- (void)deleteclcok {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = NSLocalizedString(@"正在加载...", @"HUD preparing title");
    hud.minSize = CGSizeMake(150.f, 100.f);
    
    if (![[NSString stringIsEmpty:self.tacId] isEqualToString:@""]) {
        DeleteClock_Request *deleteClock_Request = [[DeleteClock_Request alloc] init];
        deleteClock_Request.requestArgument = @{@"tacId":self.tacId};
        NSLog(@"requestArgument = %@",deleteClock_Request.requestArgument);
        [deleteClock_Request startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
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
                [self get_clock];
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
}

#pragma mark 闹钟开关
- (void)alarmclock:(UISwitch *)sender {
    NSLog(@"%ld",(long)sender.tag);
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = NSLocalizedString(@"正在加载...", @"HUD preparing title");
    hud.minSize = CGSizeMake(150.f, 100.f);
    
    NSString *tac_Switch = [[NSString alloc] init];
    NSDictionary *dictionary = self.data_array[sender.tag];
    NSString *tacId = [NSString stringIsEmpty:[NSString stringWithFormat:@"%@",dictionary[@"tacId"]]];
    NSString *tacSwitch = [NSString stringIsEmpty:[NSString stringWithFormat:@"%@",dictionary[@"tacSwitch"]]];
    if ([[NSString stringIsEmpty:tacSwitch] isEqualToString:@"1"]) {
        tac_Switch = @"2";
    } else {
        tac_Switch = @"1";
    }
    
    if (![[NSString stringIsEmpty:tacId] isEqualToString:@""]) {
        Switch_Request *switch_Request = [[Switch_Request alloc] init];
        switch_Request.requestArgument = @{@"tacId":tacId,@"tacSwitch":tac_Switch};
        [switch_Request startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
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
                [self get_clock];
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
        hud.label.text = NSLocalizedString(@"缺少参数!", @"HUD message title");;
        [hud mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.view);
        }];
        [hud hideAnimated:YES afterDelay:2.f];
    }
}


#pragma mark DZNEmptyDataSetDelegate----------------
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"无设备"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"暂无闹钟";
    return [[NSAttributedString alloc] initWithString:text attributes:nil];
}



@end
