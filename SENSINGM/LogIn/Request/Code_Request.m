//
//  Code_Request.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/6/21.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "Code_Request.h"

@implementation Code_Request

- (NSString *)apiMethodName {
    return @"vcode/get?key=z1zkey&code=MTJCNDgyOTIxOTk4QjUzQzM2QTlFN0ZFMzY0MDNEMjQ=&requestCode=-1";
}

- (LCRequestMethod)requestMethod {
    return LCRequestMethodPost;
}

@end
