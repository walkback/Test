//
//  ForgetPassWord_Request.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/6/21.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "ForgetPassWord_Request.h"

@implementation ForgetPassWord_Request

- (NSString *)apiMethodName {
    return @"member/forgetPass?key=z1zkey&code=MTJCNDgyOTIxOTk4QjUzQzM2QTlFN0ZFMzY0MDNEMjQ=&requestCode=-1";
}

- (LCRequestMethod)requestMethod {
    return LCRequestMethodPost;
}

@end
