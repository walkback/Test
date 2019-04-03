//
//  HeartRate_ViewController.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/12/13.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "HeartRate_ViewController.h"
#import "HeartRateData_View.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+GIF.h"

@interface HeartRate_ViewController () <UITableViewDelegate,UITableViewDataSource>
{
    HeartRateData_View *heartRateView;
    UITableView *tableView;
}

@end

@implementation HeartRate_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    heartRateView = [HeartRateData_View new];
    heartRateView.backgroundColor = Nav_BG_Color;
    [self.view addSubview:heartRateView];
    [heartRateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.right.equalTo(self.view);
    }];
    
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"心率动图" ofType:@"gif"];
    NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
    heartRateView.heart_imagev.image = [UIImage sd_animatedGIFWithData:imageData];
    
    heartRateView.result_lab.text = @"80";
    heartRateView.height_lat.text = @"90";
    heartRateView.low_lat.text = @"68";
    
    UIButton *detection_but = [UIButton new];
    [detection_but setTitle:@"检测" forState:UIControlStateNormal];
    [detection_but setTitleColor:TEXTCOLOR forState:UIControlStateNormal];
    detection_but.titleLabel.font = [UIFont systemFontOfSize:14];
    [detection_but setBackgroundColor:Nav_BG_Color];
    [self.view addSubview:detection_but];
    [detection_but mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    
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
        make.top.equalTo(self->heartRateView.mas_bottom).offset(15);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.bottom.equalTo(detection_but.mas_top).offset(-15);
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
