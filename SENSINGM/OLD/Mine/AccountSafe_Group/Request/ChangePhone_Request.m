//
//  ChangePhone_Request.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/6/26.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "ChangePhone_Request.h"

@implementation ChangePhone_Request

- (NSString *)apiMethodName {
    return @"member/updatePhone?key=z1zkey&code=MTJCNDgyOTIxOTk4QjUzQzM2QTlFN0ZFMzY0MDNEMjQ=&requestCode=-1";
}

- (LCRequestMethod)requestMethod {
    return LCRequestMethodPost;
}

@end
