//
//  UserHomePage_ViewController.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/12/11.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "UserHomePage_ViewController.h"
#import "UserDevice_ViewController.h"
#import "UserManagement_ViewController.h"

@interface UserHomePage_ViewController () <SPPageMenuDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) SPPageMenu *pageMenu;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *pageMenuItem_array;
@property (nonatomic, strong) NSMutableArray *myChildViewControllers;

@property (nonatomic, strong) UIButton *add_user_but;

@end

@implementation UserHomePage_ViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = false;
    
    [self.navigationController.navigationBar setBackgroundImage:[self createImageWithColor:Nav_BG_Color] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"节律";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor],NSFontAttributeName: [UIFont systemFontOfSize:17]}];
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    UIButton *add_device_but = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [add_device_but setBackgroundImage:[UIImage imageNamed:@"添加设备"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:add_device_but];
    
    [self setPageMenu];
}

- (void)setPageMenu{
    _add_user_but = [UIButton new];
    [_add_user_but.layer setBorderWidth:0.5];
    [_add_user_but.layer setBorderColor:UIColor.lightGrayColor.CGColor];
    [self.view addSubview:_add_user_but];
    [_add_user_but mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(47, 44));
    }];
    
    [[_add_user_but rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        UIBarButtonItem * backButtonItem = [[UIBarButtonItem alloc] init];
        backButtonItem.title = @"";
        self.navigationItem.backBarButtonItem = backButtonItem;
        UserManagement_ViewController *userman = [[UserManagement_ViewController alloc] init];
        userman.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:userman animated:true];
    }];
    
    UIImageView *icon_imagev = [UIImageView new];
    icon_imagev.image = [UIImage imageNamed:@"添加用户"];
    [_add_user_but addSubview:icon_imagev];
    [icon_imagev mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self->_add_user_but);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    
    self.pageMenuItem_array = @[@"爸爸",@"妈妈",@"儿子",@"孙子"];
    _pageMenu = [[SPPageMenu alloc] initWithFrame:CGRectZero trackerStyle:SPPageMenuTrackerStyleLine];
    _pageMenu.delegate = self;
    _pageMenu.selectedItemTitleColor = Nav_BG_Color;
    _pageMenu.tracker.backgroundColor = Nav_BG_Color;
    [_pageMenu setItems:self.pageMenuItem_array selectedItemIndex:0];
    _pageMenu.bridgeScrollView = self.scrollView;
    [self.view addSubview:_pageMenu];
    [_pageMenu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view).offset(-47);
        make.height.mas_equalTo(44);
    }];
    
    
    UserDevice_ViewController *userDevice = [[UserDevice_ViewController alloc] init];
    [self addChildViewController:userDevice];
    [self.view addSubview:userDevice.view];
    [userDevice endAppearanceTransition];
    [userDevice didMoveToParentViewController:self];
    [userDevice.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(44);
        make.left.right.bottom.equalTo(self.view);
    }];
}


- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NaviH + 44, WIDTH, HEIGHT)];
        _scrollView.backgroundColor = UIColor.redColor;
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return  _scrollView;
}

- (NSMutableArray *)myChildViewControllers {
    if (!_myChildViewControllers) {
        _myChildViewControllers = [NSMutableArray array];
        
    }
    return _myChildViewControllers;
}


- (UIImage*)createImageWithColor: (UIColor*) color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
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
