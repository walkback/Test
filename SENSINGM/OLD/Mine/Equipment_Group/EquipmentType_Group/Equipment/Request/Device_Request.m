//
//  Device_Request.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/7/3.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "Device_Request.h"

@implementation Device_Request

- (NSString *)apiMethodName {
    return @"tbMemberGroup/getMemberGroupDevice?key=z1zkey&code=MTJCNDgyOTIxOTk4QjUzQzM2QTlFN0ZFMzY0MDNEMjQ=&requestCode=-1";
}

- (LCRequestMethod)requestMethod {
    return LCRequestMethodPost;
}

@end
