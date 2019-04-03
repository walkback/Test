//
//  ChestHangingHome_PageController.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/12/14.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "ChestHangingHome_PageController.h"
#import "Illumination_ViewController.h"
#import "UV_ViewController.h"
#import "Physiological_ViewController.h"
#import "Sport_ViewController.h"

@interface ChestHangingHome_PageController ()

@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation ChestHangingHome_PageController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = true;
}

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"光照",@"UV",@"生理",@"运动"];
    }
    return _titleArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = Nav_BG_Color;
    self.scrollView.backgroundColor = UIColor.whiteColor;
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.menuView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    UIButton *back_but = [UIButton new];
    [back_but setBackgroundImage:[UIImage imageNamed:@"退出"] forState:UIControlStateNormal];
    [self.view addSubview:back_but];
    [back_but mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.centerY.mas_equalTo(self.menuView);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    
    [[back_but rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self.navigationController popViewControllerAnimated:true];
    }];
}


- (instancetype)init {
    if (self = [super init]) {
        self.titleSizeNormal = 16;
        self.titleSizeSelected = 18;
        self.titleColorNormal = TEXTCOLOR;
        self.titleColorSelected = TEXTCOLOR;
        self.progressColor = TEXTCOLOR;
        self.progressWidth = (WIDTH - 192) / 4;
        self.progressHeight = 3;
        self.menuViewStyle = WMMenuViewStyleLine;
        self.menuItemWidth = (WIDTH - 192) / self.titleArray.count;
        self.menuView.layoutMode = WMMenuViewLayoutModeCenter;
        
    }
    return self;
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.titleArray.count;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.titleArray[index];
}

- (__kindof UIViewController * _Nonnull)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    switch (index) {
        case 0:{
            Illumination_ViewController *illumination = [[Illumination_ViewController alloc] init];
            illumination.title = @"1";
            return illumination;
        }
            break;
        case 1: {
            UV_ViewController *uv = [[UV_ViewController alloc] init];
            uv.title = @"2";
            return uv;
        }
            break;
        case 2: {
            Physiological_ViewController *physiological = [[Physiological_ViewController alloc] init];
            physiological.title = @"3";
            return physiological;
        }
        default: {
            Sport_ViewController *sport = [[Sport_ViewController alloc] init];
            sport.title = @"1";
            return sport;
        }
            break;
    }
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    menuView.backgroundColor = Nav_BG_Color;
    return CGRectMake(96, IS_IPhoneX ? 44 : 20, WIDTH - 192, 40);
}


- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)content {
    content.backgroundColor = [UIColor colorWithRed:239/255.0 green:242/255.0 blue:245/255.0 alpha:1.0];
    return CGRectMake(0, IS_IPhoneX ? 88 : 64, WIDTH, HEIGHT - (IS_IPhoneX ? 88 : 64));
}


@end
