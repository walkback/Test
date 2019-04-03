//
//  ManagerTool.h
//  SENSINGM
//
//  Created by apple on 2018/7/2.
//  Copyright © 2018年 吴志刚. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <SystemConfiguration/CaptiveNetwork.h>

@interface ManagerTool : NSObject
#pragma mark - 自定义导航栏
+(void)setNavigationBar:(UIView *)view title:(NSString *)title block:(void(^)(UIButton*))block;

#pragma mark - 自定义弹出框
+(void)alert:(NSString *)str;

#pragma mark - 动态设置label的宽高
+(CGSize)font:(UIFont *)font  str:(NSString *)str;

//计算校验和
+(NSString *)ToHexMM:(NSString *)string;
//获取今天星期几
+(NSString *)TogetWeekDayStringWithDate:(NSDate *)date;
//获取到当前时间的时分秒
+(NSString *)getCurrentTimes;
//获取到当前时间的时分
+(NSString *)getCurrentHoursAndMinutesTimes;

//获取3个数的color \或3个数的阶段数，合成
+(NSString *)recommendColorWithColor:(NSString *)color;

//返回小时和分钟
+(NSString *)timeHHMM:(NSString *)HHMM;
//获取当前的颜色的数值
+(NSString *)getCurrentColorValueWithColor:(NSString *)color;
//合并数组里的每个数据
+(NSString *)ToGetArray:(NSArray *)dataArray;
//获取每个数组中的数据
+(NSString *)toGetAllArrayDataWithArray:(NSArray *)dataArray;

//合并一下删除的id集合
+(NSString *)toGetAllSelectedIdWithAllContent:(NSString *)allContent   addID:(NSString *)addId;
//删除合并中一个id
+(NSString *)toGetAllWithAllContent:(NSString *)allContent   deleteID:(NSString *)deleteId;

//上传图片
+(void)uploadImage:(UIImage *)image  completeBlock:(void (^)(NSDictionary *dic))block;

//获取WIFI的名称
+ (NSString *)getWifiName;

//获取灯的开关
+(BOOL)toGetLightOpen:(NSString *)message;

//获取手势的开关
+(BOOL)toGetLightGesture:(NSString *)message;

//获取闹铃的开关
+(BOOL)toGetLightClock:(NSString *)message;

//开关、手势、闹钟
+(NSString *)open:(BOOL)open  gesture:(BOOL)gesture  clock:(BOOL)clock;
//连接某个网络
+(void)connectOtherWIFI:(NSString *)wifiName;
@end
