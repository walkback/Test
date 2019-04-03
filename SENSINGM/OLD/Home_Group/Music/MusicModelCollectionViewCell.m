


//
//  MusicModelCollectionViewCell.m
//  SENSINGM
//
//  Created by apple on 2018/7/11.
//  Copyright © 2018年 吴志刚. All rights reserved.
//

#import "MusicModelCollectionViewCell.h"

@implementation MusicModelCollectionViewCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //设置CollectionViewCell中的图像框
        self.collectionBackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        [self addSubview:self.collectionBackImageView];
        
        //文本框
        self.musicModelLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,( CGRectGetMaxY(self.collectionBackImageView.frame)  - 15)/2, CGRectGetWidth(self.frame), 15)];
        self.musicModelLabel.font = [UIFont systemFontOfSize:13];
        self.musicModelLabel.textColor = RGB(102, 102, 102);
        self.musicModelLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.musicModelLabel];
        
        //播放标记的图片
        self.remarkImageView = [[UIImageView  alloc]initWithFrame:CGRectMake(20, CGRectGetHeight(self.frame)/2 - 7.5, 15, 15)];
        [self addSubview:self.remarkImageView];

        
    }
    return self;
}

@end
