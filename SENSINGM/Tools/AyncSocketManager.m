//
//  AyncSocketManager.m
//  UDPDemo
//
//  Created by apple on 2018/7/13.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "AyncSocketManager.h"

@interface AyncSocketManager ( )<GCDAsyncSocketDelegate>
@property (nonatomic, strong) GCDAsyncSocket * asyncSocket;
@property (nonatomic, strong) NSString * recommend;
@property (nonatomic, strong)  ReadReceiveData  receiveData;
@end

static AyncSocketManager *myAsyncSocketManage = nil;

@implementation AyncSocketManager
+(instancetype)shareAyncManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        myAsyncSocketManage = [[AyncSocketManager alloc]init];
    });
    return myAsyncSocketManage;
}
-(void)createClientUdpSocket{
    //创建socket
    [self.asyncSocket disconnect];
    NSError * err = nil;
    self.asyncSocket = [[GCDAsyncSocket  alloc]initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    if (![self.asyncSocket connectToHost:@"192.168.2.3" onPort:5000 error:&err]) {
        NSLog(@"error");
    }else
    {
        NSData * xmlData =  [@"DMX" dataUsingEncoding:NSUTF8StringEncoding];
        //发送数据
        [self.asyncSocket writeData:xmlData withTimeout:-1 tag:1];
    }
    [self.asyncSocket   readDataWithTimeout:-1 tag:0];
}

//-(void)postRecommed:(NSString *)commend;{
//}
-(void)postRecommed:(NSString *)commend  result:(ReadReceiveData)receiveData
{
    _recommend = [NSString stringIsEmpty:commend];
    [myAsyncSocketManage createClientUdpSocket];
    self.receiveData = receiveData;

}

#pragma mark----代理方法-----
#pragma mark -----连接成功回调-----
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"socket连接成功");

}
//2.接受数据
//接收Socket数据,在onSocket重载函数，有如定义采用是专门用来处理SOCKET的接收数据的
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString *message =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"message:%@",message);

    if ([message isEqualToString:@"RDY"]) {
        [self.asyncSocket writeData:[_recommend dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:1];
        [self.asyncSocket  readDataWithTimeout:-1 tag:0];
    }else if ([message  hasPrefix:@"DMX3"])
    {
        NSString * lightNumber = [message substringWithRange:NSMakeRange(22, 1)];
        NSString * gestureNumber = [message substringWithRange:NSMakeRange(23, 1)];
        NSString * clockNumber = [message substringWithRange:NSMakeRange(24, 1)];
        NSLog(@"---输出此时灯的开关：%@ 手势的开关= %@ 闹钟的开关= %@",lightNumber,gestureNumber,clockNumber);
        
    }else if ([message hasPrefix:@"DMX4OK"])
    {
//        NSString * statusStr = [ManagerTool  open:isOpen gesture:isGesture clock:isClock];
        
//        [ManagerTool  alert:[NSString  stringWithFormat:@"%@,%@",@"设置开关成功",statusStr]];
//        [self  checkRecommand];
        
    }else if([message  hasPrefix:@"DMX9"])
    {
//        [ManagerTool  alert:@"重置时间成功"];
    }else if ([message hasPrefix:@"DMXC"])
    {
        NSString * lightNumber = [message substringWithRange:NSMakeRange(5, 4)];
        if ([lightNumber hasPrefix:@"000"]) {
            lightNumber = [lightNumber  stringByReplacingOccurrencesOfString:@"000" withString:@""];
        }else if ([lightNumber hasPrefix:@"00"])
        {
            lightNumber = [lightNumber  stringByReplacingOccurrencesOfString:@"00" withString:@""];
        }else if ([lightNumber hasPrefix:@"0"])
        {
            lightNumber = [message substringWithRange:NSMakeRange(1, 3)];
        }
    }
    self.receiveData(message);

        
//        [self  alertViewWithMessage:[NSString  stringWithFormat:@"SD卡歌曲共有%@首",lightNumber]];

}

@end
