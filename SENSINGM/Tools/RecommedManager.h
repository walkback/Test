//
//  RecommedManager.h
//  SENSINGM
//
//  Created by apple on 2018/7/5.
//  Copyright © 2018年 吴志刚. All rights reserved.
//命令管理工具

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, RrcommendSongPlayType)
{
    RrcommendSongPlayTypeSingle = 0,//单曲不循环
    RrcommendSongPlayTypeSuspend,  //暂停播放
    RrcommendSongPlayTypeStop,   //停止播放
    RrcommendSongPlayTypeContinue    //继续播放
};

typedef NS_ENUM(NSInteger, ClockWeeksPlayType)
{
    ClockWeeksPlayTypeJustOne = 0,//执行一次
    ClockWeeksPlayTypeMonday,  //每一天，周一到周五  周一
    ClockWeeksPlayTypeTuesday,  //周二
    ClockWeeksPlayTypeWednesday, //周三
    ClockWeeksPlayTypeThursday, //周四
    ClockWeeksPlayTypeFriday, //周五
    ClockWeeksPlayTypeSaturday, //周六
    ClockWeeksPlayTypeSunday, //周日
    ClockWeeksPlayTypeWorkTime,   //工作日
    ClockWeeksPlayTypeSundayTime    //周六和周日
};
@interface RecommedManager : NSObject

//命令1：24小时曲线导入
//导入plist的数据
+(NSString *)dayTwentyHourseWithPlistArray:(NSArray *)dataArray;

//导入color的数组
+(NSString *)dayTwentyHourseWithArray:(NSArray *)colorArray;
//命令2：唤醒配置导入
+(NSString *)weakClockRecommend:(NSArray *)allTimeChangeColorArr;
/*
 time   小时和分钟
 advance  提前的时间
 song  歌曲曲目
 lould   声音大小
 colorArr  9个阶段的提前时间
 sleepTime:贪睡时间
 clockType  闹铃响的周期  0对应执行一次，1-7对应周1到周日 8对应周一到周五，9对应休息日(周六和周天)
 */
+(NSString *)weakClockWithTime:(NSString *)time  advanceTime:(NSString *)advance  songNumber:(NSString *)song  lould:(NSString *)lould   colorArray:(NSArray *)colorArr  sleepTime:(NSString *)sleep  clockType:(ClockWeeksPlayType)type;
//命令3：查询灯的信息
+(NSString *)readStatus;

//命令4：按键操作
+(NSString *)openLight:(BOOL)light  openGuster:(BOOL)guster  openClock:(BOOL)clock;

//命令5：设置亮度
+(NSString *)toSetLightAmountAaa:(NSString *)aaa  bbb:(NSString *)bbb   ccc:(NSString *)ccc;

//命令6：恢复查表显示亮度
+(NSString *)backLight;

//命令7：音量调节
+(NSString *)volumeControlWithVoice:(NSString *)voice;

//命令8：播放歌曲
+(NSString *)playSongWithNumber:(NSString *)number   withType:(RrcommendSongPlayType)type;

//命令9：校准星期和时间
+(NSString *)calibration;

//命令A：关闭或继续闹铃
+(NSString *)toSetClockClose:(BOOL)close;

//命令B：读取U盘里的歌曲总数
+(NSString *)readUSingleAllNumber;

//命令C:读取SD卡里的歌曲总数
+(NSString *)readSDSingleAllNumber;

//命令E：读取当前正在播放的歌曲编号
+(NSString *)readSinglingNumber;

//装调人员:把SD卡内的MP3（按键提示音）文件下载到Flash中
+(NSString *)downLoadMP3AlertVoice;
@end
