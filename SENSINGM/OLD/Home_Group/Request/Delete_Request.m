//
//  Delete_Request.m
//  SENSINGM
//
//  Created by apple on 2018/7/6.
//  Copyright © 2018年 吴志刚. All rights reserved.
//

#import "Delete_Request.h"

@implementation Delete_Request
- (NSString *)apiMethodName {
    return @"tbMemberGroup/deleteMemberGroup?key=z1zkey&code=MTJCNDgyOTIxOTk4QjUzQzM2QTlFN0ZFMzY0MDNEMjQ=&requestCode=-1";
}

- (LCRequestMethod)requestMethod {
    return LCRequestMethodPost;
}
@end
