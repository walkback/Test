

//
//  GroupDevice_Request.m
//  SENSINGM
//
//  Created by apple on 2018/7/9.
//  Copyright © 2018年 吴志刚. All rights reserved.
//

#import "GroupDevice_Request.h"

@implementation GroupDevice_Request
- (NSString *)apiMethodName {
    return @"tbMemberGroup/getMemberGroupDevice?key=z1zkey&code=MTJCNDgyOTIxOTk4QjUzQzM2QTlFN0ZFMzY0MDNEMjQ=&requestCode=-1";
}

- (LCRequestMethod)requestMethod {
    return LCRequestMethodPost;
}
@end
