//
//  Sport_ViewController.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/12/14.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "Sport_ViewController.h"
#import "Data_View.h"

@interface Sport_ViewController () <UITableViewDelegate,UITableViewDataSource>
{
    Data_View *dataView;
    UITableView *tableView;
}

@property (nonatomic, strong) UISegmentedControl *segmentedControl;

@end

@implementation Sport_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray *segmentArray = @[@"日",@"周"];
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
    
    dataView = [Data_View new];
    dataView.backgroundColor = UIColor.whiteColor;
    [dataView.layer setCornerRadius:5];
    //    stepDayView.layer.masksToBounds = true; 设为true阴影效果不显示
    [self.view addSubview:dataView];
    [dataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->_segmentedControl.mas_bottom).offset(8);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
    }];
    
    dataView.layer.shadowColor = UIColor.grayColor.CGColor;
    dataView.layer.shadowOffset = CGSizeZero;
    dataView.layer.shadowOpacity = 0.8;
    
    dataView.date_lab.text = @"2018年11月22日";
    
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
        make.top.equalTo(self->dataView.mas_bottom).offset(15);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.bottom.equalTo(self.view).offset(-15);
    }];
    
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
