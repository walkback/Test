//
//  LabelViewController.h
//  Alarm_Clock_UserNotifications
//
//  Created by 欧阳荣 on 2017/5/23.
//  Copyright © 2017年 欧阳荣. All rights reserved.
//

#import "BaseTableViewController.h"

typedef void(^ClockNameBlock) (NSString *clockname);

@interface LabelViewController : BaseTableViewController

@property (nonatomic, copy) ClockNameBlock clockNameBlock;

@end

