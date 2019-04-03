
//
//  Group_Request.m
//  SENSINGM
//
//  Created by apple on 2018/7/6.
//  Copyright © 2018年 吴志刚. All rights reserved.
//

#import "Group_Request.h"

@implementation Group_Request
- (NSString *)apiMethodName {
    return @"tbMemberGroup/getMemberGroup?key=z1zkey&code=MTJCNDgyOTIxOTk4QjUzQzM2QTlFN0ZFMzY0MDNEMjQ=&requestCode=-1";
}

- (LCRequestMethod)requestMethod {
    return LCRequestMethodPost;
}
@end
