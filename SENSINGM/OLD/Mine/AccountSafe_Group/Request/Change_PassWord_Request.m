//
//  Change_PassWord_Request.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/6/22.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "Change_PassWord_Request.h"

@implementation Change_PassWord_Request

- (NSString *)apiMethodName {
    return @"member/updatePass?key=z1zkey&code=MTJCNDgyOTIxOTk4QjUzQzM2QTlFN0ZFMzY0MDNEMjQ=&requestCode=-1";
}

- (LCRequestMethod)requestMethod {
    return LCRequestMethodPost;
}

@end
