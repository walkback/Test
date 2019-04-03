//
//  UIView+MLCore.h
//  SENSINGM
//
//  Created by 吴志刚 on 2018/12/13.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (MLCore)

- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii;

- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii
                 viewRect:(CGRect)rect;

@end

NS_ASSUME_NONNULL_END
