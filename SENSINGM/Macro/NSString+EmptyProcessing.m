//
//  NSString+EmptyProcessing.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/6/21.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "NSString+EmptyProcessing.h"

@implementation NSString (EmptyProcessing)

+ (NSString *)stringIsEmpty:(NSString *)empString{
    NSString * string = [NSString stringWithFormat:@"%@",empString];
    
    if ([string isEqualToString:@""]||[string isEqualToString:@"(null)"]||[string isEqualToString:@"<null>"]||string==nil||[string isEqual:[NSNull class]]) {
        
        string=@"";
    }
    return string;
}
@end
