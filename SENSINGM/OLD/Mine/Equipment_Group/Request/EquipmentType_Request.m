//
//  EquipmentType_Request.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/6/29.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "EquipmentType_Request.h"

@implementation EquipmentType_Request

- (NSString *)apiMethodName {
    return @"tbMemberGroup/getMemberGroup?key=z1zkey&code=MTJCNDgyOTIxOTk4QjUzQzM2QTlFN0ZFMzY0MDNEMjQ=&requestCode=-1";
}

- (LCRequestMethod)requestMethod {
    return LCRequestMethodPost;
}

@end
