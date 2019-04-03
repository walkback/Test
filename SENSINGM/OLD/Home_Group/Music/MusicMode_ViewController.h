//
//  MusicMode_ViewController.h
//  SENSINGM
//
//  Created by 吴志刚 on 2018/6/20.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicMode_ViewController : UIViewController

@property (nonatomic, copy) NSString *title_string;
@property (nonatomic, copy) NSString *tmc_Id;

- (void)handleSlider:(UISlider *)slider;
@end
