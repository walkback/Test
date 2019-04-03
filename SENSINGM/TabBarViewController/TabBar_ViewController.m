//
//  TabBar_ViewController.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/6/21.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "TabBar_ViewController.h"
#import "Home_ViewController.h"
#import "Scenes_ViewController.h"
#import "HomeViewController.h"
#import "Main_ViewController.h"
#import "AlarmClock_TableViewController.h"

@interface TabBar_ViewController () <UINavigationControllerDelegate>

@property (strong, nonatomic) UIBarButtonItem *leftButton;
@property (assign, nonatomic) NSInteger selectedRowCell;

@end

@implementation TabBar_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    Home_ViewController *home = [[Home_ViewController alloc] init];
    UINavigationController *home_nav = [[UINavigationController alloc] initWithRootViewController:home];
    home_nav.delegate = self;
    home_nav.title = @"节律";
    home_nav.tabBarItem.image = [UIImage  imageNamed:@"first_page.png"];
    home_nav.tabBarItem.selectedImage = [UIImage  imageNamed:@"first_select.png"];
    
    Scenes_ViewController *scenes = [[Scenes_ViewController alloc] init];
    UINavigationController *scenes_nav = [[UINavigationController alloc] initWithRootViewController:scenes];
    scenes_nav.delegate = self;
    scenes_nav.title = @"场景";
    scenes_nav.tabBarItem.image = [UIImage  imageNamed:@"screen_page.png"];
    scenes_nav.tabBarItem.selectedImage = [UIImage  imageNamed:@"screen_select.png"];
    
    AlarmClock_TableViewController *alarmClock = [[AlarmClock_TableViewController alloc] init];
    UINavigationController *clock_nav = [[UINavigationController alloc] initWithRootViewController:alarmClock];
    clock_nav.delegate = self;
    clock_nav.title = @"设备";
    clock_nav.tabBarItem.image = [UIImage  imageNamed:@"clock_page.png"];
    clock_nav.tabBarItem.selectedImage = [UIImage  imageNamed:@"clock_select.png"];
    
    Main_ViewController *main = [[Main_ViewController alloc] init];
    UINavigationController *main_nav = [[UINavigationController alloc] initWithRootViewController:main];
    main_nav.delegate = self;
    main_nav.title = @"我的";
    main_nav.tabBarItem.image = [UIImage  imageNamed:@"mine_page.png"];
    main_nav.tabBarItem.selectedImage = [UIImage  imageNamed:@"mine_select.png"];
    
    self.viewControllers = @[home_nav,scenes_nav,clock_nav,main_nav];
}

#pragma mark -----UINavigationControllerDelegate代理方法------
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([viewController.navigationController respondsToSelector:@selector(pushViewController:animated:)] && viewController) {
        if (navigationController.viewControllers.count > 1) {
            [self hidenBar];
        } else {
            [self showBar];
        }
    } else {
        [self showBar];
    }
}

-(void)hidenBar{
    self.tabBar.hidden=YES;
}

-(void)showBar{
    self.tabBar.hidden=NO;
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
