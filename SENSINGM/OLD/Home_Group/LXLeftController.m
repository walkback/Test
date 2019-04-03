
//
//  LXLeftController.m
//  LXQQSlide
//
//  Created by chenergou on 2017/11/1.
//  Copyright © 2017年 漫漫. All rights reserved.
//

#import "LXLeftController.h"
#import "MusicMode_ViewController.h"
#import "Macro.h"
#import <Masonry.h>

@interface LXLeftController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)LeftView *header;
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSArray *imageA;

@property (nonatomic, strong) UIButton *play_stop_button;
@property (nonatomic, strong) UIButton *previous_button; // 上一首
@property (nonatomic, strong) UIButton *next_button;  // 下一首
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) UILabel *schedule_label; // 进度时间
@property (nonatomic, strong) UILabel *total_label;    // 总时间
@end

@implementation LXLeftController


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"轻柔舒缓";
    }
    if (indexPath.row == 1) {
        cell.textLabel.text = @"工作热情";
    }
    if (indexPath.row == 2) {
        cell.textLabel.text = @"运动健身";
    }
    if (indexPath.row == 3) {
        cell.textLabel.text = @"静心安眠";
    }
    if (indexPath.row == 4) {
        cell.textLabel.text = @"添加歌曲";
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.typeClick) {
        self.typeClick(cell.textLabel.text,[MusicMode_ViewController class]);
    }
}
-(UITableView *)tableview{
    
    if (!_tableview) {
        _tableview =[[UITableView alloc]initWithFrame:CGRectMake(0, self.header.lx_bottom, WIDTH / 4 * 3, HEIGHT - self.header.lx_bottom) style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.showsVerticalScrollIndicator = NO;
        _tableview.showsHorizontalScrollIndicator = NO;
        _tableview.tableFooterView = [UIView new];
        _tableview.rowHeight = 44;
        _tableview.scrollEnabled = NO;
        [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self.view addSubview:self.header];
    
    [self.view addSubview:self.tableview];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 180;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [UIView new];
    
    UIImageView *imageView = [UIImageView new];
    [imageView.layer setCornerRadius:40];
    imageView.layer.masksToBounds = YES;
    imageView.image = [UIImage imageNamed:@"444"];
    [headerView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(headerView);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return HEIGHT - 400 - 64;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [UIView new];
    footerView.backgroundColor = [UIColor whiteColor];
    
    self.play_stop_button = [UIButton new];
    [self.play_stop_button setImage:[UIImage imageNamed:@"播放 (1)"] forState:UIControlStateNormal];
    [footerView addSubview:self.play_stop_button];
    [self.play_stop_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(footerView);
        make.centerY.mas_equalTo(footerView).offset(-30);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    self.previous_button = [UIButton new];
    [self.previous_button setImage:[UIImage imageNamed:@"047操作_上一首"] forState:UIControlStateNormal];
    [footerView addSubview:self.previous_button];
    [self.previous_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.play_stop_button);
        make.left.equalTo(footerView).offset(20);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    self.next_button = [UIButton new];
    [self.next_button setImage:[UIImage imageNamed:@"048操作_下一首"] forState:UIControlStateNormal];
    [footerView addSubview:self.next_button];
    [self.next_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.play_stop_button);
        make.right.equalTo(footerView).offset(-20);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    self.slider = [[UISlider alloc] init];
    [footerView addSubview:self.slider];
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.play_stop_button.mas_bottom).offset(20);
        make.left.mas_equalTo(self.previous_button);
        make.right.mas_equalTo(self.next_button);
        make.height.mas_equalTo(8);
    }];
    
    self.schedule_label = [UILabel new];
    self.schedule_label.text = @"2:44";
    self.schedule_label.font = [UIFont systemFontOfSize:14];
    [footerView addSubview:self.schedule_label];
    [self.schedule_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.slider.mas_bottom).offset(10);
        make.left.mas_equalTo(self.slider);
    }];
    
    self.total_label = [UILabel new];
    self.total_label.text = @"5:44";
    self.total_label.textAlignment = NSTextAlignmentRight;
    self.total_label.font = [UIFont systemFontOfSize:14];
    [footerView addSubview:self.total_label];
    [self.total_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.slider.mas_bottom).offset(10);
        make.left.mas_equalTo(self.schedule_label.mas_right);
        make.right.mas_equalTo(self.slider);
    }];
    
    return footerView;
}

//-(LeftView *)header{
//    if (!_header) {
//        _header =[LeftView showView];
//        _header.frame = CGRectMake(0, 0, WIDTH, 220);
//    }
//    return _header;
//}


@end
