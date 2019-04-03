//
//  GetDeviceWifi_Request.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/7/11.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "GetDeviceWifi_Request.h"

@implementation GetDeviceWifi_Request

- (NSString *)apiMethodName {
    return @"tbDeviceInfo/getDeviceInfoByTdiNumber?key=z1zkey&code=MTJCNDgyOTIxOTk4QjUzQzM2QTlFN0ZFMzY0MDNEMjQ=&requestCode=-1";
}

- (LCRequestMethod)requestMethod {
    return LCRequestMethodPost;
}

@end
