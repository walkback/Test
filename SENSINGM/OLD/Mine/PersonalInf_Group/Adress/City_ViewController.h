//
//  City_ViewController.h
//  SENSINGM
//
//  Created by 吴志刚 on 2018/7/4.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef void(^CityBlock) (NSString *city);

@interface City_ViewController : UIViewController

//@property (nonatomic, copy) CityBlock cityBlock;

@property (nonatomic, strong) NSString *pid;
@property (nonatomic, strong) NSString * pName; //省的名称

@end
