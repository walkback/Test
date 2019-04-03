//
//  AppDelegate.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/6/14.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "AppDelegate.h"
#import "LogIn_ViewController.h"
#import "MusicMenuViewController.h"
#import "TabBar_ViewController.h"

#import <MMDrawerController.h>
#import <UIViewController+MMDrawerController.h>

#import "Home_ViewController.h"
#import "Scenes_ViewController.h"
#import "HomeViewController.h"
#import "Main_ViewController.h"

#import "AlarmClock_TableViewController.h"

#import "Macro.h"
#import "UNNotificationsManager.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <LCNetworkConfig.h>

@interface AppDelegate () <UNUserNotificationCenterDelegate>

@property (nonatomic, strong) MMDrawerController *drawerController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    //默认情况下扬声器播放
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    
    [USER_DEF removeObjectForKey:@"message"];
    [USER_DEF synchronize];
    [self setLogin_rootViewController];

    if ([[USER_DEF stringForKey:@"message"] isEqualToString:@"登录成功"]) {
        [self setTabbar_rootViewController];
    }

//    [UNNotificationsManager registerLocalNotification];
//    if (@available(iOS 10.0, *)) {
//        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
//    } else {
//        // Fallback on earlier versions
//    }
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [self replyPushNotificationAuthorization:application];
    
    LCNetworkConfig *config = [LCNetworkConfig sharedInstance];
    config.mainBaseUrl = @"http://192.168.0.252:8107/hxd-api/";
//    config.mainBaseUrl = @"http://192.168.0.64:8080/hxd-api/";
    
    return YES;
}

- (void)setLogin_rootViewController {
    LogIn_ViewController *login_vc = [[LogIn_ViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:login_vc];
    self.window.rootViewController = nav;
}

- (void)setTabbar_rootViewController {
    TabBar_ViewController *tabbar = [[TabBar_ViewController alloc] init];
     self.window.rootViewController = tabbar;
//    MusicMenuViewController *musicMenu = [[MusicMenuViewController alloc] init];
//    TabBar_ViewController *tabbar = [[TabBar_ViewController alloc] init];
//    self.drawerController = [[MMDrawerController alloc] initWithCenterViewController:tabbar leftDrawerViewController:musicMenu];
//    self.drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
//    self.drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeAll;
//
//    self.drawerController.maximumLeftDrawerWidth = WIDTH / 4 * 3;
//    self.window.rootViewController = self.drawerController;
}


#pragma mark - 申请通知权限
// 申请通知权限
- (void)replyPushNotificationAuthorization:(UIApplication *)application{
    
    if (@available(iOS 10.0, *)) {
        //iOS 10 later
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        //必须写代理，不然无法监听通知的接收与点击事件
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error && granted) {
                //用户点击允许
                NSLog(@"注册成功");
            }else{
                //用户点击不允许
                NSLog(@"注册失败");
            }
        }];
        
        // 可以通过 getNotificationSettingsWithCompletionHandler 获取权限设置
        //之前注册推送服务，用户点击了同意还是不同意，以及用户之后又做了怎样的更改我们都无从得知，现在 apple 开放了这个 API，我们可以直接获取到用户的设定信息了。注意UNNotificationSettings是只读对象哦，不能直接修改！
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            NSLog(@"========%@",settings);
        }];
    }else if (@available(iOS 8.0, *)){
        //iOS 8 - iOS 10系统
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [application registerUserNotificationSettings:settings];
    }else{
        //iOS 8.0系统以下
        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
    }
    
    //注册远端消息通知获取device token
    [application registerForRemoteNotifications];
}

//App处于前台接收通知时
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler API_AVAILABLE(ios(10.0)){
    //收到推送的请求
    UNNotificationRequest *request = notification.request;
    //收到推送的内容
    UNNotificationContent *content = request.content;
    //收到用户的基本信息
    NSDictionary *userInfo = content.userInfo;
    //收到推送消息的角标
    NSNumber *badge = content.badge;
    //收到推送消息body
    NSString *body = content.body;
    //推送消息的声音
    UNNotificationSound *sound = content.sound;
    // 推送消息的副标题
    NSString *subtitle = content.subtitle;
    // 推送消息的标题
    NSString *title = content.title;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //此处省略一万行需求代码。。。。。。
        NSLog(@"iOS10 收到远程通知:%@",userInfo);
    }else {
        // 判断为本地通知
        //此处省略一万行需求代码。。。。。。
        NSLog(@"iOS10 收到本地通知:{\\\\nbody:%@，\\\\ntitle:%@,\\\\nsubtitle:%@,\\\\nbadge：%@，\\\\nsound：%@，\\\\nuserInfo：%@\\\\n}",body,title,subtitle,badge,sound,userInfo);
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:notification.request.content.title message:notification.request.content.body delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        //        [alert show];
    }
    
    
    // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
    completionHandler(UNNotificationPresentationOptionBadge|
                      UNNotificationPresentationOptionSound|
                      UNNotificationPresentationOptionAlert);
    
}

//App通知的点击事件
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler API_AVAILABLE(ios(10.0)){
    //收到推送的请求
    UNNotificationRequest *request = response.notification.request;
    //收到推送的内容
    UNNotificationContent *content = request.content;
    //收到用户的基本信息
    NSDictionary *userInfo = content.userInfo;
    //收到推送消息的角标
    NSNumber *badge = content.badge;
    //收到推送消息body
    NSString *body = content.body;
    //推送消息的声音
    UNNotificationSound *sound = content.sound;
    // 推送消息的副标题
    NSString *subtitle = content.subtitle;
    // 推送消息的标题
    NSString *title = content.title;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSLog(@"iOS10 收到远程通知:%@",userInfo);
        //此处省略一万行需求代码。。。。。。
    }else {
        // 判断为本地通知
        //此处省略一万行需求代码。。。。。。
        NSLog(@"iOS10 收到本地通知:{\\\\nbody:%@，\\\\ntitle:%@,\\\\nsubtitle:%@,\\\\nbadge：%@，\\\\nsound：%@，\\\\nuserInfo：%@\\\\n}",body,title,subtitle,badge,sound,userInfo);
    }
    //2016-09-27 14:42:16.353978 UserNotificationsDemo[1765:800117] Warning: UNUserNotificationCenter delegate received call to -userNotificationCenter:didReceiveNotificationResponse:withCompletionHandler: but the completion handler was never called.
    completionHandler(); // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"iOS7及以上系统，收到通知:%@", userInfo);
    completionHandler(UIBackgroundFetchResultNewData);
    //此处省略一万行需求代码。。。。。。
}


#pragma mark -- UNUserNotificationCenterDelegate
/**
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler  API_AVAILABLE(ios(10.0)){
    NSLog(@"%s", __func__);
    //    [self handCommnet:notification.request.]
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didReciveNotification" object:nil userInfo:@{@"idf" : notification.request.identifier}];
    completionHandler(UNNotificationPresentationOptionAlert + UNNotificationPresentationOptionSound + UNNotificationPresentationOptionBadge);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler  API_AVAILABLE(ios(10.0)){
    NSLog(@"%s", __func__);
    [self handCommnet:response];
    completionHandler();
}
-(void)handCommnet:(UNNotificationResponse *)response
API_AVAILABLE(ios(10.0)){
    NSString *actionIdef = response.actionIdentifier;
    NSDate *date;
    if ([actionIdef isEqualToString:actionStop]) {
        return;
    }else if ([actionIdef isEqualToString:actionFiveMin]) {
        date = [NSDate dateWithTimeIntervalSinceNow:5 * 60];
    }else if ([actionIdef isEqualToString:actionHalfAnHour]) {
        date = [NSDate dateWithTimeIntervalSinceNow:30 * 60];
    }else if ([actionIdef isEqualToString:actionOneHour]) {
        date = [NSDate dateWithTimeIntervalSinceNow:60 * 60];
    }
    
    if (date) {
        [UNNotificationsManager addNotificationWithContent:response.notification.request.content identifer:response.notification.request.identifier trigger:[UNNotificationsManager triggerWithDateComponents:[UNNotificationsManager componentsWithDate:date] repeats:NO] completionHanler:^(NSError *error) {
            NSLog(@"delay11111 %@", error);
        }];
        
    }else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didReciveNotification" object:nil userInfo:@{@"idf" : response.notification.request.identifier}];
    }
}
 **/


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
    NSString *currentSSID = @"Not Found";
    CFArrayRef myArray = CNCopySupportedInterfaces();
    if (myArray != nil){
        NSDictionary* myDict = (__bridge NSDictionary *) CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
        if (myDict != nil){
            currentSSID = [myDict valueForKey:@"SSID"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"wifiname" object:currentSSID userInfo:nil];
        } else {
            currentSSID = @"<<NONE>>";
        }
    } else {
        currentSSID = @"<<NONE>>";
    }
    CFRelease(myArray);
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
