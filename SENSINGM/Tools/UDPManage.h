//
//  UDPManage.h
//  UDPDemo
//
//  Created by apple on 2018/7/13.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncUdpSocket.h"
//#import <GCDAsyncUdpSocket.h>
#define udpPort  25002

typedef void (^UDPReceiveData)(NSString * UDPdata);
@interface UDPManage : NSObject<GCDAsyncUdpSocketDelegate>
+(instancetype)shareUDPManage;
//查询信息
-(void)checkWeakLightInfo:(UDPReceiveData)data;
//广播
-(void)broadcastWithWifiName:(NSString *)wifiName passWord:(NSString *)passWord  getInfo:(UDPReceiveData)data;
@end
