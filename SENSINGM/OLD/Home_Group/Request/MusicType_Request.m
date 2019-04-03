//
//  MusicType_Request.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/6/27.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "MusicType_Request.h"

@implementation MusicType_Request

- (NSString *)apiMethodName {
    return @"musicCatalog/list?key=z1zkey&code=MTJCNDgyOTIxOTk4QjUzQzM2QTlFN0ZFMzY0MDNEMjQ=&requestCode=-1";
}

- (LCRequestMethod)requestMethod {
    return LCRequestMethodPost;
}

@end
