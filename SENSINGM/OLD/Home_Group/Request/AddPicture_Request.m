
//
//  AddPicture_Request.m
//  SENSINGM
//
//  Created by apple on 2018/7/2.
//  Copyright © 2018年 吴志刚. All rights reserved.
//

#import "AddPicture_Request.h"

@implementation AddPicture_Request
/*
- (NSString *)apiMethodName {
    return @"add_file?key=z1zkey&code=MTJCNDgyOTIxOTk4QjUzQzM2QTlFN0ZFMzY0MDNEMjQ=&requestCode=-1";
}

- (LCRequestMethod)requestMethod {
    return LCRequestMethodPost;
}

- (AFConstructingBlock)constructingBodyBlock {
    return ^(id<AFMultipartFormData> formData) {
        for (UIImage *image in _images) {
            NSData *data = UIImageJPEGRepresentation(image, 0.01);
            NSString *name = @"file";
            NSString *formKey = @"file";
            NSString *type = @"image/jpeg";
            [formData appendPartWithFileData:data name:formKey fileName:name mimeType:type];
        }
    };
}*/

- (NSString *)apiMethodName{
    return @"/image/upload";
}



- (NSString *)customApiMethodName{
    return @"http://daily.xinpinget.com/image/upload";
}


- (LCRequestMethod)requestMethod{
    return LCRequestMethodPost;
}

- (id)responseProcess:(id)responseObject{
    return responseObject[@"result"][@"images"];
}



- (AFConstructingBlock)constructingBodyBlock {
    return ^(id<AFMultipartFormData> formData) {
        for (UIImage *image in _images) {
            NSData *data = UIImageJPEGRepresentation(image, 1.0);
            NSString *name = @"images";
            NSString *formKey = @"images";
            NSString *type = @"image/jpeg";
            [formData appendPartWithFileData:data name:formKey fileName:name mimeType:type];
        }
    };
}
@end
