//
//  AddFile_Request.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/7/3.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "AddFile_Request.h"

@implementation AddFile_Request

- (NSString *)apiMethodName {
    return @"add_file?key=z1zkey&code=MTJCNDgyOTIxOTk4QjUzQzM2QTlFN0ZFMzY0MDNEMjQ=&requestCode=-1";
}

- (LCRequestMethod)requestMethod {
    return LCRequestMethodPost;
}

- (AFConstructingBlock)constructingBodyBlock {
    return ^(id<AFMultipartFormData> formData) {

        NSData *data = UIImageJPEGRepresentation(self.image, 0.9);
        NSLog(@"%@",data);
        NSString *name = @"image";
        NSString *formKey = @"image";
        NSString *type = @"image/jpeg";
        [formData appendPartWithFileData:data name:formKey fileName:name mimeType:type];
    };
}


@end
