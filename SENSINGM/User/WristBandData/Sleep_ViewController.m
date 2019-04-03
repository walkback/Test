//
//  Sleep_ViewController.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/12/13.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "Sleep_ViewController.h"
#import "SleepDay_View.h"
#import "SleepWeakAndMouth_View.h"

@interface Sleep_ViewController () <UITableViewDelegate,UITableViewDataSource>
{
    SleepDay_View *sleepDayView;
    SleepWeakAndMouth_View *SMView;
    UITableView *tableView;
}

@property (nonatomic, strong) UISegmentedControl *segmentedControl;

@end

@implementation Sleep_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray *segmentArray = @[@"日",@"周",@"月"];
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentArray];
    _segmentedControl.selectedSegmentIndex = 0;
    [_segmentedControl.layer setCornerRadius:5];
    _segmentedControl.layer.masksToBounds = true;
    _segmentedControl.tintColor = Nav_BG_Color;
    _segmentedControl.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:_segmentedControl];
    [_segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(10);
        make.centerX.mas_equalTo(self.view);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.mas_equalTo(30);
    }];
    [_segmentedControl addTarget:self action:@selector(selectedIndex:) forControlEvents:UIControlEventValueChanged];
    
    if (_segmentedControl.selectedSegmentIndex == 0) {
        sleepDayView = [SleepDay_View new];
        sleepDayView.backgroundColor = UIColor.whiteColor;
        [sleepDayView.layer setCornerRadius:5];
        [self.view addSubview:sleepDayView];
        [sleepDayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self->_segmentedControl.mas_bottom).offset(8);
            make.left.equalTo(self.view).offset(15);
            make.right.equalTo(self.view).offset(-15);
        }];
        
        sleepDayView.layer.shadowColor = UIColor.grayColor.CGColor;
        sleepDayView.layer.shadowOffset = CGSizeZero;
        sleepDayView.layer.shadowOpacity = 0.8;
        
        sleepDayView.date_lab.text = @"2018年11月22日";
        sleepDayView.sleepTime_lab.text = @"5小时56分";
        sleepDayView.startTime_lab.text = @"20:55";
        sleepDayView.endTime_lab.text = @"21:08";
        
        sleepDayView.deepsleepTime_lab.text = @"3小时56分";
        sleepDayView.shallowTime_lab.text = @"3小时56分";
        sleepDayView.quality_lab.text = @"高";
    }

    tableView = [[UITableView alloc] init];
    tableView.backgroundColor = [UIColor colorWithRed:239/255.0 green:242/255.0 blue:245/255.0 alpha:1.0];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 200;
    tableView.tableFooterView = [UIView new];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->sleepDayView.mas_bottom).offset(15);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.bottom.equalTo(self.view).offset(-15);
    }];
}

- (void)selectedIndex:(UISegmentedControl *)segment {
    NSLog(@"numberOfSegments = %lu",(unsigned long)segment.selectedSegmentIndex);
    if (_segmentedControl.selectedSegmentIndex == 0) {
        sleepDayView = [SleepDay_View new];
        sleepDayView.backgroundColor = UIColor.whiteColor;
        [sleepDayView.layer setCornerRadius:5];
        [self.view addSubview:sleepDayView];
        [sleepDayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self->_segmentedControl.mas_bottom).offset(8);
            make.left.equalTo(self.view).offset(15);
            make.right.equalTo(self.view).offset(-15);
        }];
        
        sleepDayView.layer.shadowColor = UIColor.grayColor.CGColor;
        sleepDayView.layer.shadowOffset = CGSizeZero;
        sleepDayView.layer.shadowOpacity = 0.8;
        
        sleepDayView.date_lab.text = @"2018年11月22日";
        sleepDayView.sleepTime_lab.text = @"5小时56分";
        sleepDayView.startTime_lab.text = @"20:55";
        sleepDayView.endTime_lab.text = @"21:08";
        
        sleepDayView.deepsleepTime_lab.text = @"3小时56分";
        sleepDayView.shallowTime_lab.text = @"3小时56分";
        sleepDayView.quality_lab.text = @"高";
    } else if (_segmentedControl.selectedSegmentIndex == 1 ||
               _segmentedControl.selectedSegmentIndex == 2) {
        SMView = [SleepWeakAndMouth_View new];
        SMView.backgroundColor = UIColor.whiteColor;
        [SMView.layer setCornerRadius:5];
        [self.view addSubview:SMView];
        [SMView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self->_segmentedControl.mas_bottom).offset(8);
            make.left.equalTo(self.view).offset(15);
            make.right.equalTo(self.view).offset(-15);
        }];
        
        sleepDayView.deepsleepTime_lab.text = @"3小时56分";
        sleepDayView.shallowTime_lab.text = @"3小时56分";
        sleepDayView.quality_lab.text = @"高";
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * cellID = @"cellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    cell.textLabel.text = @"6:00 - 8:00";
    cell.detailTextLabel.text = @"5000步";
    cell.imageView.image = [UIImage imageNamed:@"记步"];
    
    return cell;
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
