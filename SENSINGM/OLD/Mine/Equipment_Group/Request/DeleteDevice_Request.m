//
//  DeleteDevice_Request.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/7/12.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "DeleteDevice_Request.h"

@implementation DeleteDevice_Request

- (NSString *)apiMethodName {
    return @"memberDevice/delMemberDevice?key=z1zkey&code=MTJCNDgyOTIxOTk4QjUzQzM2QTlFN0ZFMzY0MDNEMjQ=&requestCode=-1";
}

- (LCRequestMethod)requestMethod {
    return LCRequestMethodPost;
}

@end
