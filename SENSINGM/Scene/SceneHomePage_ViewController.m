//
//  SceneHomePage_ViewController.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/12/11.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "SceneHomePage_ViewController.h"
#import "SystemScenario_ViewController.h"
#import "CustomScene_ViewController.h"


@interface SceneHomePage_ViewController ()

@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation SceneHomePage_ViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = true;
}

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"系统场景",@"自定义场景"];
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
}

- (instancetype)init {
    if (self = [super init]) {
        self.titleSizeNormal = 16;
        self.titleSizeSelected = 18;
        self.titleColorNormal = TEXTCOLOR;
        self.titleColorSelected = TEXTCOLOR;
        self.progressColor = TEXTCOLOR;
        self.progressWidth = (WIDTH - 180) / 2;
        self.progressHeight = 3;
        self.menuViewStyle = WMMenuViewStyleDefault;
        self.menuItemWidth = (WIDTH - 180) / self.titleArray.count;
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
            SystemScenario_ViewController *systemScenario = [[SystemScenario_ViewController alloc] init];
            systemScenario.title = @"1";
            return systemScenario;
        }
            break;
        case 1: {
            CustomScene_ViewController *customScene = [[CustomScene_ViewController alloc] init];
            customScene.title = @"2";
            return customScene;
        }
            break;
        default: {
            SystemScenario_ViewController *systemScenario = [[SystemScenario_ViewController alloc] init];
            systemScenario.title = @"1";
            return systemScenario;
        }
            break;
    }
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    menuView.backgroundColor = Nav_BG_Color;
    return CGRectMake(90, IS_IPhoneX ? 44 : 20, WIDTH - 180, 40);
}


- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)content {
    content.backgroundColor = [UIColor colorWithRed:239/255.0 green:242/255.0 blue:245/255.0 alpha:1.0];
    return CGRectMake(0, IS_IPhoneX ? 88 : 64, WIDTH, HEIGHT - (IS_IPhoneX ? 88 : 64));
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
