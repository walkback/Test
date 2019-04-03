//
//  Protocol_ViewController.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/12/11.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "Protocol_ViewController.h"

@interface Protocol_ViewController ()

@end

@implementation Protocol_ViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = false;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UILabel *title_lab = [[UILabel alloc] init];
    title_lab.text = @"用户服务条款";
    title_lab.textColor = TEXTCOLOR;
    [title_lab setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
    self.navigationItem.titleView = title_lab;
    
    UIButton *back_but = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [back_but setBackgroundImage:[UIImage imageNamed:@"退出"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:back_but];
    [[back_but rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self.navigationController popViewControllerAnimated:true];
    }];
    
    self.view.backgroundColor = UIColor.whiteColor;
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
