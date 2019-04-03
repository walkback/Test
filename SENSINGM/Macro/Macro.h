//
//  Macro.h
//  SENSINGM
//
//  Created by 吴志刚 on 2018/6/14.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#ifndef Macro_h
#define Macro_h

#import "ReactiveObjC.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
#define Line_Color [UIColor colorWithRed:235/255.0 green:235/255.0  blue:235/255.0  alpha:1]
#define Default_Blue_Color [UIColor colorWithRed:255/255.0 green:203/255.0 blue:6/255.0 alpha:0.5]
#define TEXTCOLOR [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]

#define NaviH (HEIGHT == 812 ? 88 : 64) // 812是iPhoneX的高度
#define scrollViewHeight (screenH-NaviH-44)

#define USER_DEF [NSUserDefaults standardUserDefaults]
#define iOS10 ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0)
#define TMI_Id [USER_DEF stringForKey:@"tmiId"]



#define SafeAreaTopHeight (kWJScreenHeight == 812.0 ? 88 : 64)
#define KIsiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define port1  5000
#define SCREEN_WIDTH       ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGT      ([UIScreen mainScreen].bounds.size.height)
#define RGB(R,G,B) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1]
#define RAB(str)  [NSString stringWithFormat:@"http://192.168.0.252:8107/hxd-api/%@?key=z1zkey&code=MTJCNDgyOTIxOTk4QjUzQzM2QTlFN0ZFMzY0MDNEMjQ=&requestCode=-1",str]

#define IS_IPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define RootUrl  @"http://192.168.0.252:8107/"
#define BLUE_COLOR RGB(35,112,210)
#define BGCOLOR RGB(237, 239, 239)

#define Nav_BG_Color [UIColor colorWithRed:255/255.0 green:203/255.0 blue:6/255.0 alpha:1.0]

#define host1 @"192.168.2.3"
#define port1  5000

// 内网
#define PHOTO_URL(str) [NSString stringWithFormat:@"http://192.168.0.252:8107%@",str]
#define BASE_URL(str) [NSString stringWithFormat:@"http://192.168.0.252:8107/hxd-api/%@?key=z1zkey&code=MTJCNDgyOTIxOTk4QjUzQzM2QTlFN0ZFMzY0MDNEMjQ=&requestCode=-1",str]

#endif /* Macro_h */
