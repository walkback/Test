//
//  Switch_Request.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/7/12.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "Switch_Request.h"

@implementation Switch_Request

- (NSString *)apiMethodName {
    return @"tbAlarmClock/doTacSwitch?key=z1zkey&code=MTJCNDgyOTIxOTk4QjUzQzM2QTlFN0ZFMzY0MDNEMjQ=&requestCode=-1";
}

- (LCRequestMethod)requestMethod {
    return LCRequestMethodPost;
}

@end
