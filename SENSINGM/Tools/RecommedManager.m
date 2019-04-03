
//
//  RecommedManager.m
//  SENSINGM
//
//  Created by apple on 2018/7/5.
//  Copyright © 2018年 吴志刚. All rights reserved.
//

#import "RecommedManager.h"
#import "ManagerTool.h"

@implementation RecommedManager
//命令1：24小时曲线导入
+(NSString *)dayTwentyHourseWithPlistArray:(NSArray *)dataArray
{
    NSString * dataNumber = [NSString  stringWithFormat:@"%lu",(unsigned long)dataArray.count];
    dataNumber = [ManagerTool recommendColorWithColor:dataNumber];
    NSString * allRecommend = @"";
    for (NSDictionary * dataDic in dataArray) {
        NSString * colorStr = [NSString  stringWithFormat:@"%@%@%@",[NSString  stringIsEmpty:dataDic[@"D1"]],[NSString  stringIsEmpty:dataDic[@"D2"]],[NSString  stringIsEmpty:dataDic[@"D3"]]];
        NSLog(@"----颜色 = %@",colorStr);
        NSString * time = [NSString  stringWithFormat:@"%@",[NSString stringIsEmpty:dataDic[@"dayTime"]]];
        time = [time stringByReplacingOccurrencesOfString:@":" withString:@""];
        time = [ManagerTool  timeHHMM:time];
        NSString * recommend = [NSString  stringWithFormat:@"%@%@",colorStr,time];
        if ([allRecommend isEqualToString:@""]) {
            allRecommend = recommend;
        }else
        {
            allRecommend = [NSString  stringWithFormat:@"%@,%@",allRecommend,recommend];
        }
    }
    
    NSString *hourseRecommend = [NSString  stringWithFormat:@"1%@=%@,ffffff%@",dataNumber,allRecommend,[ManagerTool  ToHexMM:allRecommend]];
    NSLog(@"%@", [ManagerTool  ToHexMM:allRecommend]);
    return hourseRecommend;
}
+(NSString *)dayTwentyHourseWithArray:(NSArray *)colorArray
{
    NSString * colorNumber = [NSString  stringWithFormat:@"%lu",(unsigned long)colorArray.count];
    colorNumber = [ManagerTool recommendColorWithColor:colorNumber];
    NSString * allColor = @"";
     allColor = [ManagerTool  toGetAllArrayDataWithArray:colorArray];
    NSString * time = [ManagerTool  getCurrentHoursAndMinutesTimes];
    time = [time  stringByReplacingOccurrencesOfString:@":" withString:@""];
    NSString * allRecommend = [NSString  stringWithFormat:@"%@%@",allColor,time];
    
    NSString * changeColorRecommend = [NSString  stringWithFormat:@"1%@=%@,ffffff%@",colorNumber,allRecommend,[ManagerTool  ToHexMM:allRecommend]];
    return changeColorRecommend;
}
//命令2：唤醒配置导入
+(NSString *)weakClockRecommend:(NSArray *)allTimeChangeColorArr
{
    NSString * stageNumber = [NSString  stringWithFormat:@"%lu",(unsigned long)allTimeChangeColorArr.count];
    stageNumber = [ManagerTool  recommendColorWithColor:stageNumber];
    //获取中间的阶段数数据
    NSString * centerStageRemmend = [ManagerTool toGetAllArrayDataWithArray:allTimeChangeColorArr];
    
    NSString * weakClockRecommend = [NSString  stringWithFormat:@"2%@=%@,ffffff%@",stageNumber,centerStageRemmend,[ManagerTool  ToHexMM:centerStageRemmend]];
    return weakClockRecommend;
}
/*
 time   小时和分钟
 advance  提前的时间
 song  歌曲曲目
 lould   声音大小
 colorArr  9个阶段的提前时间
 sleepTime:贪睡时间
 clockType  闹铃响的周期  0对应执行一次，1-7对应周1到周日 8对应周一到周五，9对应休息日(周六和周天)
 */
//这是命令2一个阶段数的数据
+(NSString *)weakClockWithTime:(NSString *)time  advanceTime:(NSString *)advance  songNumber:(NSString *)song  lould:(NSString *)lould   colorArray:(NSArray *)colorArr  sleepTime:(NSString *)sleep  clockType:(ClockWeeksPlayType)type
{
    NSString * clockType;
    switch (type) {
        case ClockWeeksPlayTypeJustOne:
            clockType = @"0";
            break;
        case ClockWeeksPlayTypeMonday:
            clockType = @"1";
            break;
        case ClockWeeksPlayTypeTuesday:
            clockType = @"2";
            break;
        case ClockWeeksPlayTypeWednesday:
            clockType = @"3";
            break;
        case ClockWeeksPlayTypeThursday:
            clockType = @"4";
            break;
        case ClockWeeksPlayTypeFriday:
            clockType = @"5";
            break;
        case ClockWeeksPlayTypeSaturday:
            clockType = @"6";
            break;
        case ClockWeeksPlayTypeSunday:
            clockType = @"7";
            break;
        case ClockWeeksPlayTypeWorkTime:
            clockType = @"8";
            break;
        case ClockWeeksPlayTypeSundayTime:
            clockType = @"9";
            break;
            
        default:
            break;
    }
    NSString * colorChangeStr = @"";
    for (NSString * color in colorArr) {
        if ([colorChangeStr isEqualToString:@""]) {
            colorChangeStr = color;
        }else
        {
            colorChangeStr = [NSString  stringWithFormat:@"%@%@",colorChangeStr,color];
        }
    }
    NSString * clockRecommend = [NSString  stringWithFormat:@"%@%@%@%@%@%@%@",time,advance,song,lould,colorChangeStr,sleep,clockType];
    return clockRecommend;
}
//命令3：查询灯的信息
+(NSString *)readStatus
{
    return @"3=?,ffffff";
}
//命令4：按键操作
+(NSString *)openLight:(BOOL)light  openGuster:(BOOL)guster  openClock:(BOOL)clock
{
    NSString *  power;
    NSString * gesture;
    NSString * weak;
    if (light == YES) {
        power = @"1";
    }else
    {
        power = @"0";
    }
    if (guster == YES) {
        gesture = @"1";
    }else
    {
         gesture = @"0";
    }
    
    if (clock == YES) {
        weak = @"1";
    }else
    {
        weak = @"0";
    }
    NSString * recommend = [NSString  stringWithFormat:@"%@%@%@",power,gesture,weak];
    NSString * recommendFour = [NSString  stringWithFormat:@"4=%@,ffffff%@",recommend,[ManagerTool ToHexMM:recommend]];
    return   recommendFour;
}

//命令5：设置亮度
+(NSString *)toSetLightAmountAaa:(NSString *)aaa  bbb:(NSString *)bbb   ccc:(NSString *)ccc
{
    NSString * ligth = [NSString  stringWithFormat:@"%@%@%@",aaa,bbb,ccc];
    NSString * lightRecommend = [NSString  stringWithFormat:@"5=%@,ffffff%@",ligth,[ManagerTool  ToHexMM:ligth]];
    return lightRecommend;
}

//命令6：恢复查表显示亮度
+(NSString *)backLight
{
    return @"6,ffffff";
}
//命令7：音量调节
+(NSString *)volumeControlWithVoice:(NSString *)voice
{
    NSString * recommend = [NSString  stringWithFormat:@"7=%@,ffffff",voice];
    return  recommend;
}

//命令8：播放歌曲
+(NSString *)playSongWithNumber:(NSString *)number   withType:(RrcommendSongPlayType)type
{
    NSString * recommend ;
    if (type == RrcommendSongPlayTypeSingle) {
        recommend = @"00";
    }else if (type == RrcommendSongPlayTypeSuspend)
    {
         recommend = @"04";
    }else if (type == RrcommendSongPlayTypeStop)
    {
        recommend = @"05";
    }else
    {
          recommend = @"06";
    }
    NSString * songRecommend = [NSString  stringWithFormat:@"%@%@",recommend,number];
    NSString * songPlayRecommend = [NSString  stringWithFormat:@"8=%@,ffffff%@",songRecommend,[ManagerTool  ToHexMM:songRecommend]];
    return songPlayRecommend;
}

//命令9：校准星期和时间
+(NSString *)calibration
{
    NSString *currentTime = [ManagerTool getCurrentTimes];
    NSLog(@"当前的时分秒是 = %@",currentTime);
    NSString * theCurrentTime = [currentTime  stringByReplacingOccurrencesOfString:@":" withString:@"" ];
    NSLog(@"去掉冒号的结果是 = %@",theCurrentTime);
    NSString * week  = [ManagerTool  TogetWeekDayStringWithDate:[NSDate  date]];
    NSLog(@"今天星期%@",week);
    NSString * recommend = [NSString  stringWithFormat:@"%@%@",week,theCurrentTime];
    NSString * readDataStr =[NSString  stringWithFormat:@"9=%@,ffffff%@",recommend,[ManagerTool ToHexMM:recommend]];
    return readDataStr;
}
//命令A：关闭或继续闹铃
+(NSString *)toSetClockClose:(BOOL)close
{
    NSString * bb;
    if (close == YES) {
        bb = @"00";
    }else
    {
        bb = @"01";
    }
    NSString * colockRecommend = [NSString  stringWithFormat:@"A=%@,ffffff",bb];
    return  colockRecommend;
}
//命令B：读取U盘里的歌曲总数
+(NSString *)readUSingleAllNumber
{
    return @"B=?,ffffff";
}
//命令C:读取SD卡里的歌曲总数
+(NSString *)readSDSingleAllNumber
{
     return @"C=?,ffffff";
}

//命令E：读取当前正在播放的歌曲编号
+(NSString *)readSinglingNumber
{
    return @"E=?,ffffff";
}

//装调人员:把SD卡内的MP3（按键提示音）文件下载到Flash中
+(NSString *)downLoadMP3AlertVoice
{
    return @"J=?,ffffff";
}
@end
