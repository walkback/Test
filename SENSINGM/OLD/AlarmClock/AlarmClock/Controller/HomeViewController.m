//
//  ViewController.m
//  Alarm_Clock_UserNotifications
//
//  Created by 欧阳荣 on 2017/5/12.
//  Copyright © 2017年 欧阳荣. All rights reserved.
//

#import "HomeViewController.h"
#import "AlarmClockCell.h"
#import "ClockViewModel.h"
#import "AddClockViewController.h"
#import "Clock_Request.h"
#import "Macro.h"


@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource, AlarmClockCellDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) ClockViewModel *viewModel;
@property (nonatomic, strong) NSArray *data_array;

@end

@implementation HomeViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.mm_drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeNone;
    self.mm_drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeNone;
    
    if (self.tableView.editing) {
        [self action_editBtn:self.navigationItem.leftBarButtonItem];
    }
}

//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
//    return YES ;
//}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"闹钟";
    self.view.backgroundColor = Line_Color;
    
    self.data_array = [NSArray array];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReciveNotification:) name:@"didReciveNotification" object:nil];
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.tableFooterView = [UIView new];
//    self.tableView.allowsSelectionDuringEditing
    
    [self get_clock];
}

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
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = message;
                [hud mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.mas_equalTo(self.view);
                }];
                [hud hideAnimated:YES afterDelay:2.f];
            } else {
                [hud hideAnimated:YES];
                self.data_array = request.responseJSONObject[@"tbAlarmClock"];
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

- (void)didReciveNotification:(NSNotification *)notif {
    [self.viewModel reciveNotificationWithIdentifer:notif.userInfo[@"idf"]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (IBAction)action_editBtn:(UIBarButtonItem *)sender {
    sender.title = [sender.title isEqualToString:@"编辑"] ? @"完成" : @"编辑";
    BOOL edit = !self.tableView.editing;
    [self.tableView setEditing:edit animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *nav = segue.destinationViewController;
    
    AddClockViewController *vc = (AddClockViewController *)nav.topViewController;
    if ([segue.identifier isEqualToString:@"addPresentVCIdf"]) {
        vc.block = ^(ClockModel *model){
            [self.viewModel addClockModel:model];
            [self.tableView reloadData];
        };
    }else {
        vc.model = self.viewModel.clockData[self.tableView.indexPathForSelectedRow.row];
        vc.block = ^(ClockModel *model){
//            NSLog(@"%ld", self.tableView.indexPathForSelectedRow.row);
            [self.viewModel replaceModelAtIndex:self.tableView.indexPathForSelectedRow.row withModel:model];
            [self.tableView reloadData];
        };
    }
}

#pragma mark 添加闹钟

#pragma mark -- UITableViewDelegate && UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.viewModel.clockData.count;
    return self.data_array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AlarmClockCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlarmClockCell" forIndexPath:indexPath];
    NSDictionary *dictionary = self.data_array[indexPath.row];
    cell.timeLabel.text = [NSString stringIsEmpty:dictionary[@"tacAlarmTime"]];
    
//    cell.model = self.viewModel.clockData[indexPath.row];
//    cell.model = self.data_array[indexPath.row];
//    cell.indexPath = indexPath;
//    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.tableView.editing) return;
    [self performSegueWithIdentifier:@"editPresentVCIdf" sender:self];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.viewModel removeClockAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)alarmCell:(AlarmClockCell *)cell switch:(UISwitch *)switchControl didSelectedAtIndexpath:(NSIndexPath *)indexpath {
    [self.viewModel changeClockSwitchIsOn:switchControl.isOn WithModel:self.viewModel.clockData[indexpath.row]];
}

#pragma mark -- getter

- (ClockViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [ClockViewModel readData];
    }
    return _viewModel;
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
