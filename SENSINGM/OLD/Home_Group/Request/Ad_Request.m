

//
//  Ad_Request.m
//  SENSINGM
//
//  Created by apple on 2018/7/2.
//  Copyright © 2018年 吴志刚. All rights reserved.
//

#import "Ad_Request.h"

@implementation Ad_Request
- (NSString *)apiMethodName {
    return @"advertise/list?key=z1zkey&code=MTJCNDgyOTIxOTk4QjUzQzM2QTlFN0ZFMzY0MDNEMjQ=&requestCode=-1";
}

- (LCRequestMethod)requestMethod {
    return LCRequestMethodPost;
}

@end
