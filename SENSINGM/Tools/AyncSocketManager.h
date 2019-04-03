//
//  AyncSocketManager.h
//  UDPDemo
//
//  Created by apple on 2018/7/13.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"
//#import <GCDAsyncSocket.h>
typedef void (^ ReadReceiveData) (NSString *task);
@interface AyncSocketManager : NSObject
+(instancetype)shareAyncManager;
-(void)postRecommed:(NSString *)commend  result:(ReadReceiveData)receiveData;
@end
