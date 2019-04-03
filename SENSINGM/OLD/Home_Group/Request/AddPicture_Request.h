//
//  AddPicture_Request.h
//  SENSINGM
//
//  Created by apple on 2018/7/2.
//  Copyright © 2018年 吴志刚. All rights reserved.
//

#import "LCBaseRequest.h"

@interface AddPicture_Request : LCBaseRequest<LCAPIRequest>
@property (nonatomic, strong) NSArray *images;
@end
