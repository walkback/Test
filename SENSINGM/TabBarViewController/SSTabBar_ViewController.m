//
//  SSTabBar_ViewController.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/12/11.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "SSTabBar_ViewController.h"

#import "UserHomePage_ViewController.h"
#import "SceneHomePage_ViewController.h"
#import "DeviceHomePage_ViewController.h"
#import "MineHomePage_ViewController.h"

@interface SSTabBar_ViewController ()

@end

@implementation SSTabBar_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    UserHomePage_ViewController *user = [[UserHomePage_ViewController alloc] init];
    UINavigationController *user_nav = [[UINavigationController alloc] initWithRootViewController:user];
    user_nav.title = @"节律";
    [user_nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName: [UIFont systemFontOfSize:17]}];
    UIImage *user_image = [UIImage imageNamed:@"首页 拷贝"];
    user_image = [user_image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    user_nav.tabBarItem.image = user_image;
    UIImage *user_selected_image = [UIImage imageNamed:@"点击首页"];
    user_selected_image = [user_selected_image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    user_nav.tabBarItem.selectedImage = user_selected_image;
    
    SceneHomePage_ViewController *scene = [[SceneHomePage_ViewController alloc] init];
    UINavigationController *scene_nav = [[UINavigationController alloc] initWithRootViewController:scene];
    scene_nav.title = @"场景";
    [scene_nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName: [UIFont systemFontOfSize:17]}];
    UIImage *scene_image = [UIImage imageNamed:@"首页 拷贝"];
    scene_image = [scene_image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    user_nav.tabBarItem.image = scene_image;
    UIImage *scene_selected_image = [UIImage imageNamed:@"点击首页"];
    scene_selected_image = [scene_selected_image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    user_nav.tabBarItem.selectedImage = scene_selected_image;

    DeviceHomePage_ViewController *device = [[DeviceHomePage_ViewController alloc] init];
    UINavigationController *device_nav = [[UINavigationController alloc] initWithRootViewController:device];
    device_nav.title = @"设备";
    [device_nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName: [UIFont systemFontOfSize:17]}];
    UIImage *device_image = [UIImage imageNamed:@"首页 拷贝"];
    device_image = [device_image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    user_nav.tabBarItem.image = device_image;
    UIImage *device_selected_image = [UIImage imageNamed:@"点击首页"];
    device_selected_image = [device_selected_image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    device_nav.tabBarItem.selectedImage = device_selected_image;

    MineHomePage_ViewController *mine = [[MineHomePage_ViewController alloc] init];
    UINavigationController *mine_nav = [[UINavigationController alloc] initWithRootViewController:mine];
    mine_nav.title = @"我的";
    [mine_nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName: [UIFont systemFontOfSize:17]}];
    UIImage *mine_image = [UIImage imageNamed:@"首页 拷贝"];
    mine_image = [mine_image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mine_nav.tabBarItem.image = mine_image;
    UIImage *mine_selected_image = [UIImage imageNamed:@"点击首页"];
    mine_selected_image = [mine_selected_image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mine_nav.tabBarItem.selectedImage = mine_selected_image;

    self.viewControllers = @[user_nav,scene_nav,device_nav,mine_nav];
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
