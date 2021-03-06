//
//  YJSLoadingHeader.m
//  SENSINGM
//
//  Created by apple on 2018/7/11.
//  Copyright © 2018年 吴志刚. All rights reserved.
//

#import "YJSLoadingHeader.h"

@implementation YJSLoadingHeader


#pragma mark - 重写方法
#pragma mark 基本设置
- (void)prepare
{
    [super prepare];
    
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (int i = 1; i<=8; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_refresh_%d", i]];
        [idleImages addObject:image];
    }
    [self setImages:idleImages forState:MJRefreshStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (int i = 1; i<=8; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_refresh_%d", i]];
        [refreshingImages addObject:image];
    }
    [self setImages:refreshingImages forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
}


@end
