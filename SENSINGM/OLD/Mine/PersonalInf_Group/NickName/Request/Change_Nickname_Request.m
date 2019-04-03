//
//  Change_Nickname_Request.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/7/6.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "Change_Nickname_Request.h"

@implementation Change_Nickname_Request

- (NSString *)apiMethodName {
    return @"member/editTmiName?key=z1zkey&code=MTJCNDgyOTIxOTk4QjUzQzM2QTlFN0ZFMzY0MDNEMjQ=&requestCode=-1";
}

- (LCRequestMethod)requestMethod {
    return LCRequestMethodPost;
}

@end
