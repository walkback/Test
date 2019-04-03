//
//  UDPManage.m
//  UDPDemo
//

/*
 //req_search:  返回数据rsp_search:mac=00-0e-c6-02-31-17,mcpu=1.3.9c,wcpu=2.0.800,cap=seany.uart
 //发送数据：req_get:   返回数据：rsp_get:nt=1,et=0,dhcp=1,cm=0,ct=0,dhcps=1,ssid=R2WiFi-1,srvp=5000,ip=192.168.2.3,mask=255.255.255.0,gw=192.168.2.3,dns=168.95.1.1,dhcpsb=192.168.2.4,dhcpse=192.168.2.10,uart2=2888,
 //发送数据很长-返回数据rsp_set:ret=1
 //HelloPeople   yjj123456
 //
 //    NSString *str = @"req_set:nt=0,ssid=HelloPeople,et=4,pass=yjj123456,dhcp=0,ip=192.168.2.3,mask=255.255.255.0,gw=192.168.2.3,dns=168.95.1.1,ct=0,cm=0,srvp=5000,";
 //    NSString * getData = @"req_get:";
 //    NSString * backUDP = @"req_set:nt=1,ssid=R2WiFi-1,et=0,dhcp=1,ip=192.168.2.3,mask=255.255.255.0,gw=192.168.2.3,dns=168.95.1.1";
 //    NSString * backUDPTwo = @"req_set:nt=1,et=0,dhcp=1,cm=0,ct=0,dhcps=1,ssid=R2WiFi-1,srvp=5000,ip=192.168.2.3,mask=255.255.255.0,gw=192.168.2.3,dns=168.95.1.1,dhcpsb=192.168.2.4,dhcpse=192.168.2.10,uart2=288";
 */
//  Created by apple on 2018/7/13.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "UDPManage.h"
@interface UDPManage( )
@property (strong, nonatomic)GCDAsyncUdpSocket * udpSocket;
@property (nonatomic, strong) UDPReceiveData  receiveData;
@end

static UDPManage *myUDPManage = nil;
@implementation UDPManage
+(instancetype)shareUDPManage{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        myUDPManage = [[UDPManage alloc]init];
        [myUDPManage createClientUdpSocket];
    });
    return myUDPManage;
}
-(void)createClientUdpSocket{
    //创建udp socket
    self.udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    
    //banding一个端口(可选),如果不绑定端口,那么就会随机产生一个随机的电脑唯一的端口
    NSError * error = nil;
    [self.udpSocket bindToPort:udpPort error:&error];
    //启用广播
    [self.udpSocket enableBroadcast:YES error:&error];
    if (error) {//监听错误打印错误信息
        NSLog(@"error:%@",error);
    }else {//监听成功则开始接收信息
        [self.udpSocket beginReceiving:&error];
    }
}

//查询信息
-(void)checkWeakLightInfo:(UDPReceiveData)data
{
    NSString *checkWeakLight = @"req_search:";
    NSData *checkData = [checkWeakLight dataUsingEncoding:NSUTF8StringEncoding];
    //此处如果写成固定的IP就是对特定的server监测
    //255.255.255.255
    NSString *host = @"192.168.2.3";
    //发送数据（tag: 消息标记）
    [self.udpSocket sendData:checkData toHost:host port:udpPort withTimeout:-1 tag:100];
    self.receiveData = data;
}
//广播
-(void)broadcastWithWifiName:(NSString *)wifiName passWord:(NSString *)passWord getInfo:(UDPReceiveData)data{
    
    self.receiveData = data;

    NSString *str = [NSString stringWithFormat:@"req_set:nt=0,ssid=%@,et=4,pass=%@,dhcp=0,ip=192.168.2.3,mask=255.255.255.0,gw=192.168.2.3,dns=168.95.1.1,ct=0,cm=0,srvp=5000,",wifiName,passWord];
    NSData *toSetData = [str dataUsingEncoding:NSUTF8StringEncoding];
    //此处如果写成固定的IP就是对特定的server监测
    //255.255.255.255
    NSString *host = @"192.168.2.3";
    //发送数据（tag: 消息标记）
    [self.udpSocket sendData:toSetData toHost:host port:udpPort withTimeout:-1 tag:100];
}

#pragma mark GCDAsyncUdpSocketDelegate
//发送数据成功
-(void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag{
    
    if (tag == 100) {
        NSLog(@"标记为100的数据发送完成了");
    }
}

//发送数据失败
-(void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error{
    NSLog(@"标记为%ld的数据发送失败，失败原因：%@",tag, error);
}

//接收到数据
-(void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext{
    
    NSString *ip = [GCDAsyncUdpSocket hostFromAddress:address];
    uint16_t port = [GCDAsyncUdpSocket portFromAddress:address];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"收到服务端的响应 [%@:%d] %@", ip, port, str);
    self.receiveData(ip);
}


@end
