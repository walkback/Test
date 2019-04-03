//
//  ConnectionDevice_Request.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/7/11.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "ConnectionDevice_Request.h"

@implementation ConnectionDevice_Request

- (NSString *)apiMethodName {
    return @"memberDevice/tbMemberDeviceAdd?key=z1zkey&code=MTJCNDgyOTIxOTk4QjUzQzM2QTlFN0ZFMzY0MDNEMjQ=&requestCode=-1";
}

- (LCRequestMethod)requestMethod {
    return LCRequestMethodPost;
}


@end
