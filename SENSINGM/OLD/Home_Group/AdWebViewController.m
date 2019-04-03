//
//  AdWebViewController.m
//  SENSINGM
//
//  Created by apple on 2018/7/2.
//  Copyright © 2018年 吴志刚. All rights reserved.
//

#import "AdWebViewController.h"
#import <WebKit/WebKit.h>

@interface AdWebViewController ()
@property (nonatomic, strong) UILabel * contentLabel;
@property (nonatomic, strong) UIView * backGroudView;

@end

@implementation AdWebViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=RGB(240, 240, 240);
    //自定义导航栏
    [ManagerTool setNavigationBar:self.view title:@"广告页" block:^(UIButton *backButton) {
        [backButton addTarget:self action:@selector(topBackButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }];;
    [self  simpleAddWebView];
    
}
-(void)addNoDataViewWithContent:(NSString *)content
{
    UIView * backGroundView = [[UIView  alloc]initWithFrame:CGRectMake(0, 70, WIDTH, HEIGHT)];
    backGroundView.backgroundColor = RGB(241, 241, 241);
    [self.view  addSubview:backGroundView];
    self.backGroudView = backGroundView;
    UIImageView * noDataImageView = [[UIImageView  alloc]initWithFrame:CGRectMake(0, 0, 120, 120)];
    noDataImageView.center = CGPointMake(WIDTH/2, HEIGHT/2 - 90);
    noDataImageView.image = [UIImage  imageNamed:@"noData.png"];
    [backGroundView  addSubview:noDataImageView];
    UILabel * noDataLabel= [[UILabel  alloc]initWithFrame:CGRectMake(0, 0, WIDTH - 50, 20)];
    noDataLabel.center = CGPointMake(WIDTH/2, HEIGHT/2 + 10);
    noDataLabel.textAlignment = NSTextAlignmentCenter;
    noDataLabel.text = content;
    noDataLabel.textColor = RGB(83, 83, 83);
    [backGroundView  addSubview:noDataLabel];
}

- (void)simpleAddWebView {
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 75, self.view.frame.size.width, self.view.frame.size.height - 75)];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.web_link]]];
    [self.view addSubview:webView];
}

-(void)topBackButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
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
