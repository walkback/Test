//
//  Change_UesrName_Adress_Request.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/7/6.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "Change_UesrName_Adress_Request.h"

@implementation Change_UesrName_Adress_Request

- (NSString *)apiMethodName {
    return @"member/updateInfo?key=z1zkey&code=MTJCNDgyOTIxOTk4QjUzQzM2QTlFN0ZFMzY0MDNEMjQ=&requestCode=-1";
}

- (LCRequestMethod)requestMethod {
    return LCRequestMethodPost;
}

@end
