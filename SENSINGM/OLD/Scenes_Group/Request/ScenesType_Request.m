//
//  ScenesType_Request.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/6/27.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "ScenesType_Request.h"

@implementation ScenesType_Request

- (NSString *)apiMethodName {
    return @"tbScene/tbSceneList?key=z1zkey&code=MTJCNDgyOTIxOTk4QjUzQzM2QTlFN0ZFMzY0MDNEMjQ=&requestCode=-1";
}

- (LCRequestMethod)requestMethod {
    return LCRequestMethodPost;
}

@end
