
//
//  ManagerTool.m
//  SENSINGM
//
//  Created by apple on 2018/7/2.
//  Copyright © 2018年 吴志刚. All rights reserved.
//

#import "ManagerTool.h"
#import <AFNetworking.h>

@implementation ManagerTool
#pragma mark - 自定义导航栏
+(void)setNavigationBar:(UIView *)view title:(NSString *)title block:(void(^)(UIButton*))block{
    UIView *navigationBar=[[UIView alloc]initWithFrame:CGRectMake(0, 0,WIDTH, 64)];
    navigationBar.backgroundColor=[UIColor  whiteColor];
    navigationBar.tag = 10064;
    [view addSubview:navigationBar];
    
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame=CGRectMake(20, 20, 44, 44);
    [leftBtn setImage:[UIImage imageNamed:@"top_back.png"] forState:UIControlStateNormal];
    leftBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 0, 15, 30);
    [navigationBar addSubview:leftBtn];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-230)/2,CGRectGetMinY(leftBtn.frame)+8, 230, 20)];
    titleLabel.text=title;
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.font=[UIFont systemFontOfSize:16];
    [navigationBar addSubview:titleLabel];
    block(leftBtn);
    
}


#pragma mark - 自定义弹出框
+(void)alert:(NSString *)str{
    
    float width=[self font:[UIFont  systemFontOfSize:14] str:str].width;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    UILabel *alertLabel=[[UILabel alloc]init];
    alertLabel.center=CGPointMake(window.center.x,window.center.y);
    alertLabel.bounds=CGRectMake(0, 0,width+20, 40);
    alertLabel.backgroundColor=RGB(38, 38, 38);
    
    alertLabel.textAlignment=NSTextAlignmentCenter;
    alertLabel.font=[UIFont  systemFontOfSize:14];
    alertLabel.text=str;
    alertLabel.textColor=[UIColor whiteColor];
    alertLabel.layer.cornerRadius=5;
    alertLabel.layer.masksToBounds=YES;
    
    [window addSubview:alertLabel];
    alertLabel.alpha=1;
    [UIView beginAnimations:nil context:nil];
    //设定动画持续时间
    [UIView setAnimationDuration:3];
    //动画的内容
    alertLabel.alpha=0;
    //动画结束
    [UIView commitAnimations];
    
    
}

#pragma mark - 动态设置label的宽高
+(CGSize)font:(UIFont *)font  str:(NSString *)str{
    CGSize size =CGSizeMake(300,60);
    
    // label可设置的最大高度和宽度
    //    CGSize size = CGSizeMake(300.f, MAXFLOAT);
    
    //    获取当前文本的属性
    
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
    
    //ios7方法，获取文本需要的size，限制宽度
    
    CGSize  actualsize =[str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic context:nil].size;
    return actualsize;
    
}

//计算校验和
+(NSString *)ToHexMM:(NSString *)string
{
    
    NSString * theString = [string  stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    int  allNumber = 0;
    for (int i = 0; i < theString.length  ; i++) {
        unichar ch = [theString characterAtIndex:i];
        int  index = [[NSString  stringWithFormat:@"%hu",ch] intValue];
        allNumber += index;
    }
    int  tmpid = allNumber;
    NSString *nLetterValue;
    NSString *str =@"";
    long long int ttmpig;
    for (int i = 0; i<9; i++) {
        ttmpig=tmpid%16;
        tmpid=tmpid/16;
        switch (ttmpig)
        {
            case 10:
                nLetterValue =@"A";
                nLetterValue = @":";
                break;
            case 11:
                nLetterValue =@"B";
                nLetterValue = @";";
                break;
            case 12:
                nLetterValue =@"C";
                nLetterValue =@"<";
                break;
            case 13:
                nLetterValue =@"D";
                nLetterValue =@"=";
                break;
            case 14:
                nLetterValue =@"E";
                nLetterValue = @">";
                break;
            case 15:
                nLetterValue =@"F";
                nLetterValue = @"?";
                break;
            default:
                nLetterValue=[[NSString alloc]initWithFormat:@"%i",ttmpig];
                
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;
        }
        
    }
    //只要后两位
    str = [str substringFromIndex:str.length - 2];
    return str;
}


//获取今天星期几
+(NSString *)TogetWeekDayStringWithDate:(NSDate *)date
{
    NSCalendar * calendar = [[NSCalendar  alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents * comps = [calendar  components:NSCalendarUnitWeekday fromDate:date];
    //1是周日，2是周一，3.以此类推
    int  weekDay= [comps weekday];
    NSString * weekStr;
    switch (weekDay) {
        case 1:
            weekStr = @"7";
            break;
        case 2:
            weekStr = @"1";
            break;
        case 3:
            weekStr = @"2";
            break;
        case 4:
            weekStr = @"3";
            break;
        case 5:
            weekStr = @"4";
            break;
        case 6:
            weekStr = @"5";
            break;
        case 7:
            weekStr = @"6";
            break;
            
        default:
            break;
    }
    return weekStr;
}
//获取到当前时间的时分秒
+(NSString *)getCurrentTimes
{
    NSDateFormatter * formatter = [[NSDateFormatter  alloc]init];
    [formatter  setDateFormat:@"HH:mm:ss"];
    NSDate * dateNow = [NSDate  date];
    NSString * currentTimeString = [formatter  stringFromDate:dateNow];
    return currentTimeString;
}

//获取到当前时间的时分
+(NSString *)getCurrentHoursAndMinutesTimes
{
    NSDateFormatter * formatter = [[NSDateFormatter  alloc]init];
    [formatter  setDateFormat:@"HH:mm"];
    NSDate * dateNow = [NSDate  date];
    NSString * currentTimeString = [formatter  stringFromDate:dateNow];
    return currentTimeString;
}

//获取3个数的color，合成
+(NSString *)recommendColorWithColor:(NSString *)color
{
    if (color.length == 2) {
        color = [NSString  stringWithFormat:@"0%@",color];
    }
    if (color.length == 1) {
         color = [NSString  stringWithFormat:@"00%@",color];
    }
    return color;
}
//返回小时和分钟
+(NSString *)timeHHMM:(NSString *)HHMM
{
    if (HHMM.length == 3) {
        HHMM = [NSString  stringWithFormat:@"0%@",HHMM];
    }
    return HHMM;
}

//获取当前的颜色的数值
+(NSString *)getCurrentColorValueWithColor:(NSString *)color
{
    if ([color hasPrefix:@"0"]) {
        color = [color  substringWithRange:NSMakeRange(1, 2)];
    }
    if ([color hasPrefix:@"00"]) {
        color = [color  substringWithRange:NSMakeRange(2, 1)];
    }
    return color;
}
//合并数组里的每个数据
+(NSString *)ToGetArray:(NSArray *)dataArray
{
    NSString * allDataStr =@"";
    for (NSString * dataStr in dataArray) {
        if ([allDataStr isEqualToString:@""]) {
            allDataStr = dataStr;
        }else
        {
            allDataStr = [NSString  stringWithFormat:@"%@%@",allDataStr,dataStr];
        }
    }
    return allDataStr;
}
//获取每个数组中的数据
+(NSString *)toGetAllArrayDataWithArray:(NSArray *)dataArray
{
    NSString * allDataStr =@"";
    for (NSString * dataStr in dataArray) {
        if ([allDataStr isEqualToString:@""]) {
            allDataStr = dataStr;
        }else
        {
            allDataStr = [NSString  stringWithFormat:@"%@,%@",allDataStr,dataStr];
        }
    }
    return allDataStr;
}

//合并一下删除的id集合
+(NSString *)toGetAllSelectedIdWithAllContent:(NSString *)allContent   addID:(NSString *)addId
{
    if ([allContent  isEqualToString:@""]) {
       allContent = addId;
    }else
    {
        
        //12包含1
        if ([allContent isEqualToString:addId]) {
            //只有一个数且还相同的时候
            allContent = addId;
        }else
        {//不只是有一个数,根据逗号可以分割
            NSArray * everyArray = [ allContent  componentsSeparatedByString:@","];
            for (NSString * everyStr in everyArray) {
                if ([everyStr isEqualToString:addId]) {
                    return allContent;
                }
            }
                allContent = [NSString  stringWithFormat:@"%@,%@", allContent ,addId];
        }

    }
    return allContent;
}
//删除合并中一个id
+(NSString *)toGetAllWithAllContent:(NSString *)allContent   deleteID:(NSString *)deleteId
{
    if ([allContent containsString:deleteId]) {
        //进行分割
        NSArray * everyArray = [ allContent  componentsSeparatedByString:@","];
        NSString * deleteContent = @"";
        for (NSString * everyStr in everyArray) {
            NSLog(@"----输出一下 = %@",everyStr);
            if (![everyStr isEqualToString:deleteId]) {
                if ([deleteContent isEqualToString:@""]) {
                    deleteContent = everyStr;
                }else
                {
                    deleteContent = [NSString  stringWithFormat:@"%@,%@",deleteContent,everyStr];
                }
            }
        }
        return deleteContent;
    }
    return allContent;
}


//上传图片
+(void)uploadImage:(UIImage *)image  completeBlock:(void (^)(NSDictionary *dic))block
{
    NSData *data = UIImageJPEGRepresentation(image, 0.5);

    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:RAB(@"add_file") parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        [formData appendPartWithFileURL:[NSURL fileURLWithPath:@"file://path/to/image.jpg"] name:@"file" fileName:@"filename.jpg" mimeType:@"image/jpeg" error:nil];
        [formData appendPartWithFileData:data name:@"file" fileName:@"file.jpg" mimeType:@"image/jpg"];
    } error:nil];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      // This is not called back on the main queue.
                      // You are responsible for dispatching to the main queue for UI updates
                      dispatch_async(dispatch_get_main_queue(), ^{
//                          [progressView setProgress:uploadProgress.fractionCompleted];
                      });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if (error) {
                          NSLog(@"Error: %@", error);
                      } else {
                          NSLog(@"%@ %@", response, responseObject);
                          NSDictionary *dic = responseObject;
                          if (dic) {
                              block(dic);
                          }
                      }
                  }];
    
    [uploadTask resume];
}
//获取WIFI的名称
+ (NSString *)getWifiName
{
    NSString *wifiName = nil;
    NSDictionary *networkInfo = (NSDictionary*)[ManagerTool fetchSSIDInfo];
    
    wifiName = [networkInfo objectForKey:(__bridge NSString*)kCNNetworkInfoKeySSID];
    return wifiName;
}
+ (id)fetchSSIDInfo {
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        
        if (info && [info count]) { break; }
    }
    return info;
}
//获取灯的开关
+(BOOL)toGetLightOpen:(NSString *)message
{
    if (![message hasPrefix:@"DMX3"]) {
        return NO;
    }
    if ([message  containsString:@"DMX3ERR"]) {
        return NO;
    }
    NSString * lightNumber = [message substringWithRange:NSMakeRange(22, 1)];
    if ([lightNumber isEqualToString:@"0"]) {
        return NO;
    }else
    {
        return YES;
    }
}

//获取手势的开关
+(BOOL)toGetLightGesture:(NSString *)message
{
    if (![message hasPrefix:@"DMX3"]) {
        return NO;
    }
    if ([message  containsString:@"DMX3ERR"]) {
        return NO;
    }
    NSString * gestureNumber = [message substringWithRange:NSMakeRange(23, 1)];
    if ([gestureNumber isEqualToString:@"0"]) {
        return NO;
    }else
    {
        return YES;
    }
}

//获取闹铃的开关
+(BOOL)toGetLightClock:(NSString *)message
{
    if (![message hasPrefix:@"DMX3"]) {
        return NO;
    }
    if ([message  containsString:@"DMX3ERR"]) {
        return NO;
    }
    NSString * clockNumber = [message substringWithRange:NSMakeRange(24, 1)];

    if ([clockNumber isEqualToString:@"0"]) {
        return NO;
    }else
    {
        return YES;
    }

}

+(NSString *)open:(BOOL)open  gesture:(BOOL)gesture  clock:(BOOL)clock
{
    NSString * statusStr = @"";
    NSString * openStr = @"";
    NSString * gestureStr = @"";
    NSString * clockStr = @"";
    if (open == YES) {
        openStr = @"唤醒灯开,";
    }else
    {
        openStr = @"唤醒灯关,";

    }
    if (gesture == YES) {
        gestureStr = @"手势开,";
    }else
    {
        gestureStr = @"手势关,";

    }
    if (clock == YES) {
        clockStr = @"闹钟开";
    }else
    {
        clockStr = @"闹钟关";
        
    }

    statusStr = [NSString  stringWithFormat:@"%@%@%@",openStr,gestureStr,clockStr];
    return statusStr;
}
//连接某个网络
+(void)connectOtherWIFI:(NSString *)wifiName
{
    NSString *currentSSID = @"Not Found";
    CFArrayRef myArray = CNCopySupportedInterfaces();
    if (myArray != nil){
        NSDictionary* myDict = (__bridge NSDictionary *) CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
        if (myDict != nil){
            currentSSID = [myDict valueForKey:@"SSID"];
            [[NSNotificationCenter defaultCenter] postNotificationName:wifiName object:currentSSID userInfo:nil];
        } else {
            currentSSID = @"<<NONE>>";
        }
    } else {
        currentSSID = @"<<NONE>>";
    }
    CFRelease(myArray);
}


@end
